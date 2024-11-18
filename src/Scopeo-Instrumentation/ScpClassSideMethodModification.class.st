Class {
	#name : #ScpClassSideMethodModification,
	#superclass : #ScpModificationConfiguration,
	#category : #'Scopeo-Instrumentation-ScopeoMethodModification'
}

{ #category : #'as yet unclassified' }
ScpClassSideMethodModification >> nodeForMetaLevelGardClause: aMethodNode [

	^ RBMessageNode
		  receiver:
		  (RBMessageNode receiver: self nodeForHandler selector: #isEnabled)
		  selector: #ifFalse:
		  arguments:
			  { (RBBlockNode body:
				   (RBSequenceNode statements: { (RBMessageNode
						     receiver: (RBMessageNode
								      receiver: (RBMessageNode
										       receiver: (RBVariableNode named: #self)
										       selector: #class)
								      selector: #'>>'
								      arguments:
								      { (RBLiteralValueNode value: aMethodNode selector) })
						     selector: #executeOriginalMethodOn:withArguments:
						     arguments: {
								     (RBVariableNode named: #self).
								     (RBArrayNode statements: aMethodNode arguments) }) })) }
]

{ #category : #'as yet unclassified' }
ScpClassSideMethodModification >> nodeForSender [

	^ RBMessageNode
		  receiver: (RBMessageNode
				   receiver: (RBVariableNode named: #thisContext)
				   selector: #sender)
		  selector: #receiver
]
