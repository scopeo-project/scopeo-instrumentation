Class {
	#name : 'ScpInsteadHandler',
	#superclass : 'ScpHandler',
	#category : 'Scopeo-Instrumentation-Handlers',
	#package : 'Scopeo-Instrumentation',
	#tag : 'Handlers'
}

{ #category : 'enumerating' }
ScpInsteadHandler >> handle: anOperation [

	^ block value: anOperation

]
