Class {
	#name : 'ScpInstrumentation',
	#superclass : 'Object',
	#instVars : [
		'handler'
	],
	#category : 'Scopeo-Method-Instrumentation-Instrumentations',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Instrumentations'
}

{ #category : 'testing' }
ScpInstrumentation class >> isAbstract [

	^ self == ScpInstrumentation
]

{ #category : 'comparing' }
ScpInstrumentation >> = anInstrumentation [

	self == anInstrumentation ifTrue: [ ^ true ].

	 ^ anInstrumentation class = self class and: [
		   anInstrumentation handler = handler ]
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
