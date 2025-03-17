Class {
	#name : 'ScpMessageIndirection',
	#superclass : 'ScpInvocationIndirection',
	#category : 'Scopeo-Method-Instrumentation-Indirections',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Indirections'
}

{ #category : 'private - instrumenter' }
ScpMessageIndirection >> generateOperationForNode: anASTProgramNode [

	^ RBMessageNode
		receiver: (RBVariableNode named: ScpMessageOperation name) 
		selector: #new 
]

{ #category : 'private - instrumenter' }
ScpMessageIndirection >> registerInInstrumenter [

	instrumenter addMessageIndirection: self
]

{ #category : 'parameters' }
ScpMessageIndirection >> reifyDefaultOperation [

	indirectionArguments add: (ScpIndirectionArgument new
		indirection: self;
		selector: #operation:;
		argument: [ :astnode :inst | 
			RBBlockNode body: (RBSequenceNode statements: { 
				RBMessageNode
					receiver: (inst visitNode: astnode receiver) 
					selector: astnode selector 
					arguments: (astnode arguments collect: [ :a | 
						inst visitNode: a.
					]) 
			})
		];
		yourself
	)


]

{ #category : 'parameters' }
ScpMessageIndirection >> reifyReceiver [

	indirectionArguments add: (ScpIndirectionArgument new
		indirection: self;
		selector: #receiver:;
		argument: [ :astnode :inst |
			inst visitNode: astnode receiver 
		];
		yourself
	)
]

{ #category : 'parameters' }
ScpMessageIndirection >> reifySender [

	self reifyObject
]
