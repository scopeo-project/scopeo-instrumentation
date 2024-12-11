Class {
	#name : 'ScpInstrumentationMethodVisitor',
	#superclass : 'RBProgramNodeVisitor',
	#instVars : [
		'currentMethod'
	],
	#category : 'Scopeo-Instrumentation',
	#package : 'Scopeo-Instrumentation'
}

{ #category : 'accessing' }
ScpInstrumentationMethodVisitor class >> transform: aMethod [

	 ^ self new visitMethod: aMethod
]

{ #category : 'as yet unclassified' }
ScpInstrumentationMethodVisitor >> nodeHandler [

	^ RBVariableNode named: #_SCOPEO
]

{ #category : 'as yet unclassified' }
ScpInstrumentationMethodVisitor >> nodeSender [

	^ RBMessageNode
		  receiver: (RBMessageNode
				   receiver: (RBVariableNode named: #thisContext)
				   selector: #sender)
		  selector: #receiver
]

{ #category : 'as yet unclassified' }
ScpInstrumentationMethodVisitor >> visitArrayNode: anArrayNode [

	^ anArrayNode 
		statements: (anArrayNode statements collect: [ :each | self visitNode: each ]);
		yourself
]

{ #category : 'visiting' }
ScpInstrumentationMethodVisitor >> visitAssignmentNode: anAssignmentNode [

	| assignmentNode |
	
	anAssignmentNode variable isInstanceVariable ifFalse: [ 
		anAssignmentNode value: (self visitNode: anAssignmentNode value).
		^ anAssignmentNode 
	].
	
	assignmentNode := (RBMessageNode
		  receiver: self nodeHandler
		  selector: (ScpInstrumentationHandler >> #node:assignment:variable:object:value:) selector
		  arguments: {
					(RBLiteralValueNode value: anAssignmentNode start).
				  (RBBlockNode
					   arguments: { (RBVariableNode named: #v) }
					   body: (RBSequenceNode statements: { (RBAssignmentNode
								     variable:
								     (RBVariableNode named: anAssignmentNode variable name)
								     value: (RBVariableNode named: #v)) })).
				  (RBLiteralValueNode value: anAssignmentNode variable name).
				  (RBVariableNode selfNode).
				  (self visitNode: anAssignmentNode value) }).
				
	ScpASTDictionary instance at: currentMethod at: assignmentNode put: anAssignmentNode.
	^ assignmentNode 
]

{ #category : 'as yet unclassified' }
ScpInstrumentationMethodVisitor >> visitBlockNode: aBlockNode [

	^ aBlockNode
		body: (self visitNode: aBlockNode body);
		yourself
]

{ #category : 'visiting' }
ScpInstrumentationMethodVisitor >> visitCascadeNode: aCascadeNode [

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
	ScpASTDictionary instance at: currentMethod at: cascadeNode put: aCascadeNode.
	^ cascadeNode 
]

{ #category : 'as yet unclassified' }
ScpInstrumentationMethodVisitor >> visitLiteralArrayNode: aRBLiteralArrayNode [

	^ aRBLiteralArrayNode
]

{ #category : 'as yet unclassified' }
ScpInstrumentationMethodVisitor >> visitLiteralNode: aLiteralNode [

	^ aLiteralNode
]

{ #category : 'visiting' }
ScpInstrumentationMethodVisitor >> visitMessageNode: aMessageNode [
	|messageNode |

	aMessageNode receiver isSuperVariable ifTrue: [
		^ self visitMessageToSuperNode: aMessageNode
	].

	aMessageNode receiver isBlock ifTrue: [ 
		^ aMessageNode
			receiver: (self visitNode: aMessageNode receiver);
			arguments: (aMessageNode arguments collect: [ :each | 
				self visitNode: each 
			]).
	].

	messageNode  := (RBMessageNode
		  receiver: self nodeHandler
		  selector: (ScpInstrumentationHandler >> #node:message:sender:receiver:arguments:) selector
		  arguments: {
		   		  (RBLiteralValueNode value: aMessageNode selectorNode start).
				  (RBLiteralValueNode value: aMessageNode selector).
				  RBVariableNode selfNode.
				  self visitNode: aMessageNode receiver.
				  (RBArrayNode statements: (aMessageNode arguments collect: [ :each | self visitNode: each ])) }).
	
	ScpASTDictionary instance at: currentMethod at: messageNode put: aMessageNode.
	^ messageNode 
]

{ #category : 'as yet unclassified' }
ScpInstrumentationMethodVisitor >> visitMessageToSuperNode: aMessageNode [
	| messageNode |
	messageNode := (RBMessageNode
			  receiver: self nodeHandler
           selector: (ScpInstrumentationHandler >> #node:super:sender:arguments:class:) selector
			  arguments: {
				  	  (RBLiteralValueNode value: aMessageNode selectorNode start).
					  (RBLiteralValueNode value: aMessageNode selector).
					  RBVariableNode selfNode.
					  (RBArrayNode statements: (aMessageNode arguments collect: [ :each | self visitNode: each ])).
					  (RBVariableNode named: currentMethod methodClass asString) 
			  }).
	ScpASTDictionary instance at: currentMethod at: messageNode put: aMessageNode.

	^messageNode 
]

{ #category : 'as yet unclassified' }
ScpInstrumentationMethodVisitor >> visitMethod: aMethod [

	^ self visitNode: aMethod parseTree 
	
]

{ #category : 'visiting' }
ScpInstrumentationMethodVisitor >> visitMethodNode: aMethodNode [

	| beforeNode |

	currentMethod := aMethodNode compiledMethod.
	ScpASTDictionary instance at: currentMethod put: Dictionary new.

	aMethodNode lastIsReturn ifFalse: [
		aMethodNode addSelfReturn
	].

	aMethodNode body: (self visitNode: aMethodNode body).


	beforeNode := (RBMessageNode
		receiver: self nodeHandler 
		selector: (ScpInstrumentationHandler >> #handleBeforeMethod:executedOn:withArguments:onCallFrom:) selector
		arguments: {
			(RBLiteralValueNode value: aMethodNode selector).
			RBVariableNode selfNode.
			(RBArrayNode statements: aMethodNode arguments).
			self nodeSender
		}).

	aMethodNode body addNodeFirst: beforeNode.
	ScpASTDictionary instance at: currentMethod at: beforeNode put: aMethodNode.

	^ aMethodNode
]

{ #category : 'visiting' }
ScpInstrumentationMethodVisitor >> visitReturnNode: aReturnNode [

	| returnNodeValue |

	returnNodeValue := (RBMessageNode
			receiver: self nodeHandler
			selector: #node:return:
			arguments: { 
				(RBLiteralValueNode value: aReturnNode start).
				(self visitNode: aReturnNode value) . 
			}).

	ScpASTDictionary instance at: currentMethod at: returnNodeValue put: aReturnNode value.

	^ aReturnNode value: returnNodeValue
			
]

{ #category : 'visiting' }
ScpInstrumentationMethodVisitor >> visitSequenceNode: aSequenceNode [

	aSequenceNode statements: (aSequenceNode statements collect: [ :s | 
		self visitNode: s.
	]).

	^ aSequenceNode
]

{ #category : 'as yet unclassified' }
ScpInstrumentationMethodVisitor >> visitVariableNode: aVariableNode [
	
	^ aVariableNode
]
