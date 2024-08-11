Class {
	#name : 'ScpInstrumentationMethodVisitor',
	#superclass : 'RBProgramNodeVisitor',
	#instVars : [
		'sequences',
		'temporary',
		'nodeIdentifierIndex',
		'indirection',
		'sequence',
		'argumentIndex'
	],
	#category : 'Scopeo-Instrumentation',
	#package : 'Scopeo-Instrumentation'
}

{ #category : 'accessing' }
ScpInstrumentationMethodVisitor class >> transform: aMethod [

	 ^ self new visitMethod: aMethod
]

{ #category : 'accessing' }
ScpInstrumentationMethodVisitor >> newArgumentIndex [

	argumentIndex := 0
]

{ #category : 'accessing' }
ScpInstrumentationMethodVisitor >> nextArgument [

	| argument |
	
	argumentIndex := argumentIndex + 1.
	argument := '_arg' , argumentIndex asString.

	(self sequence temporaryNames includes: argument) ifFalse: [
		self sequence addTemporaryNamed: argument
	].
	
	^ RBVariableNode named: argument
]

{ #category : 'instrumenting' }
ScpInstrumentationMethodVisitor >> nodeAfterMessage: aMessageNode [

	aMessageNode receiver isBlock ifTrue: [ ^ nil ].
	
	^ RBMessageNode
		  receiver: self nodeHandler
		  selector: (ScpInstrumentationHandler >> #node:messageReturn:) selector
		  arguments: {
				  (RBLiteralValueNode value: aMessageNode selectorNode start).
				  self temporary 
			}
]

{ #category : 'instrumenting' }
ScpInstrumentationMethodVisitor >> nodeBeforeAssignment: anAssignmentNode [

	anAssignmentNode variable isInstanceVariable ifFalse: [ ^ nil ].

	^ RBMessageNode
		  receiver: self nodeHandler
		  selector: (ScpInstrumentationHandler >> #node:assignment:object:value:) selector
		  arguments: {
				  (RBLiteralValueNode value: anAssignmentNode start).
				  (RBLiteralValueNode value: anAssignmentNode variable name).
				  (RBVariableNode selfNode).
				  anAssignmentNode value 
			}
]

{ #category : 'instrumenting' }
ScpInstrumentationMethodVisitor >> nodeBeforeMessage: aMessageNode [
	
	aMessageNode receiver isBlock ifTrue: [ ^ nil ].

	aMessageNode receiver isSuperVariable ifTrue: [ 
		^ self nodeBeforeSuperMessage: aMessageNode 
	].

	^ RBMessageNode
		  receiver: self nodeHandler
		  selector: (ScpInstrumentationHandler >> #node:message:sender:receiver:arguments:) selector
		  arguments: {
				  (RBLiteralValueNode value: aMessageNode selectorNode start).
				  (RBLiteralValueNode value: aMessageNode selector).
				  RBVariableNode selfNode.
				  aMessageNode receiver.
				  (RBArrayNode statements: aMessageNode arguments)
		  }
]

{ #category : 'instrumenting' }
ScpInstrumentationMethodVisitor >> nodeBeforeReturn: aReturnNode [

	^ RBMessageNode
		  receiver: self nodeHandler
		  selector: (ScpInstrumentationHandler >> #node:methodReturn:) selector
		  arguments: {
				  (RBLiteralValueNode value: aReturnNode start).
				  aReturnNode value 
		  }
]

{ #category : 'instrumenting' }
ScpInstrumentationMethodVisitor >> nodeBeforeSuperMessage: aMessageNode [

	^ RBMessageNode
		  receiver: self nodeHandler
		  selector: (ScpInstrumentationHandler >> #node:super:sender:arguments:) selector
		  arguments: {
			  	  (RBLiteralValueNode value: aMessageNode selectorNode start).
				  (RBLiteralValueNode value: aMessageNode selector).
				  RBVariableNode selfNode.
				  (RBArrayNode statements: aMessageNode arguments) 
		  }
]

{ #category : 'instrumenting' }
ScpInstrumentationMethodVisitor >> nodeHandler [

	^ RBVariableNode named: #_SCOPEO
]

{ #category : 'instrumenting' }
ScpInstrumentationMethodVisitor >> nodeMethodEntry: aMethodNode [

	^ RBMessageNode
		 receiver: self nodeHandler
		 selector: (ScpInstrumentationHandler >> #method:sender:receiver:arguments:) selector
		 arguments: {
			 (RBLiteralValueNode value: aMethodNode selector).
			 self nodeSender.
			 RBVariableNode selfNode.
			 (RBArrayNode statements: aMethodNode arguments) 
		}
	
]

{ #category : 'instrumenting' }
ScpInstrumentationMethodVisitor >> nodeSender [

	^ RBMessageNode
		  receiver: (RBMessageNode
				   receiver: (RBVariableNode named: #thisContext)
				   selector: #sender)
		  selector: #receiver
]

{ #category : 'accessing' }
ScpInstrumentationMethodVisitor >> sequence [

	^ sequence
]

{ #category : 'accessing' }
ScpInstrumentationMethodVisitor >> sequence: aSequence [

	sequence := aSequence
]

{ #category : 'accessing' }
ScpInstrumentationMethodVisitor >> temporary [

	^ temporary
]

{ #category : 'accessing' }
ScpInstrumentationMethodVisitor >> temporary: aName [

	temporary := RBVariableNode named: aName
]

{ #category : 'visiting' }
ScpInstrumentationMethodVisitor >> visitArguments: aNodeCollection [	

	| temp arguments statements value |

	arguments := OrderedCollection new.
	statements := OrderedCollection new.

	aNodeCollection do: [ :n |
		value := self visit: n.
		value isCollection 
			ifTrue: [
				temp := self nextArgument.
				statements addAll: value.
				statements add: (RBAssignmentNode 
					variable: temp 
					value: self temporary
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
ScpInstrumentationMethodVisitor >> visitArrayNode: anArrayNode [

	| statements arguments |
	
	statements := OrderedCollection new.

	arguments := self visitArguments: anArrayNode children.

	anArrayNode statements: arguments first.
	
	statements addAll: arguments second.
	statements add: anArrayNode.

	^ statements 
]

{ #category : 'visiting' }
ScpInstrumentationMethodVisitor >> visitAssignmentNode: anAssignmentNode [

	| statements value |

	statements := OrderedCollection new.
	
	value := self visit: anAssignmentNode value.
	
	value isCollection ifTrue: [ 
		anAssignmentNode value: self temporary.
		statements addAll: value.
	].

	(self nodeBeforeAssignment: anAssignmentNode) ifNotNil: [ :n |
		statements add: n.
	].
	statements add: anAssignmentNode.
	
	^ statements
]

{ #category : 'visiting' }
ScpInstrumentationMethodVisitor >> visitBlockNode: aBlockNode [

	self visitNode: aBlockNode body.
	
	^ aBlockNode
]

{ #category : 'visiting' }
ScpInstrumentationMethodVisitor >> visitCascadeNode: aCascadeNode [

	| statements receiver |

	statements := OrderedCollection new.

	receiver := self visitNode: aCascadeNode receiver.
	receiver isCollection ifTrue: [
		receiver := self temporary.
		statements addAll: receiver.
	].

	statements addAll: (aCascadeNode messages flatCollect: [ :m |
		m receiver: receiver. 
		self visitNode: m
	]).

	^ statements
]

{ #category : 'visiting' }
ScpInstrumentationMethodVisitor >> visitLiteralArrayNode: aRBLiteralArrayNode [

	^ aRBLiteralArrayNode
]

{ #category : 'visiting' }
ScpInstrumentationMethodVisitor >> visitLiteralNode: aLiteralNode [

	^ aLiteralNode
]

{ #category : 'visiting' }
ScpInstrumentationMethodVisitor >> visitMessageNode: aMessageNode [

	| statements receiver arguments  |
	
	statements := OrderedCollection new.
	
	receiver := self visitNode: aMessageNode receiver.
	receiver isCollection ifTrue: [ 
		aMessageNode receiver: self temporary.
		statements addAll: receiver
	].
	
	arguments := self visitArguments: aMessageNode arguments.

	aMessageNode arguments: arguments first.	
	
	statements addAll: arguments second.
	(self nodeBeforeMessage: aMessageNode) ifNotNil: [ :n |
		statements add: n.
	].
	statements add: (RBAssignmentNode 
		variable: self temporary 
		value: aMessageNode
	).
	(self nodeAfterMessage: aMessageNode) ifNotNil: [ :n |
		statements add: n.
	].
	
	^ statements

]

{ #category : 'services' }
ScpInstrumentationMethodVisitor >> visitMethod: aMethod [

	self temporary: '_scp'.
	self newArgumentIndex.
	
	^ self visit: aMethod ast copy.
]

{ #category : 'visiting' }
ScpInstrumentationMethodVisitor >> visitMethodNode: aMethodNode [

	self sequence: aMethodNode body.
	
	aMethodNode body addSelfReturn.
	
	self visit: aMethodNode body.
	
	(self nodeMethodEntry: aMethodNode) ifNotNil: [ :n |
		aMethodNode body addNodeFirst: n.
	].
	
	^ aMethodNode
]

{ #category : 'visiting' }
ScpInstrumentationMethodVisitor >> visitReturnNode: aReturnNode [

	| statements value |

	statements := OrderedCollection new.
	
	value := self visit: aReturnNode value.
	value isCollection ifTrue: [ 
		aReturnNode value: self temporary.
		statements addAll: value.
	].

	(self nodeBeforeReturn: aReturnNode) ifNotNil: [ :n |
		statements add: n.
	].
	statements add: aReturnNode.
	
	^ statements
]

{ #category : 'visiting' }
ScpInstrumentationMethodVisitor >> visitSequenceNode: aSequenceNode [

	| oldStatements newStatements |

	aSequenceNode parent isBlock ifFalse: [  
		aSequenceNode addTemporaryNamed: self temporary name.
	].

	oldStatements := aSequenceNode statements.
	aSequenceNode statements: Array empty.
	oldStatements do: [ :s | 
		newStatements := self visit: s.
		newStatements isCollection 
			ifTrue: [ aSequenceNode addNodes: newStatements ]
			ifFalse: [ aSequenceNode addNode: newStatements ]
	].
	
	^ aSequenceNode.

]
