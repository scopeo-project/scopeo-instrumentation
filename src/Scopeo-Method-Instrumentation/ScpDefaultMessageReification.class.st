Class {
	#name : 'ScpDefaultMessageReification',
	#superclass : 'ScpDefaultReification',
	#category : 'Scopeo-Method-Instrumentation-Indirections',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Indirections'
}

{ #category : 'private - reification' }
ScpDefaultMessageReification >> generateForNode: anASTProgramNode [

	^ RBBlockNode body: (RBSequenceNode statements: { 
		RBMessageNode
			receiver: anASTProgramNode receiver copy
			selector: anASTProgramNode selector 
			arguments: (anASTProgramNode arguments collect: [ :a | a copy ]) 
	})
]
