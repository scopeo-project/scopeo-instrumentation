Trait {
	#name : 'ScpInstrumentationHandler',
	#instVars : [
		'enabled'
	],
	#category : 'Scopeo-Instrumentation-ScopeoMethodInstrumentation',
	#package : 'Scopeo-Instrumentation',
	#tag : 'ScopeoMethodInstrumentation'
}

{ #category : 'hooks' }
ScpInstrumentationHandler >> assignment: aVariable object: anObject value: aValue [
]

{ #category : 'services' }
ScpInstrumentationHandler >> disable [

	enabled := false
]

{ #category : 'services' }
ScpInstrumentationHandler >> enable [

	enabled := true
]

{ #category : 'services' }
ScpInstrumentationHandler >> isEnabled [

	^ enabled ifNil: [ false ]
]

{ #category : 'hooks' }
ScpInstrumentationHandler >> message: aSelector sender: aSender receiver: aReceiver arguments: anArguments [
]

{ #category : 'hooks' }
ScpInstrumentationHandler >> return: aValue [
]
