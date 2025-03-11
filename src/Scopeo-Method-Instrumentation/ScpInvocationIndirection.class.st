Class {
	#name : 'ScpInvocationIndirection',
	#superclass : 'ScpIndirection',
	#instVars : [
		'arguments'
	],
	#category : 'Scopeo-Method-Instrumentation',
	#package : 'Scopeo-Method-Instrumentation'
}

{ #category : 'testing' }
ScpInvocationIndirection class >> isAbstract [

	^ self == ScpInvocationIndirection
]

{ #category : 'accessing' }
ScpInvocationIndirection >> arguments [

	^ arguments
]

{ #category : 'private - parameters' }
ScpInvocationIndirection >> arguments: anObject [

	arguments := anObject
]

{ #category : 'accessing' }
ScpInvocationIndirection >> receiver [

	self subclassResponsibility
]

{ #category : 'parameters' }
ScpInvocationIndirection >> reifyArguments [

	indirectionArguments add: (ScpIndirectionArgument new
		indirection: self;
		selector: #arguments:;
		argument: [ :astnode :inst | 
			RBArrayNode statements: (astnode arguments collect: [ :a | 
				inst visitNode: a 
			]) 
		];
		yourself
	).
]

{ #category : 'parameters' }
ScpInvocationIndirection >> reifyReceiver [

	self subclassResponsibility
]

{ #category : 'parameters' }
ScpInvocationIndirection >> reifySender [

	self subclassResponsibility
]

{ #category : 'accessing' }
ScpInvocationIndirection >> sender [

	self subclassResponsibility
]
