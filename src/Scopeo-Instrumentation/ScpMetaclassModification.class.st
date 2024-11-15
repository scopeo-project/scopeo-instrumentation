Class {
	#name : #ScpMetaclassModification,
	#superclass : #ScpMethodModificationOld,
	#category : #'Scopeo-Instrumentation'
}

{ #category : #'private - constants' }
ScpMetaclassModification class >> handlerSymbol [

	^ #_meta_handler
]

{ #category : #'as yet unclassified' }
ScpMetaclassModification >> nodeForSender [

	^ RBMessageNode
		  receiver: (RBMessageNode
				   receiver: (RBMessageNode
						    receiver: (RBVariableNode named: #thisContext)
						    selector: #sender)
				   selector: #sender)
		  selector: #receiver
]

{ #category : #visiting }
ScpMetaclassModification >> visitMethodNode: aMethodNode [

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
									     receiver: (RBVariableNode named: #MirrorPrimitives)
									     selector: #withReceiver:andArguments:execute:
									     arguments: {
											     (RBVariableNode named: #self).
											     (RBArrayNode statements: aMethodNode arguments).
											     (RBMessageNode
												      receiver: (RBMessageNode
														       receiver: (RBMessageNode
																        receiver: (RBVariableNode named: #self)
																        selector: #class)
														       selector: #'>>'
														       arguments:
														       { (RBLiteralValueNode value: aMethodNode selector) })
												      selector: #originalMethod) })) })) }).
			(RBMessageNode
				 receiver: self nodeForInstrumentationHandler
				 selector: #disable) }
]
