Class {
	#name : 'ScpMethodOperation',
	#superclass : 'ScpOperation',
	#instVars : [
		'sender',
		'receiver',
		'method',
		'arguments'
	],
	#category : 'Scopeo-Method-Instrumentation-Operations',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Operations'
}

{ #category : 'accessing' }
ScpMethodOperation >> arguments [

	^ arguments
]

{ #category : 'accessing' }
ScpMethodOperation >> arguments: anObject [

	arguments := anObject
]

{ #category : 'executing' }
ScpMethodOperation >> execute [

	result := receiver withArgs: arguments executeMethod: method.
	^ result
]

{ #category : 'testing' }
ScpMethodOperation >> isMethod [

	^ true
]

{ #category : 'accessing' }
ScpMethodOperation >> method: anObject [

	method := anObject
]

{ #category : 'accessing' }
ScpMethodOperation >> receiver [

	^ receiver
]

{ #category : 'accessing' }
ScpMethodOperation >> receiver: anObject [

	receiver := anObject
]

{ #category : 'accessing' }
ScpMethodOperation >> selector [

	^ method selector
]

{ #category : 'accessing' }
ScpMethodOperation >> sender [

	^ sender
]

{ #category : 'accessing' }
ScpMethodOperation >> sender: anObject [

	sender := anObject
]
