Trait {
	#name : 'ScpInstrumentationHandler',
	#category : 'Scopeo-Instrumentation',
	#package : 'Scopeo-Instrumentation'
}

{ #category : 'private - constants' }
ScpInstrumentationHandler classSide >> globalSymbol [

	^ #_SCOPEO
]

{ #category : 'events handling' }
ScpInstrumentationHandler >> assignment: aVariable object: anObject value: aValue [
]

{ #category : 'events handling' }
ScpInstrumentationHandler >> message: aSelector sender: aSender receiver: aReceiver arguments: anArguments [
]

{ #category : 'handling' }
ScpInstrumentationHandler >> return: aValue [
]
