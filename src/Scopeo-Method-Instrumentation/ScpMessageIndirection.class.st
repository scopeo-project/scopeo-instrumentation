Class {
	#name : 'ScpMessageIndirection',
	#superclass : 'ScpInvocationIndirection',
	#category : 'Scopeo-Method-Instrumentation-Indirections',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Indirections'
}

{ #category : 'private - instrumenter' }
ScpMessageIndirection >> registerInInstrumenter [

	instrumenter addMessageIndirection: self
]

{ #category : 'parameters' }
ScpMessageIndirection >> reifyDefault [

	reifications add: (ScpDefaultMessageReification new
       indirection: self;
       yourself)


]

{ #category : 'parameters' }
ScpMessageIndirection >> reifyOperation [

	reifications add: (ScpMessageOperationReification new
       indirection: self;
       yourself)
]

{ #category : 'parameters' }
ScpMessageIndirection >> reifyReceiver [

	reifications add: (ScpMessageReceiverReification new
       indirection: self;
       yourself)
]

{ #category : 'parameters' }
ScpMessageIndirection >> reifySender [

	self reifyObject
]
