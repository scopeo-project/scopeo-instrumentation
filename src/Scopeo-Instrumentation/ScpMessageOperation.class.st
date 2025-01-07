Class {
	#name : 'ScpMessageOperation',
	#superclass : 'ScpOperation',
	#instVars : [
		'sender',
		'receiver',
		'selector',
		'arguments'
	],
	#category : 'Scopeo-Instrumentation-Operations',
	#package : 'Scopeo-Instrumentation',
	#tag : 'Operations'
}

{ #category : 'accessing' }
ScpMessageOperation >> arguments [

	^ arguments
]

{ #category : 'accessing' }
ScpMessageOperation >> arguments: anObject [

	arguments := anObject
]

{ #category : 'executing' }
ScpMessageOperation >> execute [

	result := receiver perform: selector withArguments: arguments.
	^ result
]

{ #category : 'testing' }
ScpMessageOperation >> isMessage [

	^ true
]

{ #category : 'accessing' }
ScpMessageOperation >> receiver [

	^ receiver
]

{ #category : 'accessing' }
ScpMessageOperation >> receiver: anObject [

	receiver := anObject
]

{ #category : 'accessing' }
ScpMessageOperation >> selector [

	^ selector
]

{ #category : 'accessing' }
ScpMessageOperation >> selector: anObject [

	selector := anObject
]

{ #category : 'accessing' }
ScpMessageOperation >> sender [

	^ sender
]

{ #category : 'accessing' }
ScpMessageOperation >> sender: anObject [

	sender := anObject
]
