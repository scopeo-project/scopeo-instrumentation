Class {
	#name : 'ScpInstrumentation',
	#superclass : 'Object',
	#instVars : [
		'handler'
	],
	#category : 'Scopeo-Instrumentation-Instrumentations',
	#package : 'Scopeo-Instrumentation',
	#tag : 'Instrumentations'
}

{ #category : 'testing' }
ScpInstrumentation class >> isAbstract [

	^ self == ScpInstrumentation
]

{ #category : 'accessing' }
ScpInstrumentation >> handler [

	^ handler
]

{ #category : 'parameters' }
ScpInstrumentation >> handler: anObject [

	handler := ScpHandlerRegistry register: anObject
]

{ #category : 'private' }
ScpInstrumentation >> registerIn: anInstrumentation [

	self subclassResponsibility

]
