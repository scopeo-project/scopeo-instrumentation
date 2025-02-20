Class {
	#name : 'ScpMethodModifier',
	#superclass : 'RBProgramNodeVisitor',
	#instVars : [
		'currentMethod',
		'assignmentIndirection',
		'messageIndirection',
		'returnIndirection'
	],
	#category : 'Scopeo-Method-Instrumentation',
	#package : 'Scopeo-Method-Instrumentation'
}

{ #category : 'parameters' }
ScpMethodModifier >> addAssignmentIndirection: anIndirection [

	assignmentIndirection add: anIndirection

]

{ #category : 'parameters' }
ScpMethodModifier >> addMessageIndirection: anIndirection [

	messageIndirection add: anIndirection
]

{ #category : 'parameters' }
ScpMethodModifier >> addReturnIndirection: anIndirection [

	returnIndirection add: anIndirection.
	anIndirection visitor: self
]

{ #category : 'initialization' }
ScpMethodModifier >> initialize [

	returnIndirection := Set new.
	messageIndirection := Set new.
	assignmentIndirection := Set new
	
]

{ #category : 'visiting' }
ScpMethodModifier >> visitArrayNode: anArrayNode [

	^ RBArrayNode 
		statements: (anArrayNode statements collect: [ :each | self visitNode: each ]);
		yourself
]

{ #category : 'visiting' }
ScpMethodModifier >> visitAssignmentNode: anAssignmentNode [

	assignmentIndirection
		detect: [ :in | in isApplicableFor: anAssignmentNode ]
		ifFound: [ :in | ^ in generateFor: anAssignmentNode usingModifier: self ].

	^ RBAssignmentNode
		variable: (self visitNode: anAssignmentNode variable) 
		value: (self visitNode: anAssignmentNode value)
]

{ #category : 'visiting' }
ScpMethodModifier >> visitBlockNode: aBlockNode [

	^ RBBlockNode 
		arguments: aBlockNode arguments 
		body: (self visitNode: aBlockNode body)

]

{ #category : 'visiting' }
ScpMethodModifier >> visitCascadeNode: aCascadeNode [

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
		m receiver: receiverNodeVariable.
		
		"Visit all the newly created messages to apply modifications if needed."
		self visitNode: m
	]).

	^ RBMessageNode
		receiver: (RBBlockNode 
			body: (RBSequenceNode
				temporaries: { receiverNodeVariable }
				statements: statements))
		selector: #value 
]

{ #category : 'visiting' }
ScpMethodModifier >> visitLiteralArrayNode: aRBLiteralArrayNode [

	^ aRBLiteralArrayNode 
]

{ #category : 'visiting' }
ScpMethodModifier >> visitLiteralNode: aLiteralNode [

	^ aLiteralNode
]

{ #category : 'visiting' }
ScpMethodModifier >> visitMessageNode: aMessageNode [
	
	messageIndirection
		detect: [ :in | in isApplicableFor: aMessageNode ]
		ifFound: [ :in | ^ in generateFor: aMessageNode usingModifier: self ].

	^ RBMessageNode 
		receiver: (self visitNode: aMessageNode receiver) 
		selector: aMessageNode selector
		arguments: (aMessageNode arguments collect: [ :a | 
			self visitNode: a.
		]) 
]

{ #category : 'visiting' }
ScpMethodModifier >> visitMethod: aMethod [

	| ast |
	
	ast := self visitNode: aMethod ast.
	
	ast doSemanticAnalysis.
	ast source: ast formattedCode.
	
	^ ast 
	
]

{ #category : 'visiting' }
ScpMethodModifier >> visitMethodNode: aMethodNode [

	^ (RBMethodNode
		selector: aMethodNode selector 
		arguments: aMethodNode arguments
		body: (self visitNode: aMethodNode body))
		methodClass: aMethodNode methodClass;
		pragmas: aMethodNode pragmas
]

{ #category : 'visiting' }
ScpMethodModifier >> visitReturnNode: aReturnNode [

	^ RBReturnNode
		value: (self visitNode: aReturnNode value)
]

{ #category : 'visiting' }
ScpMethodModifier >> visitSequenceNode: aSequenceNode [

	^ RBSequenceNode 
		temporaries: aSequenceNode temporaries 
		statements: (aSequenceNode statements collect: [ :s | 
			self visitNode: s.
		])
]

{ #category : 'visiting' }
ScpMethodModifier >> visitVariableNode: aVariableNode [
	
	^ aVariableNode
]
