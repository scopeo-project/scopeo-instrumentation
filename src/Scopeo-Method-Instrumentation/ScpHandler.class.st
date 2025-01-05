Class {
	#name : 'ScpHandler',
	#superclass : 'Object',
	#instVars : [
		'block'
	],
	#category : 'Scopeo-Method-Instrumentation-Handlers',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Handlers'
}

{ #category : 'comparing' }
ScpHandler >> = aHandler [	

	self == aHandler ifTrue: [ ^ true ].

	^ (aHandler class = self class) and: [ aHandler block = block ] 
]

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
