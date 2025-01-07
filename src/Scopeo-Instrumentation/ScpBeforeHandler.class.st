Class {
	#name : 'ScpBeforeHandler',
	#superclass : 'ScpHandler',
	#category : 'Scopeo-Instrumentation-Handlers',
	#package : 'Scopeo-Instrumentation',
	#tag : 'Handlers'
}

{ #category : 'enumerating' }
ScpBeforeHandler >> handle: anOperation [

	block value: anOperation.
	^ anOperation execute
]
