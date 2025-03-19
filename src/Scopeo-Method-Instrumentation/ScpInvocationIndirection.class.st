Class {
	#name : 'ScpInvocationIndirection',
	#superclass : 'ScpIndirection',
	#category : 'Scopeo-Method-Instrumentation-Indirections',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Indirections'
}

{ #category : 'testing' }
ScpInvocationIndirection class >> isAbstract [

	^ self == ScpInvocationIndirection
]

{ #category : 'parameters' }
ScpInvocationIndirection >> reifyArguments [

	reifications add: (ScpArgumentsReification new
       indirection: self;
       yourself)
]

{ #category : 'parameters' }
ScpInvocationIndirection >> reifyReceiver [

	self subclassResponsibility
]

{ #category : 'parameters' }
ScpInvocationIndirection >> reifySender [

	self subclassResponsibility
]
