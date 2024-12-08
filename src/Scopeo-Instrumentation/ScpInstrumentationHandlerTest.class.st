Class {
	#name : 'ScpInstrumentationHandlerTest',
	#superclass : 'Object',
	#traits : 'ScpInstrumentationHandler',
	#classTraits : 'ScpInstrumentationHandler classTrait',
	#instVars : [
		'events'
	],
	#category : 'Scopeo-Instrumentation-Tests',
	#package : 'Scopeo-Instrumentation',
	#tag : 'Tests'
}

{ #category : 'accessing' }
ScpInstrumentationHandlerTest >> events [

	^ events
]

{ #category : 'accessing' }
ScpInstrumentationHandlerTest >> initialize [

	events := OrderedCollection new
]

{ #category : 'hooks' }
ScpInstrumentationHandlerTest >> onAssignmentEvent: aAssignmentEvent [

	events add: aAssignmentEvent
]

{ #category : 'hooks' }
ScpInstrumentationHandlerTest >> onMessageEvent: aMessageEvent [

	events add: aMessageEvent
]

{ #category : 'hooks' }
ScpInstrumentationHandlerTest >> onMethodEvent: aMethodEvent [

	events add: aMethodEvent 
]
