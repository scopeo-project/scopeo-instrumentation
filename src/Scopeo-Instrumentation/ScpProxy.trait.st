Trait {
	#name : 'ScpProxy',
	#instVars : [
		'instrumentation'
	],
	#category : 'Scopeo-Instrumentation',
	#package : 'Scopeo-Instrumentation'
}

{ #category : 'deferred message' }
ScpProxy >> doesNotUnderstand: aMessage [

	<debuggerCompleteToSender>

	^ instrumentation handleMessage: aMessage
]

{ #category : 'services' }
ScpProxy >> instrument: anInstrumentationHandler [

	^ self
]
