Class {
	#name : 'ScpMessageReceiverReification',
	#superclass : 'ScpInvocationReification',
	#category : 'Scopeo-Method-Instrumentation-Indirections',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Indirections'
}

{ #category : 'private - reification' }
ScpMessageReceiverReification >> generateForNode: anASTProgramNode [

	^ self instrumenter visitNode: anASTProgramNode receiver 
]
