Class {
	#name : 'ScpContextReification',
	#superclass : 'ScpIndirectionReification',
	#category : 'Scopeo-Method-Instrumentation-Indirections',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Indirections'
}

{ #category : 'private - reification' }
ScpContextReification >> generateForNode: anASTProgramNode [

	^ RBVariableNode thisContextNode
]
