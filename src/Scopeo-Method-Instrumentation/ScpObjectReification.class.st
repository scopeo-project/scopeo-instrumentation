Class {
	#name : 'ScpObjectReification',
	#superclass : 'ScpIndirectionReification',
	#category : 'Scopeo-Method-Instrumentation-Indirections',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Indirections'
}

{ #category : 'private - reification' }
ScpObjectReification >> generateForNode: anASTProgramNode [

	^ RBVariableNode selfNode
]
