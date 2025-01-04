Class {
	#name : 'ScpDefaultHandler',
	#superclass : 'ScpHandler',
	#category : 'Scopeo-Method-Instrumentation-Handlers',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Handlers'
}

{ #category : 'enumerating' }
ScpDefaultHandler >> handle: anOperation [

	^ anOperation execute
]
