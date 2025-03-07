Class {
	#name : 'ScpAssignmentIndirection',
	#superclass : 'ScpIndirection',
	#category : 'Scopeo-Method-Instrumentation',
	#package : 'Scopeo-Method-Instrumentation'
}

{ #category : 'private - services' }
ScpAssignmentIndirection >> generateFor: anAssignmentNode usingModifier: aModifier argument: anArgument [
	
	anArgument = #node ifTrue: [ 
		^ RBLiteralValueNode value: anAssignmentNode
	].
	anArgument = #operation ifTrue: [ 
		^  RBBlockNode
				arguments: { RBVariableNode named: #v }
				body: (RBSequenceNode statements: { 
					RBAssignmentNode
						variable: anAssignmentNode variable
						value: (RBVariableNode named: #v) 
				})
	].
	anArgument = #object ifTrue: [ 
		^ RBVariableNode selfNode 
	].
	anArgument = #variable ifTrue: [ 
		^ RBLiteralValueNode value: anAssignmentNode variable variable
	].
	anArgument = #oldValue ifTrue: [ 
		^ anAssignmentNode variable
	].
	anArgument = #newValue ifTrue: [ 
		^ aModifier visitNode: anAssignmentNode value 
	].
	self error: 'Unrecognized argument for an variable assignment indirection: ', anArgument asString
]

{ #category : 'private - services' }
ScpAssignmentIndirection >> register: anInstrumenter [

	anInstrumenter addAssignmentIndirection: self
]
