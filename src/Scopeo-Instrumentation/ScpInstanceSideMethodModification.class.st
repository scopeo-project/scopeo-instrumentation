Class {
	#name : 'ScpInstanceSideMethodModification',
	#superclass : 'ScpModificationConfiguration',
	#category : 'Scopeo-Instrumentation-ScopeoMethodModification',
	#package : 'Scopeo-Instrumentation',
	#tag : 'ScopeoMethodModification'
}

{ #category : 'accessing' }
ScpInstanceSideMethodModification >> hasMetaLevelGardClause [

	^ false
]

{ #category : 'testing' }
ScpInstanceSideMethodModification >> hasProxy [

 	^	true
]

{ #category : 'as yet unclassified' }
ScpInstanceSideMethodModification >> nodeForProxy [

	^ RBVariableNode named: #proxy
]

{ #category : 'accessing' }
ScpInstanceSideMethodModification >> nodeForSender [

	^ RBMessageNode
		  receiver: (RBMessageNode
				   receiver: (RBMessageNode
						    receiver: (RBVariableNode named: #thisContext)
						    selector: #sender)
				   selector: #sender)
		  selector: #receiver
]
