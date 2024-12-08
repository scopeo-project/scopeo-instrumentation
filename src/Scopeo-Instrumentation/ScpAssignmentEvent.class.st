Class {
	#name : 'ScpAssignmentEvent',
	#superclass : 'ScpObjectEvent',
	#category : 'Scopeo-Instrumentation-GenericMethodModification',
	#package : 'Scopeo-Instrumentation',
	#tag : 'GenericMethodModification'
}

{ #category : 'instance creation' }
ScpAssignmentEvent class >> newFrom: aRFAssignmentOperation [

	^ self new
		object: aRFAssignmentOperation object;
		variable: aRFAssignmentOperation variable;
		oldValue: (aRFAssignmentOperation variable read: aRFAssignmentOperation object);
		newValue: aRFAssignmentOperation assignedValue;
		yourself
]

{ #category : 'testing' }
ScpAssignmentEvent >> isAssignment [

	^ true
]
