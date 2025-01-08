Class {
	#name : 'ScpInsteadHandler',
	#superclass : 'ScpHandler',
	#category : 'Scopeo-Method-Instrumentation-Handlers',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Handlers'
}

{ #category : 'enumerating' }
ScpInsteadHandler >> handle: anOperation [

	self isEnabled ifTrue: [ 
		^ block value: anOperation
	].

	^ anOperation execute
	
]
