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
			receiver: (self instrumenter visitNode: anASTProgramNode receiver) 
			selector: anASTProgramNode selector 
			arguments: (anASTProgramNode arguments collect: [ :a | 
				self instrumenter visitNode: a.
			]) 
	})
]
