Class {
	#name : 'ScpReturnIndirection',
	#superclass : 'ScpIndirection',
	#category : 'Scopeo-Instrumentation-GenericMethodModification',
	#package : 'Scopeo-Instrumentation',
	#tag : 'GenericMethodModification'
}

{ #category : 'private - services' }
ScpReturnIndirection >> generateFor: aReturnNode usingModifier: aModifier [

	| node |
	
	node := super generateFor: aReturnNode usingModifier: aModifier.
	node indirectionSourceNode: aReturnNode value.
	
	aReturnNode value: node.

	^ aReturnNode
]

{ #category : 'private - services' }
ScpReturnIndirection >> generateFor: aReturnNode usingModifier: aModifier argument: anArgument [

	anArgument = #value ifTrue: [
		^ aModifier visitNode: aReturnNode value 
	].

	self error: 'Unrecognized argument for an assignment indirection: ' , anArgument asString
]

{ #category : 'private - services' }
ScpReturnIndirection >> registerInModifier: aMethodModifier [

	aMethodModifier addMessageIndirection: self
]
