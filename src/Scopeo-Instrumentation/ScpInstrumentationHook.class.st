Class {
	#name : #ScpInstrumentationHook,
	#superclass : #Object,
	#traits : 'ScpInstrumentationHandler',
	#classTraits : 'ScpInstrumentationHandler classTrait',
	#category : 'Scopeo-Instrumentation'
}

{ #category : #'events handling' }
ScpInstrumentationHook >> assignment: aVariable object: anObject value: aValue [

	anObject asString , ' -> ' , aVariable asString , ' := ', aValue asString
]

{ #category : #'events handling' }
ScpInstrumentationHook >> message: aSelector sender: aSender receiver: aReceiver arguments: anArguments [

	self haltOnce.
	(aSender asString, ' - ' ,aSelector asString, ' -> ' ,  aReceiver asString) crTrace
]

{ #category : #handling }
ScpInstrumentationHook >> return: aValue [

	aValue asString
]
