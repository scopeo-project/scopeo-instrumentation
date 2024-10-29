Class {
	#name : 'ScpInstrumentationHook',
	#superclass : 'Object',
	#traits : 'ScpInstrumentationHandler',
	#classTraits : 'ScpInstrumentationHandler classTrait',
	#category : 'Scopeo-Instrumentation',
	#package : 'Scopeo-Instrumentation'
}

{ #category : 'events handling' }
ScpInstrumentationHook >> message: aSelector sender: aSender receiver: aReceiver arguments: anArguments [

	self haltOnce.
]
