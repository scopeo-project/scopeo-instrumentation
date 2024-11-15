Class {
	#name : #ScpClassModification,
	#superclass : #ScpMethodModificationOld,
	#category : #'Scopeo-Instrumentation'
}

{ #category : #'private - constants' }
ScpClassModification class >> handlerSymbol [

	^ #_handler
]

{ #category : #'private - constants' }
ScpClassModification class >> proxySymbol [

	^ #_proxy
]

{ #category : #'private - constants' }
ScpClassModification >> nodeForRewrittenSelfVariable [

	^ RBVariableNode named: self class proxySymbol
]

{ #category : #'as yet unclassified' }
ScpClassModification >> nodeForSender [

	^ RBMessageNode
		  receiver: (RBMessageNode
				   receiver: (RBMessageNode
						    receiver: (RBMessageNode
								     receiver: (RBVariableNode named: #thisContext)
								     selector: #sender)
						    selector: #sender)
				   selector: #sender)
		  selector: #receiver
]

{ #category : #visiting }
ScpClassModification >> visitMethodNode: aMethodNode [

	super visitMethodNode: aMethodNode.
	
	aMethodNode body addNodesFirst: {
			(RBMessageNode
				 receiver: (RBMessageNode
						  receiver: self nodeForInstrumentationHandler
						  selector: #isEnabled)
				 selector: #ifFalse:
				 arguments: { (RBBlockNode body:
						  (RBSequenceNode statements:
							   { (RBReturnNode value: (RBMessageNode
									     receiver: (RBVariableNode named: #super)
									     selector: aMethodNode selector)) })) }).
			(RBMessageNode
				 receiver: self nodeForInstrumentationHandler
				 selector: #disable) }.

]

{ #category : #visiting }
ScpClassModification >> visitVariableNode:  aVariableNode [

	aVariableNode name = #self ifTrue: [ 
		^ self nodeForRewrittenSelfVariable.	
	].

	^ aVariableNode
]
