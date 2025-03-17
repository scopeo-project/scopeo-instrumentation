Class {
	#name : 'ScpMessageOperation',
	#superclass : 'ScpInvocationOperation',
	#instVars : [
		'receiver'
	],
	#category : 'Scopeo-Method-Instrumentation-Operations',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Operations'
}

{ #category : 'testing' }
ScpMessageOperation >> isMessage [

	^ true
]

{ #category : 'printing' }
ScpMessageOperation >> printOn: aStream [

	aStream << 'Message('. 
	super printOn: aStream. 
	aStream << ')'
		
]

{ #category : 'accessing' }
ScpMessageOperation >> receiver [

	^ receiver
]

{ #category : 'private - parameters' }
ScpMessageOperation >> receiver: anObject [

	receiver := anObject
]

{ #category : 'accessing' }
ScpMessageOperation >> sender [

	^ object
]
