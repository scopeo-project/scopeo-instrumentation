Class {
	#name : 'ScpAssignmentOperation',
	#superclass : 'ScpOperation',
	#instVars : [
		'newValue',
		'oldValue'
	],
	#category : 'Scopeo-Method-Instrumentation-Operations',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Operations'
}

{ #category : 'testing' }
ScpAssignmentOperation >> isAssignment [

	^ true
]

{ #category : 'accessing' }
ScpAssignmentOperation >> newValue [

	^ newValue
]

{ #category : 'private - parameters' }
ScpAssignmentOperation >> newValue: anObject [

	newValue := anObject
]

{ #category : 'accessing' }
ScpAssignmentOperation >> oldValue [

	^ oldValue
]

{ #category : 'private - parameters' }
ScpAssignmentOperation >> oldValue: anObject [

	oldValue := anObject
]

{ #category : 'printing' }
ScpAssignmentOperation >> printOn: aStream [

	aStream 
		<< 'Assignment(' 
		<< (self stringFor: [ node variable name ] withDefault: 'unknown node') 
		<< ', ' << (self stringFor: [ oldValue ] withDefault: 'unknown old-value')  
		<< ', ' << (self stringFor: [ newValue ] withDefault: 'unknown new-value')
		<< ')'
]
