Class {
	#name : #ScpInstanceSideMethodModification,
	#superclass : #ScpModificationConfiguration,
	#category : #'Scopeo-Instrumentation-ScopeoMethodModification'
}

{ #category : #'as yet unclassified' }
ScpInstanceSideMethodModification >> nodeForMetaLevelGardClause: aMethodNode [

	^ (RBMessageNode
			   receiver:
			   (RBMessageNode
				    receiver: self nodeForHandler
				    selector: #isEnabled)
			   selector: #ifFalse:
			   arguments:
				   { (RBBlockNode body:
					    (RBSequenceNode statements: { (RBMessageNode
							      receiver: (RBVariableNode named: #super)
							      selector: aMethodNode selector) })) })
]

{ #category : #'as yet unclassified' }
ScpInstanceSideMethodModification >> nodeForSender [

	^ RBMessageNode
		  receiver: (RBMessageNode
				   receiver: (RBMessageNode
						    receiver: (RBVariableNode named: #thisContext)
						    selector: #sender)
				   selector: #sender)
		  selector: #receiver
]
