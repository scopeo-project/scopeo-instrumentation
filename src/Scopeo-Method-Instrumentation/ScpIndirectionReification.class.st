Class {
	#name : 'ScpIndirectionReification',
	#superclass : 'Object',
	#instVars : [
		'indirection'
	],
	#category : 'Scopeo-Method-Instrumentation-Indirections',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Indirections'
}

{ #category : 'testing' }
ScpIndirectionReification class >> isAbstract [

	^ self == ScpIndirectionReification
]

{ #category : 'private - reification' }
ScpIndirectionReification >> generateForNode: anASTProgramNode [

	self subclassResponsibility
]

{ #category : 'accessing' }
ScpIndirectionReification >> indirection [

	^ indirection
]

{ #category : 'accessing' }
ScpIndirectionReification >> indirection: aScpMethodInstrumenter [

	indirection := aScpMethodInstrumenter
]

{ #category : 'accessing' }
ScpIndirectionReification >> instrumenter [

	^ indirection instrumenter
]
