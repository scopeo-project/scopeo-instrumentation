Class {
	#name : 'ScpInstrumentationRegistry',
	#superclass : 'WeakKeyDictionary',
	#classInstVars : [
		'instance'
	],
	#category : 'Scopeo-Instrumentation-ScopeoMethodInstrumentation',
	#package : 'Scopeo-Instrumentation',
	#tag : 'ScopeoMethodInstrumentation'
}

{ #category : 'accessing' }
ScpInstrumentationRegistry class >> instance [

	^ instance ifNil: [ instance := self new ]
]
