Class {
	#name : 'ScpObjectEvent',
	#superclass : 'Object',
	#instVars : [
		'object'
	],
	#category : 'Scopeo-Instrumentation-GenericMethodModification',
	#package : 'Scopeo-Instrumentation',
	#tag : 'GenericMethodModification'
}

{ #category : 'testing' }
ScpObjectEvent >> isAssignment [

	^ false
]

{ #category : 'testing' }
ScpObjectEvent >> isMessage [

	^ false
]

{ #category : 'testing' }
ScpObjectEvent >> isMethod [

	^ false
]

{ #category : 'accessing' }
ScpObjectEvent >> object [

	^ object
]

{ #category : 'accessing' }
ScpObjectEvent >> object: anObject [

	object := anObject
]
