Class {
	#name : 'ScpDefaultHandler',
	#superclass : 'ScpHandler',
	#category : 'Scopeo-Instrumentation-Handlers',
	#package : 'Scopeo-Instrumentation',
	#tag : 'Handlers'
}

{ #category : 'enumerating' }
ScpDefaultHandler >> handle: anOperation [

	^ anOperation execute
]
