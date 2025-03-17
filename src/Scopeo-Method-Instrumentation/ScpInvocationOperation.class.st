Class {
	#name : 'ScpInvocationOperation',
	#superclass : 'ScpOperation',
	#instVars : [
		'arguments'
	],
	#category : 'Scopeo-Method-Instrumentation-Operations',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Operations'
}

{ #category : 'testing' }
ScpInvocationOperation class >> isAbstract [

	^ self == ScpInvocationOperation
]

{ #category : 'accessing' }
ScpInvocationOperation >> arguments [

	^ arguments
]

{ #category : 'private - parameters' }
ScpInvocationOperation >> arguments: anObject [

	arguments := anObject
]

{ #category : 'printing' }
ScpInvocationOperation >> printOn: aStream [

	aStream << (self stringFor: [ node selector ] withDefault: 'unknown node') 
		<< ', ' << (self stringFor: [ self sender ] withDefault: 'unknown sender')
		<< ', ' << (self stringFor: [ self receiver ] withDefault: 'unknown receiver')
		<< ', ' << (self stringFor: [ arguments ] withDefault: 'unknown arguments')
]

{ #category : 'accessing' }
ScpInvocationOperation >> receiver [

	self subclassResponsibility
]

{ #category : 'accessing' }
ScpInvocationOperation >> sender [

	self subclassResponsibility
]
