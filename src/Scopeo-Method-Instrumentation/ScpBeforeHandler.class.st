Class {
	#name : 'ScpBeforeHandler',
	#superclass : 'ScpHandler',
	#category : 'Scopeo-Method-Instrumentation-Handlers',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Handlers'
}

{ #category : 'enumerating' }
ScpBeforeHandler >> handle: anOperation [

	block value: anOperation.
	^ anOperation execute
]
