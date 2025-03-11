Class {
	#name : 'ScpMethodIndirection',
	#superclass : 'ScpInvocationIndirection',
	#category : 'Scopeo-Method-Instrumentation',
	#package : 'Scopeo-Method-Instrumentation'
}

{ #category : 'private' }
ScpMethodIndirection class >> run: aMethod on: aReceiver arguments: aArguments [
	
	^ aReceiver withArgs: aArguments executeMethod: aMethod 
]

{ #category : 'private - instrumenter' }
ScpMethodIndirection >> generateForNode: anASTProgramNode [

	^ (RBMethodNode
			selector: anASTProgramNode selector 
			arguments: anASTProgramNode arguments
			body: (RBSequenceNode statements: { 
				RBReturnNode value: (super generateForNode: anASTProgramNode) 
			}))
			methodClass: anASTProgramNode methodClass;
			yourself
]

{ #category : 'accessing' }
ScpMethodIndirection >> receiver [

	^ self object
]

{ #category : 'private - instrumenter' }
ScpMethodIndirection >> registerInInstrumenter [

	instrumenter addMethodIndirection: self
]

{ #category : 'parameters' }
ScpMethodIndirection >> reifyDefaultOperation [

	indirectionArguments add: (ScpIndirectionArgument new
		indirection: self;
		selector: #operation:;
		argument: [ :astnode :inst |
			RBBlockNode body: (RBSequenceNode statements: { (RBMessageNode
			    receiver: RBVariableNode selfNode
			    selector: #withArgs:executeMethod:
			    arguments: {
						RBArrayNode statements: astnode arguments.
						RBLiteralValueNode value: (inst hasIndirectionForBody 
							ifTrue: [ inst instrument: astnode compiledMethod ]
							ifFalse: [astnode compiledMethod ])
				 }) 
		  })
		];
		yourself
	)




]

{ #category : 'parameters' }
ScpMethodIndirection >> reifyReceiver [

	self reifyObject
]

{ #category : 'parameters' }
ScpMethodIndirection >> reifySender [

	self reifyContext
]

{ #category : 'accessing' }
ScpMethodIndirection >> selector [

	^ method selector
]

{ #category : 'accessing' }
ScpMethodIndirection >> sender [

	context ifNil: [ 
		self error: 'Please set up the indirection using #reifySender to collect the method sender.'.
	].

	^ context sender receiver
]
