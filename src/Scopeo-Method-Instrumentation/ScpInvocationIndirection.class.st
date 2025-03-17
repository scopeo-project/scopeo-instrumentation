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
