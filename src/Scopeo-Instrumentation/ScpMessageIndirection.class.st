Class {
	#name : 'ScpMessageIndirection',
	#superclass : 'ScpIndirection',
	#category : 'Scopeo-Instrumentation-GenericMethodModification',
	#package : 'Scopeo-Instrumentation',
	#tag : 'GenericMethodModification'
}

{ #category : 'private - services' }
ScpMessageIndirection >> generateFor: aMessageNode usingModifier: aModifier argument: anArgument [

	anArgument = #selector ifTrue: [ 
		^ RBLiteralValueNode value: aMessageNode selector 
	].
	anArgument = #sender ifTrue: [
		^ RBVariableNode selfNode 
	].
	anArgument = #receiver ifTrue: [ 
		^ aModifier visitNode: aMessageNode receiver 
	].
	anArgument = #arguments ifTrue: [ 
		^ RBArrayNode statements: (aMessageNode arguments collect: [ :each |
			aModifier visitNode: each 
		]) 
	].
	self error: 'Unrecognized argument for a message indirection: ', anArgument asString
]

{ #category : 'private - services' }
ScpMessageIndirection >> registerInModifier: aMethodModifier [

	aMethodModifier addMessageIndirection: self
]
