Class {
	#name : 'ScpMethodInstrumenter',
	#superclass : 'RBProgramNodeVisitor',
	#instVars : [
		'assignmentIndirection',
		'messageIndirection',
		'methodIndirection',
		'instrumentation'
	],
	#category : 'Scopeo-Method-Instrumentation',
	#package : 'Scopeo-Method-Instrumentation'
}

{ #category : 'parameters' }
ScpMethodInstrumenter >> addAssignmentIndirection: anIndirection [

	assignmentIndirection add: anIndirection

]

{ #category : 'parameters' }
ScpMethodInstrumenter >> addMessageIndirection: anIndirection [

	messageIndirection add: anIndirection
]

{ #category : 'adding' }
ScpMethodInstrumenter >> addMethodIndirection: aMethodIndirection [

	methodIndirection := aMethodIndirection
]

{ #category : 'testing' }
ScpMethodInstrumenter >> hasIndirectionForBody [

	^ messageIndirection isNotEmpty or: [ assignmentIndirection isNotEmpty ]
]

{ #category : 'testing' }
ScpMethodInstrumenter >> hasIndirectionForMethod [

	^ methodIndirection isNotNil 
]

{ #category : 'initialization' }
ScpMethodInstrumenter >> initialize [

	messageIndirection := Set new.
	assignmentIndirection := Set new
	
]

{ #category : 'services' }
ScpMethodInstrumenter >> instrument: aMethod [

	| ast instrumented |
	
	ast := self visitNode: aMethod ast.
	
	ast doSemanticAnalysis.
	ast source: ast formattedCode.
	
	instrumented := ast generateMethod.
	
	ScpMethodInstrumented adoptInstance: instrumented.
	instrumented instrumentation: instrumentation.
	instrumented instrumentedAst: ast.
	instrumented original: aMethod.
	
	^ instrumented 
]

{ #category : 'accessing' }
ScpMethodInstrumenter >> instrumentation: anInstrumentation [

	instrumentation := anInstrumentation
]

{ #category : 'visiting' }
ScpMethodInstrumenter >> visitArgumentNodes: anArgumentCollection [

	^ anArgumentCollection collect: [ :each | self visitVariableNode: each ]
]

{ #category : 'visiting' }
ScpMethodInstrumenter >> visitArrayNode: anArrayNode [

	^ RBArrayNode 
		statements: (anArrayNode statements collect: [ :each | self visitNode: each ]);
		yourself
]

{ #category : 'visiting' }
ScpMethodInstrumenter >> visitAssignmentNode: anAssignmentNode [

	assignmentIndirection
		detect: [ :in | in isApplicableFor: anAssignmentNode ]
		ifFound: [ :in | ^ in generateForNode: anAssignmentNode ].

	^ RBAssignmentNode
		variable: (self visitNode: anAssignmentNode variable) 
		value: (self visitNode: anAssignmentNode value)
]

{ #category : 'visiting' }
ScpMethodInstrumenter >> visitBlockNode: aBlockNode [

	^ RBBlockNode 
		arguments: (self visitArgumentNodes: aBlockNode arguments)
		body: (self visitNode: aBlockNode body)

]

{ #category : 'visiting' }
ScpMethodInstrumenter >> visitCascadeNode: aCascadeNode [

	"	
	Replace cascade messages with a block containing all the messages statements to enable message modification later on.
	Using a block makes it easier to ""flatten"" the cascade. 
	We avoid the need to insert the new nodes directly to the body of the method or to lookout for temporary variables conflicts.   
	However we might loose efficiency at runtime, maybe well need to benchmark and think about a smarter way to modify cascades in the future.
	
	Example:
	
		aReceiver                [ | receiver |    
			selector: arg;   ->     receiver := aReceiver.												 
			yourself                receiver selector: arg. 
			                        receiver yourself ] value
	"
	| receiverNode receiverNodeVariable statements |
	
	"Extract the cascade receiver into a new node (visit the receiver to modify it if it is a message)."
	receiverNode := self visitNode: aCascadeNode receiver.
	receiverNodeVariable := RBVariableNode named: 'receiver_' , aCascadeNode hash asString.

	"Transform cascading messages into a list of statment messages."
	statements := OrderedCollection new.
	statements add: (RBAssignmentNode variable: receiverNodeVariable value: receiverNode).
	statements addAll: (aCascadeNode messages collect: [ :m | 
		"Create new messages and apply modifications if needed."
		self visitNode: (RBMessageNode
			receiver: receiverNodeVariable 
			selector: m selector 
			arguments: m arguments)
	]).

	^ RBMessageNode
		receiver: (RBBlockNode 
			body: (RBSequenceNode
				temporaries: { receiverNodeVariable }
				statements: statements))
		selector: #value 
]

{ #category : 'visiting' }
ScpMethodInstrumenter >> visitLiteralArrayNode: aRBLiteralArrayNode [

	^ aRBLiteralArrayNode 
]

{ #category : 'visiting' }
ScpMethodInstrumenter >> visitLiteralNode: aLiteralNode [

	^ aLiteralNode copy
]

{ #category : 'visiting' }
ScpMethodInstrumenter >> visitMessageNode: aMessageNode [
	
	messageIndirection
		detect: [ :in | in isApplicableFor: aMessageNode ]
		ifFound: [ :in | ^ in generateForNode: aMessageNode ].

	^ RBMessageNode 
		receiver: (self visitNode: aMessageNode receiver) 
		selector: aMessageNode selector
		arguments: (aMessageNode arguments collect: [ :a | 
			self visitNode: a.
		]) 
]

{ #category : 'visiting' }
ScpMethodInstrumenter >> visitMethodNode: aMethodNode [

	| methodNode indirection |

	self hasIndirectionForMethod ifFalse: [
		^ (RBMethodNode
				selector: aMethodNode selector 
				arguments: (self visitArgumentNodes: aMethodNode arguments)
				body: (self visitNode: aMethodNode body))
				methodClass: aMethodNode methodClass;
				pragmas: (self visitPragmaNodes: aMethodNode pragmas);
				yourself		
	].
	
	"Avoid infinite recursion in case there is a method indirection."
	indirection := methodIndirection.
	methodIndirection := nil.
	
	methodNode := indirection generateForNode: aMethodNode.
	
	methodIndirection := indirection.
	
	^ methodNode 
]

{ #category : 'visiting' }
ScpMethodInstrumenter >> visitPragmaNode: aPragmaNode [
	
	^ RBPragmaNode 
		selector: aPragmaNode selector
		arguments: (self visitArgumentNodes: aPragmaNode arguments)
	
]

{ #category : 'visiting' }
ScpMethodInstrumenter >> visitPragmaNodes: aNodeCollection [

	^ aNodeCollection collect: [ :each | self visitPragmaNode: each ].
]

{ #category : 'visiting' }
ScpMethodInstrumenter >> visitReturnNode: aReturnNode [

	^ RBReturnNode
		value: (self visitNode: aReturnNode value)
]

{ #category : 'visiting' }
ScpMethodInstrumenter >> visitSequenceNode: aSequenceNode [

	^ RBSequenceNode 
		temporaries: (self visitTemporaryNodes: aSequenceNode temporaries) 
		statements: (aSequenceNode statements collect: [ :s | 
			self visitNode: s.
		])
]

{ #category : 'visiting' }
ScpMethodInstrumenter >> visitTemporaryNodes: anTemporaryCollection [

	^ anTemporaryCollection collect: [ :each | self visitVariableNode: each ]
]

{ #category : 'visiting' }
ScpMethodInstrumenter >> visitVariableNode: aVariableNode [
	
	^ aVariableNode copy
]
