Class {
	#name : 'ScpMethodOperation',
	#superclass : 'ScpInvocationOperation',
	#category : 'Scopeo-Method-Instrumentation-Operations',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Operations'
}

{ #category : 'testing' }
ScpMethodOperation >> isMethod [

	^ true
]

{ #category : 'printing' }
ScpMethodOperation >> printOn: aStream [

	aStream << 'Method('. 
	super printOn: aStream. 
	aStream << ')'
]

{ #category : 'accessing' }
ScpMethodOperation >> receiver [

	^ self object
]

{ #category : 'accessing' }
ScpMethodOperation >> sender [

	context ifNil: [ ^ nil ].

	^ context sender receiver
]
