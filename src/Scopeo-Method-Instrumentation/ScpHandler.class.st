Class {
	#name : 'ScpHandler',
	#superclass : 'Object',
	#instVars : [
		'block',
		'enabled'
	],
	#category : 'Scopeo-Method-Instrumentation-Handlers',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Handlers'
}

{ #category : 'private' }
ScpHandler >> block [

	^ block
]

{ #category : 'testing' }
ScpHandler >> disable [

	enabled := false
]

{ #category : 'testing' }
ScpHandler >> enable [

	enabled := true
]

{ #category : 'parameters' }
ScpHandler >> evaluate: aBlock [

	block := aBlock
]

{ #category : 'private' }
ScpHandler >> handle: anOperation [

	self subclassResponsibility
]

{ #category : 'initialization' }
ScpHandler >> initialize [

	self enable
]

{ #category : 'testing' }
ScpHandler >> isEnabled [

	^ enabled
]
