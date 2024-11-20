Class {
	#name : 'ScpInstrumentationHook',
	#superclass : 'Object',
	#traits : 'ScpInstrumentationHandler',
	#classTraits : 'ScpInstrumentationHandler classTrait',
	#category : 'Scopeo-Instrumentation-ScopeoMethodInstrumentation',
	#package : 'Scopeo-Instrumentation',
	#tag : 'ScopeoMethodInstrumentation'
}

{ #category : 'hooks' }
ScpInstrumentationHook >> assignment: aVariable object: anObject value: aValue [

	anObject asString , ' -> ' , aVariable asString , ' := ', aValue asString
]

{ #category : 'hooks' }
ScpInstrumentationHook >> message: aSelector sender: aSender receiver: aReceiver arguments: anArguments [

	(aSender asString, ' - ' ,aSelector asString, ' -> ' ,  aReceiver asString) crTrace
]

{ #category : 'hooks' }
ScpInstrumentationHook >> return: aValue [

	aValue asString
]
