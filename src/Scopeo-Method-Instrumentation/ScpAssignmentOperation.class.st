Class {
	#name : 'ScpAssignmentOperation',
	#superclass : 'ScpOperation',
	#instVars : [
		'variable',
		'object',
		'newValue'
	],
	#category : 'Scopeo-Method-Instrumentation-Operations',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Operations'
}

{ #category : 'executing' }
ScpAssignmentOperation >> execute [

	object instVarNamed: variable put: newValue
]

{ #category : 'testing' }
ScpAssignmentOperation >> isAssignment [

	^ true
]

{ #category : 'accessing' }
ScpAssignmentOperation >> newValue [

	^ newValue
]

{ #category : 'accessing' }
ScpAssignmentOperation >> newValue: anObject [

	newValue := anObject
]

{ #category : 'accessing' }
ScpAssignmentOperation >> object [

	^ object
]

{ #category : 'accessing' }
ScpAssignmentOperation >> object: anObject [

	object := anObject
]

{ #category : 'accessing' }
ScpAssignmentOperation >> oldValue [

	^ object instVarNamed: variable 
]

{ #category : 'accessing' }
ScpAssignmentOperation >> variable [

	^ variable
]

{ #category : 'accessing' }
ScpAssignmentOperation >> variable: anObject [

	variable := anObject
]