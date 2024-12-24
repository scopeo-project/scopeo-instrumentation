Class {
	#name : 'ScpAssignmentIndirection',
	#superclass : 'ScpIndirection',
	#category : 'Scopeo-Instrumentation-GenericMethodModification',
	#package : 'Scopeo-Instrumentation',
	#tag : 'GenericMethodModification'
}

{ #category : 'private - services' }
ScpAssignmentIndirection >> generateFor: anAssignmentNode usingModifier: aModifier argument: anArgument [
	
	anArgument = #object ifTrue: [ 
		^ RBVariableNode selfNode 
	].
	anArgument = #variable ifTrue: [ 
		^ RBLiteralValueNode value: anAssignmentNode variable name 
	].
	anArgument = #newValue ifTrue: [ 
		^ aModifier visitNode: anAssignmentNode value 
	].
	self error: 'Unrecognized argument for an assignment indirection: ', anArgument asString
]

{ #category : 'private - services' }
ScpAssignmentIndirection >> registerInModifier: aMethodModifier [

	aMethodModifier addAssignmentIndirection: self
]
