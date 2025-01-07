Class {
	#name : 'ScpMethodModifier',
	#superclass : 'RBProgramNodeVisitor',
	#instVars : [
		'currentMethod',
		'assignmentIndirection',
		'messageIndirection',
		'returnIndirection'
	],
	#category : 'Scopeo-Method-Instrumentation-Core',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Core'
}

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

{ #category : 'parameters' }
ScpMethodModifier >> registerAssignmentInstrumentation: anIndirection [

	assignmentIndirection add: anIndirection

]

{ #category : 'parameters' }
ScpMethodModifier >> registerMessageInstrumentation: anIndirection [

	messageIndirection add: anIndirection
]

{ #category : 'visiting' }
ScpMethodModifier >> visitArrayNode: anArrayNode [

	^ anArrayNode 
		statements: (anArrayNode statements collect: [ :each | self visitNode: each ]);
		yourself
]

{ #category : 'visiting' }
ScpMethodModifier >> visitAssignmentNode: anAssignmentNode [

	assignmentIndirection
		detect: [ :in | in isApplicableFor: anAssignmentNode ]
		ifFound: [ :in | ^ in generateFor: anAssignmentNode usingModifier: self ].

	anAssignmentNode value: (self visitNode: anAssignmentNode value).
	
	^ anAssignmentNode
]

{ #category : 'visiting' }
ScpMethodModifier >> visitBlockNode: aBlockNode [

	^ aBlockNode
		body: (self visitNode: aBlockNode body);
		yourself
]

{ #category : 'visiting' }
ScpMethodModifier >> visitCascadeNode: aCascadeNode [

	| receiverNode receiverNodeVariable statements cascadeNode |

	receiverNode := aCascadeNode receiver.
	receiverNodeVariable := RBVariableNode named: #receiver.

	statements := OrderedCollection new.
	statements add: ((RBAssignmentNode variable: receiverNodeVariable value: receiverNode) acceptVisitor: self).
	
	statements addAll: (aCascadeNode messages collect: [ :m | m receiver: receiverNodeVariable ]).
	statements := statements collect: [ :s | s acceptVisitor: self ].

	cascadeNode := (RBMessageNode
		  receiver: (RBBlockNode body: (RBSequenceNode
					    temporaries: { receiverNodeVariable }
					    statements: statements))
		  selector: #value).

	^ cascadeNode 
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

	aMessageNode receiver: (self visitNode: aMessageNode receiver).
	aMessageNode arguments: (aMessageNode arguments collect: [ :each | 
		self visitNode: each 
	]).
	
	^ aMessageNode
]

{ #category : 'visiting' }
ScpMethodModifier >> visitMethod: aMethod [

	| ast |
	
	ast := aMethod parseTree.
	self visitNode: ast.
	
	ast doSemanticAnalysis.
	ast source: ast formattedCode.
	
	^ ast 
	
]

{ #category : 'visiting' }
ScpMethodModifier >> visitMethodNode: aMethodNode [

	super visitMethodNode: aMethodNode.
	
	^ aMethodNode 
]

{ #category : 'visiting' }
ScpMethodModifier >> visitReturnNode: aReturnNode [

	aReturnNode value: (self visitNode: aReturnNode value).
	
	^ aReturnNode
]

{ #category : 'visiting' }
ScpMethodModifier >> visitSequenceNode: aSequenceNode [

	aSequenceNode statements: (aSequenceNode statements collect: [ :s | 
		self visitNode: s.
	]).

	^ aSequenceNode
]

{ #category : 'visiting' }
ScpMethodModifier >> visitVariableNode: aVariableNode [
	
	^ aVariableNode
]
