Class {
	#name : #ScpClassModification,
	#superclass : #ScpMethodModification,
	#classTraits : 'ScpASTModification classTrait',
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
