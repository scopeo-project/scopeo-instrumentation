Class {
	#name : 'ScpMethodIndirection',
	#superclass : 'ScpMethodCallIndirection',
	#category : 'Scopeo-Method-Instrumentation',
	#package : 'Scopeo-Method-Instrumentation'
}

{ #category : 'private' }
ScpMethodIndirection class >> run: aMethod on: aReceiver arguments: aArguments [
	
	^ aReceiver withArgs: aArguments executeMethod: aMethod 
]

{ #category : 'initialization' }
ScpMethodIndirection >> initialize [

	super initialize.
	
	indirectionArguments add: (ScpIndirectionArgument new
		indirection: self;
		selector: #receiver:;
		argument: [ RBVariableNode selfNode ];
		yourself
	).
]

{ #category : 'accessing' }
ScpMethodIndirection >> object [

	^ object
]

{ #category : 'accessing' }
ScpMethodIndirection >> performDefaultOperation [
	
	<debuggerCompleteToSender>

	^ object withArgs: arguments executeMethod: method
]

{ #category : 'private - services' }
ScpMethodIndirection >> registerInInstrumenter [

	instrumenter addMethodIndirection: self
]

{ #category : 'parameters' }
ScpMethodIndirection >> reifyDefaultOperationData [

	self reifyObject.
	self reifyMethod.
	self reifyArguments
]

{ #category : 'as yet unclassified' }
ScpMethodIndirection >> reifyReceiver [

	indirectionArguments add: (ScpIndirectionArgument new
		indirection: self;
		selector: #receiver:;
		argument: [ RBVariableNode selfNode ];
		yourself
	).
]

{ #category : 'as yet unclassified' }
ScpMethodIndirection >> reifySender [

	self reifyContext
]

{ #category : 'accessing' }
ScpMethodIndirection >> selector [

	^ method selector
]

{ #category : 'as yet unclassified' }
ScpMethodIndirection >> sender [

	context ifNil: [ 
		self error: 'Please set up the indirection using #reifySender to collect the method sender.'.
	].

	^ context sender receiver
]
