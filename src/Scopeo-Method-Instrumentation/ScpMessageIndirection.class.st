Class {
	#name : 'ScpMessageIndirection',
	#superclass : 'ScpIndirection',
	#category : 'Scopeo-Method-Instrumentation',
	#package : 'Scopeo-Method-Instrumentation'
}

{ #category : 'private - services' }
ScpMessageIndirection >> generateFor: aMessageNode usingModifier: aModifier argument: anArgument [

	anArgument = #node ifTrue: [ 
		^ RBLiteralValueNode value: aMessageNode
	].
	anArgument = #operation ifTrue: [ 
		^  RBBlockNode body: (RBSequenceNode statements: { 
				RBMessageNode
					receiver: (aModifier visitNode: aMessageNode receiver) 
					selector: aMessageNode selector 
					arguments: (aMessageNode arguments collect: [ :a | 
						aModifier visitNode: a.
					]) 
			})
	].
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
ScpMessageIndirection >> register: anInstrumenter [

	anInstrumenter addMessageIndirection: self
]
