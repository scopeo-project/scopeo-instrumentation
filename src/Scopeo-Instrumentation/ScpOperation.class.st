Class {
	#name : 'ScpOperation',
	#superclass : 'Object',
	#instVars : [
		'result'
	],
	#category : 'Scopeo-Instrumentation-Operations',
	#package : 'Scopeo-Instrumentation',
	#tag : 'Operations'
}

{ #category : 'executing' }
ScpOperation >> execute [

	self subclassResponsibility 
]

{ #category : 'testing' }
ScpOperation >> isAssignment [

	^ false
]

{ #category : 'testing' }
ScpOperation >> isMessage [

	^ false
]

{ #category : 'testing' }
ScpOperation >> isMethod [

	^ false
]

{ #category : 'accessing' }
ScpOperation >> result [

	^ result
]
