Class {
	#name : 'AbstractMethodModification',
	#superclass : 'RBProgramNodeVisitor',
	#traits : 'MethodModification',
	#classTraits : 'MethodModification classTrait',
	#instVars : [
		'temporary',
		'sequence',
		'argumentIndex'
	],
	#category : 'Scopeo-Instrumentation-GenericMethodModification',
	#package : 'Scopeo-Instrumentation',
	#tag : 'GenericMethodModification'
}

{ #category : 'applying' }
AbstractMethodModification >> applyOn: aMethodNode [

	^ self visitMethodNode: aMethodNode
]

{ #category : 'modifications' }
AbstractMethodModification >> modificationAfterAssignment: anAssignmentNode [

	^ nil
]

{ #category : 'modifications' }
AbstractMethodModification >> modificationAfterMessage: aMessageNode [

	^ nil
]

{ #category : 'modifications' }
AbstractMethodModification >> modificationBeforeAssignment: anAssignmentNode [

	^ nil
]

{ #category : 'modifications' }
AbstractMethodModification >> modificationBeforeMessage: aMessageNode [

	^ nil
]

{ #category : 'modifications' }
AbstractMethodModification >> modificationBeforeMethod: aMethodNode [

	^ nil
]

{ #category : 'modifications' }
AbstractMethodModification >> modificationBeforeReturn: aReturnNode [

	^ nil
]

{ #category : 'modifications' }
AbstractMethodModification >> modificationInsteadAssignment: anAssignmentNode [

	^ nil
]

{ #category : 'modifications' }
AbstractMethodModification >> modificationInsteadMessage: aMessageNode [

	^ nil
]

{ #category : 'modifications' }
AbstractMethodModification >> modificationInsteadMethod: aMethodNode [

	^ nil
]

{ #category : 'modifications' }
AbstractMethodModification >> modificationInsteadReturn: aReturnNode [

	^ nil
]

{ #category : 'modifications' }
AbstractMethodModification >> modificationInsteadSelfVariable: aMessageNode [

	^ nil
]

{ #category : 'modifications' }
AbstractMethodModification >> modificationInsteadSuperVariable: aMessageNode [

	^ nil
]

{ #category : 'visiting' }
AbstractMethodModification >> modificationInsteadVariable: aVariableNode [

	^ nil
]

{ #category : 'accessing' }
AbstractMethodModification >> newArgumentIndex [

	argumentIndex := 0
]

{ #category : 'accessing' }
AbstractMethodModification >> nodeForNextArgument [

	| argument |
	
	argumentIndex := argumentIndex + 1.
	argument := '_arg' , argumentIndex asString.

	(self sequence temporaryNames includes: argument) ifFalse: [
		self sequence addTemporaryNamed: argument
	].
	
	^ RBVariableNode named: argument
]

{ #category : 'accessing' }
AbstractMethodModification >> nodeForTemporaryVariable [

	^ temporary ifNil: [ temporary := RBVariableNode named: #_tmp ]
]

{ #category : 'accessing' }
AbstractMethodModification >> sequence [

	^ sequence
]

{ #category : 'accessing' }
AbstractMethodModification >> sequence: aSequence [

	sequence := aSequence
]

{ #category : 'visiting' }
AbstractMethodModification >> visitArguments: aNodeCollection [	

	| temp arguments statements value |

	arguments := OrderedCollection new.
	statements := OrderedCollection new.

	aNodeCollection do: [ :n |
		value := self visitNode: n.
		value isCollection 
			ifTrue: [
				temp := self nodeForNextArgument.
				statements addAll: value.
				statements add: (RBAssignmentNode 
					variable: temp 
					value: self nodeForTemporaryVariable
				).
				arguments add: temp.
			]
			ifFalse: [ 
				arguments add: value.
			]
		
	].
	self newArgumentIndex.

	^ { arguments . statements } 
]

{ #category : 'visiting' }
AbstractMethodModification >> visitArrayNode: anArrayNode [

	| statements arguments |
	
	statements := OrderedCollection new.

	arguments := self visitArguments: anArrayNode children.

	anArrayNode statements: arguments first.
	
	statements addAll: arguments second.
	statements add: anArrayNode.

	^ statements 
]

{ #category : 'visiting' }
AbstractMethodModification >> visitAssignmentNode: anAssignmentNode [

	| statements value |

	statements := OrderedCollection new.
	
	value := self visitNode: anAssignmentNode value.
	
	value isCollection ifTrue: [ 
		anAssignmentNode value: self nodeForTemporaryVariable.
		statements addAll: value.
	].

	(self modificationBeforeAssignment: anAssignmentNode) 
		ifNotNil: [ :n | statements addAll: n ].
		
	(self modificationInsteadAssignment: anAssignmentNode) 
		ifNil: [ statements add: anAssignmentNode ] 
		ifNotNil: [ :n | statements addAll: n ].
	
	(self modificationAfterAssignment: anAssignmentNode) 
		ifNotNil: [ :n | statements addAll: n ].
	
	^ statements
]

{ #category : 'visiting' }
AbstractMethodModification >> visitBlockNode: aBlockNode [

	self visitNode: aBlockNode body.
	
	^ aBlockNode
]

{ #category : 'visiting' }
AbstractMethodModification >> visitCascadeNode: aCascadeNode [

	| statements receiver |

	statements := OrderedCollection new.

	receiver := self visitNode: aCascadeNode receiver.
	receiver isCollection ifTrue: [
		receiver := self nodeForTemporaryVariable.
		statements addAll: receiver.
	].

	statements addAll: (aCascadeNode messages flatCollect: [ :m |
		m receiver: receiver. 
		self visitNode: m
	]).

	^ statements
]

{ #category : 'visiting' }
AbstractMethodModification >> visitLiteralArrayNode: aRBLiteralArrayNode [

	^ aRBLiteralArrayNode
]

{ #category : 'visiting' }
AbstractMethodModification >> visitLiteralNode: aLiteralNode [

	^ aLiteralNode
]

{ #category : 'visiting' }
AbstractMethodModification >> visitMessageNode: aMessageNode [

	| statements receiver arguments  |
	
	statements := OrderedCollection new.
	
	receiver := self visitNode: aMessageNode receiver.
	receiver isCollection ifTrue: [ 
		aMessageNode receiver: self nodeForTemporaryVariable.
		statements addAll: receiver
	].
	
	arguments := self visitArguments: aMessageNode arguments.

	aMessageNode arguments: arguments first.	
	
	statements addAll: arguments second.
	
	(self modificationInsteadMessage: aMessageNode)
		ifNotNil: [ :n | 
			statements add: (RBAssignmentNode 
				variable: self nodeForTemporaryVariable 
				value: n)
		]
		ifNil: [
			(self modificationBeforeMessage: aMessageNode) 
				ifNotNil: [ :n | statements addAll: n ].
			statements add: (RBAssignmentNode 
				variable: self nodeForTemporaryVariable 
				value: aMessageNode
			).
			(self modificationAfterMessage: aMessageNode) 
				ifNotNil: [ :n | statements addAll: n ]	
		].
		
	^ statements

]

{ #category : 'visiting' }
AbstractMethodModification >> visitMethodNode: aMethodNode [

	(self modificationInsteadMethod: aMethodNode) ifNotNil: [ :n | ^ n ].
	
	self newArgumentIndex.

	self sequence: aMethodNode body.

	aMethodNode body addSelfReturn.
	
	self visitNode: aMethodNode body.
	
	(self modificationBeforeMethod: aMethodNode) 
		ifNotNil: [ :n | aMethodNode body addNodesFirst: n ].

	^ aMethodNode
]

{ #category : 'visiting' }
AbstractMethodModification >> visitReturnNode: aReturnNode [

	| statements value |

	statements := OrderedCollection new.
	
	value := self visitNode: aReturnNode value.
	value isCollection ifTrue: [ 
		aReturnNode value: self nodeForTemporaryVariable.
		statements addAll: value.
	].

	(self modificationInsteadReturn: aReturnNode)
		ifNotNil: [ :n | statements addAll: n ]
		ifNil: [ 
			(self modificationBeforeReturn: aReturnNode) 
				ifNotNil: [ :n | statements addAll: n ].
			statements add: aReturnNode.	
		].

	^ statements
]

{ #category : 'visiting' }
AbstractMethodModification >> visitSelfNode: aSelfNode [

	(self modificationInsteadSelfVariable: aSelfNode) 
		ifNotNil: [ :n | ^ n ].
		
	^ aSelfNode
	
	
]

{ #category : 'visiting' }
AbstractMethodModification >> visitSequenceNode: aSequenceNode [

	| oldStatements newStatements |

	aSequenceNode parent isBlock ifFalse: [  
		aSequenceNode addTemporaryNamed: self nodeForTemporaryVariable name.
	].

	oldStatements := aSequenceNode statements.
	aSequenceNode statements: Array empty.
	oldStatements do: [ :s | 
		newStatements := self visitNode: s.
		newStatements isCollection 
			ifTrue: [ aSequenceNode addNodes: newStatements ]
			ifFalse: [ aSequenceNode addNode: newStatements ]
	].
	
	^ aSequenceNode

]

{ #category : 'visiting' }
AbstractMethodModification >> visitSuperNode: aSuperNode [

	(self modificationInsteadSuperVariable: aSuperNode) 
		ifNotNil: [ :n | ^ n ].
		
	^ aSuperNode
	
	
]

{ #category : 'visiting' }
AbstractMethodModification >> visitVariableNode: aVariableNode [

	(self modificationInsteadVariable: aVariableNode)
		ifNotNil: [ :n | ^ n ].
		
	^ aVariableNode
]
