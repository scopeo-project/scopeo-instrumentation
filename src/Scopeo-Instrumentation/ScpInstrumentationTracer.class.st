Class {
	#name : 'ScpInstrumentationTracer',
	#superclass : 'ScpInstrumentationHandler',
	#instVars : [
		'events'
	],
	#category : 'Scopeo-Instrumentation',
	#package : 'Scopeo-Instrumentation'
}

{ #category : 'events handling' }
ScpInstrumentationTracer >> assignment: aVariable object: anObject value: aValue [

	events add: '(' , anObject asString  , ')', aVariable asString, ' = ', aValue asString 
		
]

{ #category : 'initialization' }
ScpInstrumentationTracer >> initialize [

	events := OrderedCollection new
]

{ #category : 'events handling' }
ScpInstrumentationTracer >> message: aMessage sender: aSender receiver: aReceiver return: aReturn [

	events add: aSender asString ,  ' ' , aMessage asString , ' ', aReceiver asString , ' ', aReturn asString 
		
]
