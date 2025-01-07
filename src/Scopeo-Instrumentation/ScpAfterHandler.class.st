Class {
	#name : 'ScpAfterHandler',
	#superclass : 'ScpHandler',
	#category : 'Scopeo-Instrumentation-Handlers',
	#package : 'Scopeo-Instrumentation',
	#tag : 'Handlers'
}

{ #category : 'enumerating' }
ScpAfterHandler >> handle: anOperation [

	anOperation execute.
	block value: anOperation.

	^ anOperation result
]
