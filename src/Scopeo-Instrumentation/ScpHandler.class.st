Class {
	#name : 'ScpHandler',
	#superclass : 'Object',
	#instVars : [
		'block'
	],
	#category : 'Scopeo-Instrumentation-Handlers',
	#package : 'Scopeo-Instrumentation',
	#tag : 'Handlers'
}

{ #category : 'private' }
ScpHandler >> block [

	^ block
]

{ #category : 'parameters' }
ScpHandler >> evaluate: aBlock [

	block := aBlock
]

{ #category : 'private' }
ScpHandler >> handle: anOperation [

	self subclassResponsibility
]
