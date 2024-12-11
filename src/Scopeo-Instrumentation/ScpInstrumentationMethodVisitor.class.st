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

{ #category : 'instrumenting' }
ScpInstrumentationMethodVisitor >> nodeHandler [

	^ RBVariableNode named: #_SCOPEO
]

{ #category : 'instrumenting' }
ScpInstrumentationMethodVisitor >> nodeSender [

	^ RBMessageNode
		  receiver: (RBMessageNode
				   receiver: (RBVariableNode named: #thisContext)
				   selector: #sender)
		  selector: #receiver
]

{ #category : 'visiting' }
ScpInstrumentationMethodVisitor >> visitArrayNode: anArrayNode [

	^ anArrayNode 
		statements: (anArrayNode statements collect: [ :each | self visitNode: each ]);
		yourself
]

{ #category : 'visiting' }
ScpInstrumentationMethodVisitor >> visitAssignmentNode: anAssignmentNode [

	anAssignmentNode variable isInstanceVariable ifFalse: [ 
		anAssignmentNode value: (self visitNode: anAssignmentNode value).
		^ anAssignmentNode 
	].

	^ (RBMessageNode
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
				  (self visitNode: anAssignmentNode value) })
		  beScopeoNodeFor: anAssignmentNode; 
		  yourself
]

{ #category : 'visiting' }
ScpInstrumentationMethodVisitor >> visitBlockNode: aBlockNode [

	^ aBlockNode
		body: (self visitNode: aBlockNode body);
		yourself
]

{ #category : 'visiting' }
ScpInstrumentationMethodVisitor >> visitCascadeNode: aCascadeNode [

	| receiverNode receiverNodeVariable statements |

	receiverNode := aCascadeNode receiver.
	receiverNodeVariable := RBVariableNode named: #receiver.

	statements := OrderedCollection new.
	statements add: ((RBAssignmentNode variable: receiverNodeVariable value: receiverNode) acceptVisitor: self).
	
	statements addAll: (aCascadeNode messages collect: [ :m | m receiver: receiverNodeVariable ]).
	statements := statements collect: [ :s | s acceptVisitor: self ].

	^ (RBMessageNode
		  receiver: (RBBlockNode body: (RBSequenceNode
					    temporaries: { receiverNodeVariable }
					    statements: statements))
		  selector: #value)
		  beScopeoNodeFor: aCascadeNode; 
		  yourself
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

	^ (RBMessageNode
		  receiver: self nodeHandler
		  selector: (ScpInstrumentationHandler >> #node:message:sender:receiver:arguments:) selector
		  arguments: {
		   		  (RBLiteralValueNode value: aMessageNode selectorNode start).
				  (RBLiteralValueNode value: aMessageNode selector).
				  RBVariableNode selfNode.
				  self visitNode: aMessageNode receiver.
				  (RBArrayNode statements: (aMessageNode arguments collect: [ :each | self visitNode: each ])) }) 
		  beScopeoNodeFor: aMessageNode; 
		  yourself
]

{ #category : 'visiting' }
ScpInstrumentationMethodVisitor >> visitMessageToSuperNode: aMessageNode [

	^ (RBMessageNode
			  receiver: self nodeHandler
           selector: (ScpInstrumentationHandler >> #node:super:sender:arguments:class:) selector
			  arguments: {
				  	  (RBLiteralValueNode value: aMessageNode selectorNode start).
					  (RBLiteralValueNode value: aMessageNode selector).
					  RBVariableNode selfNode.
					  (RBArrayNode statements: (aMessageNode arguments collect: [ :each | self visitNode: each ])).
					  (RBVariableNode named: currentMethod methodClass asString) 
			  })
			beScopeoNodeFor: aMessageNode;
			yourself
]

{ #category : 'services' }
ScpInstrumentationMethodVisitor >> visitMethod: aMethod [
	|newAST|
	newAST := self visitNode: aMethod parseTree.
	^newAST 
	
]

{ #category : 'visiting' }
ScpInstrumentationMethodVisitor >> visitMethodNode: aMethodNode [

	currentMethod := aMethodNode compiledMethod.

	aMethodNode lastIsReturn ifFalse: [
		aMethodNode addSelfReturn
	].

	aMethodNode body: (self visitNode: aMethodNode body).

	aMethodNode body addNodeFirst: ((RBMessageNode
		receiver: self nodeHandler 
		selector: (ScpInstrumentationHandler >> #handleBeforeMethod:executedOn:withArguments:onCallFrom:) selector
		arguments: {
			(RBLiteralValueNode value: aMethodNode selector).
			RBVariableNode selfNode.
			(RBArrayNode statements: aMethodNode arguments).
			self nodeSender
		}) beScopeoNodeFor: aMethodNode; yourself).

	^ aMethodNode
]

{ #category : 'visiting' }
ScpInstrumentationMethodVisitor >> visitReturnNode: aReturnNode [

	^ aReturnNode value: ((RBMessageNode
			receiver: self nodeHandler
			selector: #node:return:
			arguments: { 
				(RBLiteralValueNode value: aReturnNode start).
				(self visitNode: aReturnNode value) . 
			}) beScopeoNodeFor: aReturnNode value; yourself)
			
]

{ #category : 'visiting' }
ScpInstrumentationMethodVisitor >> visitSequenceNode: aSequenceNode [

	aSequenceNode statements: (aSequenceNode statements collect: [ :s | 
		self visitNode: s.
	]).

	^ aSequenceNode
]

{ #category : 'visiting' }
ScpInstrumentationMethodVisitor >> visitVariableNode: aVariableNode [
	
	^ aVariableNode
]
