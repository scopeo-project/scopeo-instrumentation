Class {
	#name : 'ScpMethodSenderReification',
	#superclass : 'ScpInvocationReification',
	#category : 'Scopeo-Method-Instrumentation-Indirections',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Indirections'
}

{ #category : 'private - reification' }
ScpMethodSenderReification >> generateForNode: anASTProgramNode [

	^ RBMessageNode 
		receiver: RBVariableNode thisContextNode
		selector: #sender 
]
