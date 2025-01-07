Class {
	#name : 'ScpAfterHandler',
	#superclass : 'ScpHandler',
	#category : 'Scopeo-Method-Instrumentation-Handlers',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Handlers'
}

{ #category : 'enumerating' }
ScpAfterHandler >> handle: anOperation [

	anOperation execute.
	block value: anOperation.

	^ anOperation result
]
