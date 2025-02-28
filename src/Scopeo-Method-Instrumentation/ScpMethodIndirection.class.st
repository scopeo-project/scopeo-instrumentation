Class {
	#name : 'ScpMethodIndirection',
	#superclass : 'ScpIndirection',
	#category : 'Scopeo-Method-Instrumentation',
	#package : 'Scopeo-Method-Instrumentation'
}

{ #category : 'private' }
ScpMethodIndirection class >> run: aMethod on: aReceiver arguments: aArguments [
	
	^ aReceiver withArgs: aArguments executeMethod: aMethod 
]

{ #category : 'private - services' }
ScpMethodIndirection >> generateFor: aMethodNode usingModifier: aModifier [

	| message |
	
	message := super generateFor: aMethodNode usingModifier: aModifier.
	
	^ (RBMethodNode
			selector: aMethodNode selector 
			arguments: aMethodNode arguments
			body: (RBSequenceNode statements: { RBReturnNode value: message }))
			methodClass: aMethodNode methodClass;
			yourself
]

{ #category : 'private - services' }
ScpMethodIndirection >> generateFor: aMethodNode usingModifier: aModifier argument: anArgument [

	anArgument = #method ifTrue: [ 
		^ RBLiteralValueNode value: (aModifier instrument: aMethodNode compiledMethod)
	].

	anArgument = #operation ifTrue: [ 
		^ RBBlockNode body: (RBSequenceNode statements: { (RBMessageNode
			    receiver: RBVariableNode selfNode
			    selector: #withArgs:executeMethod:
			    arguments: {
						RBArrayNode statements: aMethodNode arguments.
						RBLiteralValueNode value: (aModifier instrument: aMethodNode compiledMethod)
				 }) 
		  })
	].

	anArgument = #sender ifTrue: [ 
		^ RBMessageNode
			receiver: (RBMessageNode
				receiver: (RBVariableNode named: #thisContext)
			 	selector: #sender)
			selector: #receiver
	].

	anArgument = #receiver ifTrue: [ 
		^ RBVariableNode selfNode
	].

	anArgument = #arguments ifTrue: [ 
		^ RBArrayNode statements: aMethodNode arguments
	]
]

{ #category : 'private - services' }
ScpMethodIndirection >> register: anInstrumenter [

	anInstrumenter addMethodIndirection: self
]
