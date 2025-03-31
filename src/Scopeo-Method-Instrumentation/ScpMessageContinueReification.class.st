Class {
	#name : 'ScpMessageContinueReification',
	#superclass : 'ScpContinueReification',
	#category : 'Scopeo-Method-Instrumentation-Indirections',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Indirections'
}

{ #category : 'private - reification' }
ScpMessageContinueReification >> generateForNode: anASTProgramNode [

	^ RBBlockNode body: (RBSequenceNode statements: { 
		RBMessageNode
			receiver: (self instrumenter visitNode: anASTProgramNode receiver) 
			selector: anASTProgramNode selector 
			arguments: (anASTProgramNode arguments collect: [ :a | 
				self instrumenter visitNode: a.
			]) 
	})
]
