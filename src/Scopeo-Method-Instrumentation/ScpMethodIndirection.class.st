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
ScpMethodIndirection >> registerInInstrumenter [

	instrumenter addMethodIndirection: self
]

{ #category : 'parameters' }
ScpMethodIndirection >> reifyDefault [

	reifications add: (ScpDefaultMethodReification new
       indirection: self;
       yourself)
]

{ #category : 'parameters' }
ScpMethodIndirection >> reifyOperation [

	reifications add: (ScpMethodOperationReification new
       indirection: self;
       yourself)
]

{ #category : 'parameters' }
ScpMethodIndirection >> reifyReceiver [

	reifications add: (ScpObjectReification new
       indirection: self;
       yourself)
]

{ #category : 'parameters' }
ScpMethodIndirection >> reifySender [

	reifications add: (ScpMethodSenderReification new
       indirection: self;
       yourself)
]
