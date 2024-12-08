Class {
	#name : 'ScpReturnEmpty',
	#superclass : 'ScpAbstractReturn',
	#category : 'Scopeo-Instrumentation-GenericMethodModification',
	#package : 'Scopeo-Instrumentation',
	#tag : 'GenericMethodModification'
}

{ #category : 'testing' }
ScpReturnEmpty >> isEmpty [

	^ true
]

{ #category : 'testing' }
ScpReturnEmpty >> isNotEmpty [

	^ false
]

{ #category : 'accessing' }
ScpReturnEmpty >> object [

	self error: 'Return object not computed yet'
]
