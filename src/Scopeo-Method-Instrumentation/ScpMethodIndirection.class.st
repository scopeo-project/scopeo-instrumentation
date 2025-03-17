Class {
	#name : 'ScpMethodIndirection',
	#superclass : 'ScpInvocationIndirection',
	#category : 'Scopeo-Method-Instrumentation-Indirections',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Indirections'
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

{ #category : 'private - instrumenter' }
ScpMethodIndirection >> generateOperationForNode: anASTProgramNode [

	^ RBMessageNode
		receiver: (RBVariableNode named: ScpMethodOperation name) 
		selector: #new 
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
							ifFalse: [ astnode compiledMethod ])
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
