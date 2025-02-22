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
ScpMethodIndirection >> generate [

	^ (RBMethodNode
		   selector: #run:on:arguments:
		   arguments: {
				   (RBVariableNode named: #aMethod).
				   (RBVariableNode named: #aReceiver).
				   (RBVariableNode named: #aArguments) }
		   body:
			   (RBSequenceNode statements:
				    { (RBReturnNode value: (RBMessageNode
						      receiver: (RBLiteralValueNode value: handler)
						      selector: selector
						      arguments:
						      (arguments collect: [ :a | self generateArgument: a ]))) }))
		  generateMethod
]

{ #category : 'private - services' }
ScpMethodIndirection >> generateArgument: anArgument [

	anArgument = #method ifTrue: [ 
		^ RBVariableNode named: #aMethod
	].
	anArgument = #operation ifTrue: [ 
		^ RBBlockNode body: (RBSequenceNode statements: { (RBMessageNode
			    receiver: (RBVariableNode named: #aReceiver)
			    selector: #withArgs:executeMethod:
			    arguments: {
						RBVariableNode named: #aArguments.
						RBVariableNode named: #aMethod
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
		^ RBVariableNode named: #aReceiver
	].
	anArgument = #arguments ifTrue: [ 
		^ RBVariableNode named: #aArguments
	]	
]

{ #category : 'private - services' }
ScpMethodIndirection >> register: anInstrumentation [

	anInstrumentation registerMethodIndirection: self
]
