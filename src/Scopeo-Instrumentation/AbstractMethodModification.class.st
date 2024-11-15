Class {
	#name : #AbstractMethodModification,
	#superclass : #RBProgramNodeVisitor,
	#traits : 'MethodModification',
	#classTraits : 'MethodModification classTrait',
	#instVars : [
		'temporary',
		'sequence',
		'argumentIndex'
	],
	#category : #'Scopeo-Instrumentation-GenericMethodModification'
}

{ #category : #accessing }
AbstractMethodModification class >> transform: aMethod [

	 ^ self new visitMethod: aMethod
]

{ #category : #applying }
AbstractMethodModification >> applyOn: aMethodNode [

	^ self visitMethodNode: aMethodNode
]

{ #category : #'as yet unclassified' }
AbstractMethodModification >> modificationAfterAssignment: anAssignmentNode [

	^ nil
]

{ #category : #'as yet unclassified' }
AbstractMethodModification >> modificationAfterMessage: aMessageNode [

	^ nil
]

{ #category : #'as yet unclassified' }
AbstractMethodModification >> modificationBeforeAssignment: anAssignmentNode [

	^ nil
]

{ #category : #'as yet unclassified' }
AbstractMethodModification >> modificationBeforeMessage: aMessageNode [

	^ nil
]

{ #category : #'as yet unclassified' }
AbstractMethodModification >> modificationBeforeMethod: aMethodNode [

	^ nil
]

{ #category : #'as yet unclassified' }
AbstractMethodModification >> modificationBeforeReturn: aReturnNode [

	^ nil
]

{ #category : #'as yet unclassified' }
AbstractMethodModification >> modificationInsteadAssignment: anAssignmentNode [

	^ nil
]

{ #category : #'as yet unclassified' }
AbstractMethodModification >> modificationInsteadMessage: aMessageNode [

	^ nil
]

{ #category : #'as yet unclassified' }
AbstractMethodModification >> modificationInsteadMethod: aMethodNode [

	^ nil
]

{ #category : #'as yet unclassified' }
AbstractMethodModification >> modificationInsteadReturn: aReturnNode [

	^ nil
]

{ #category : #accessing }
AbstractMethodModification >> newArgumentIndex [

	argumentIndex := 0
]

{ #category : #accessing }
AbstractMethodModification >> nodeForNextArgument [

	| argument |
	
	argumentIndex := argumentIndex + 1.
	argument := '_arg' , argumentIndex asString.

	(self sequence temporaryNames includes: argument) ifFalse: [
		self sequence addTemporaryNamed: argument
	].
	
	^ RBVariableNode named: argument
]

{ #category : #accessing }
AbstractMethodModification >> nodeForTemporaryVariable [

	^ temporary ifNil: [ temporary := RBVariableNode named: #_tmp ]
]

{ #category : #accessing }
AbstractMethodModification >> sequence [

	^ sequence
]

{ #category : #accessing }
AbstractMethodModification >> sequence: aSequence [

	sequence := aSequence
]

{ #category : #visiting }
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

{ #category : #visiting }
AbstractMethodModification >> visitArrayNode: anArrayNode [

	| statements arguments |
	
	statements := OrderedCollection new.

	arguments := self visitArguments: anArrayNode children.

	anArrayNode statements: arguments first.
	
	statements addAll: arguments second.
	statements add: anArrayNode.

	^ statements 
]

{ #category : #visiting }
AbstractMethodModification >> visitAssignmentNode: anAssignmentNode [

	| statements value |

	statements := OrderedCollection new.
	
	value := self visitNode: anAssignmentNode value.
	
	value isCollection ifTrue: [ 
		anAssignmentNode value: self nodeForTemporaryVariable.
		statements addAll: value.
	].

	(self modificationBeforeAssignment: anAssignmentNode) 
		ifNotNil: [ :n | statements add: n ].
		
	(self modificationInsteadAssignment: anAssignmentNode) 
		ifNil: [ statements add: anAssignmentNode ] 
		ifNotNil: [ :n | statements add: n ].
	
	(self modificationAfterAssignment: anAssignmentNode) 
		ifNotNil: [ :n | statements add: n ].
	
	^ statements
]

{ #category : #visiting }
AbstractMethodModification >> visitBlockNode: aBlockNode [

	self visitNode: aBlockNode body.
	
	^ aBlockNode
]

{ #category : #visiting }
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

{ #category : #visiting }
AbstractMethodModification >> visitLiteralArrayNode: aRBLiteralArrayNode [

	^ aRBLiteralArrayNode
]

{ #category : #visiting }
AbstractMethodModification >> visitLiteralNode: aLiteralNode [

	^ aLiteralNode
]

{ #category : #visiting }
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
		ifNotNil: [ :n | statements add: n ]
		ifNil: [
			(self modificationBeforeMessage: aMessageNode) 
				ifNotNil: [ :n | statements add: n ].
			statements add: (RBAssignmentNode 
				variable: self nodeForTemporaryVariable 
				value: aMessageNode
			).
			(self modificationAfterMessage: aMessageNode) 
				ifNotNil: [ :n | statements add: n ]	
		].
		
	^ statements

]

{ #category : #visiting }
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

{ #category : #visiting }
AbstractMethodModification >> visitReturnNode: aReturnNode [

	| statements value |

	statements := OrderedCollection new.
	
	value := self visitNode: aReturnNode value.
	value isCollection ifTrue: [ 
		aReturnNode value: self nodeForTemporaryVariable.
		statements addAll: value.
	].

	(self modificationInsteadReturn: aReturnNode)
		ifNotNil: [ :n | statements add: n ]
		ifNil: [ 
			(self modificationBeforeReturn: aReturnNode) 
				ifNotNil: [ :n | statements add: n ].
			statements add: aReturnNode.	
		].

	^ statements
]

{ #category : #visiting }
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
	
	^ aSequenceNode.

]
