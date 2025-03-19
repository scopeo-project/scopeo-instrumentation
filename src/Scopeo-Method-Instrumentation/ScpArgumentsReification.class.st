Class {
	#name : 'ScpArgumentsReification',
	#superclass : 'ScpInvocationReification',
	#category : 'Scopeo-Method-Instrumentation-Indirections',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Indirections'
}

{ #category : 'private - reification' }
ScpArgumentsReification >> generateForNode: anASTProgramNode [

	^ RBArrayNode statements: (anASTProgramNode arguments collect: [ :a | 
		self instrumenter visitNode: a 
	]) 
]
