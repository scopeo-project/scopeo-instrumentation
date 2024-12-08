Class {
	#name : 'ScpAbstractReturn',
	#superclass : 'Object',
	#category : 'Scopeo-Instrumentation-GenericMethodModification',
	#package : 'Scopeo-Instrumentation',
	#tag : 'GenericMethodModification'
}

{ #category : 'testing' }
ScpAbstractReturn >> isEmpty [

	self subclassResponsibility
]

{ #category : 'testing' }
ScpAbstractReturn >> isNotEmpty [

	self subclassResponsibility
]

{ #category : 'accessing' }
ScpAbstractReturn >> object [

	self subclassResponsibility
]
