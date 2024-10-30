Trait {
	#name : 'ScpProxyOld',
	#instVars : [
		'instrumentation'
	],
	#category : 'Scopeo-Instrumentation',
	#package : 'Scopeo-Instrumentation'
}

{ #category : 'deferred message' }
ScpProxyOld >> doesNotUnderstand: aMessage [

	<debuggerCompleteToSender>

	^ instrumentation handleMessage: aMessage
]

{ #category : 'services' }
ScpProxyOld >> instrument: anInstrumentationHandler [

	^ self
]
