Class {
	#name : 'ScpInstrumentationHandler',
	#superclass : 'Object',
	#category : 'Scopeo-Instrumentation',
	#package : 'Scopeo-Instrumentation'
}

{ #category : 'private - constants' }
ScpInstrumentationHandler class >> globalSymbol [

	^ #_SCOPEO
]

{ #category : 'events handling' }
ScpInstrumentationHandler >> assignment: aVariable object: anObject value: aValue [
]

{ #category : 'events handling' }
ScpInstrumentationHandler >> message: aSelector sender: aSender receiver: aReceiver return: aValue [
]
