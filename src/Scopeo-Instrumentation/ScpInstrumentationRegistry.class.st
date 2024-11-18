Class {
	#name : #ScpInstrumentationRegistry,
	#superclass : #Dictionary,
	#classInstVars : [
		'instance'
	],
	#category : #'Scopeo-Instrumentation-ScopeoMethodInstrumentation'
}

{ #category : #accessing }
ScpInstrumentationRegistry class >> instance [

	^ instance ifNil: [ instance = self new ]
]
