Class {
	#name : 'ScpReturnObject',
	#superclass : 'ScpAbstractReturn',
	#instVars : [
		'object'
	],
	#category : 'Scopeo-Instrumentation-GenericMethodModification',
	#package : 'Scopeo-Instrumentation',
	#tag : 'GenericMethodModification'
}

{ #category : 'testing' }
ScpReturnObject >> isEmpty [

	^ false
]

{ #category : 'testing' }
ScpReturnObject >> isNotEmpty [

	^ true
]

{ #category : 'accessing' }
ScpReturnObject >> object [

	^ object
]

{ #category : 'hooks' }
ScpReturnObject >> return: anObject [

	object := anObject
]
