Class {
	#name : 'ScpAssignmentTrace',
	#superclass : 'ScpTrace',
	#instVars : [
		'object',
		'variable',
		'value'
	],
	#category : 'Scopeo-Method-Instrumentation-Installer-Trace-Model',
	#package : 'Scopeo-Method-Instrumentation-Installer',
	#tag : 'Trace-Model'
}

{ #category : 'accessing' }
ScpAssignmentTrace class >> fromTraces: aTraces startingAt: anIndex [

	(aTraces at: anIndex) ~~ #assignment ifTrue: [ ^ nil ].

	^ self new
		node: (aTraces at: anIndex + 1);
		variable: (aTraces at: anIndex + 2);
		object: (aTraces at: anIndex + 3);
		value: (aTraces at: anIndex + 4);
		yourself
]

{ #category : 'adding' }
ScpAssignmentTrace >> addToExecution: anExecution [

	^ anExecution addStateUpdate: self
]

{ #category : 'printing' }
ScpAssignmentTrace >> asString [

	^ object asString 
		, ': ' , variable asString
		, ' := ' , value asString
]

{ #category : 'testing' }
ScpAssignmentTrace >> isAssignment [

	^ true
]

{ #category : 'accessing' }
ScpAssignmentTrace >> object [

	^ object
]

{ #category : 'accessing' }
ScpAssignmentTrace >> object: anObject [

	object := anObject
]

{ #category : 'accessing' }
ScpAssignmentTrace >> size [

	^ 4
]

{ #category : 'accessing' }
ScpAssignmentTrace >> value [

	^ value
]

{ #category : 'accessing' }
ScpAssignmentTrace >> value: anObject [

	value := anObject
]

{ #category : 'accessing' }
ScpAssignmentTrace >> variable [

	^ variable
]

{ #category : 'accessing' }
ScpAssignmentTrace >> variable: anObject [

	variable := anObject
]
