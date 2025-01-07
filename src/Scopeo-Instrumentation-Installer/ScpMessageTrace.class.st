Class {
	#name : 'ScpMessageTrace',
	#superclass : 'ScpTrace',
	#instVars : [
		'sender',
		'selector',
		'receiver',
		'arguments'
	],
	#category : 'Scopeo-Instrumentation-Installer-Trace-Model',
	#package : 'Scopeo-Instrumentation-Installer',
	#tag : 'Trace-Model'
}

{ #category : 'testing' }
ScpMessageTrace class >> isAbstract [

	^ self == ScpMessageTrace
]

{ #category : 'accessing' }
ScpMessageTrace >> arguments [

	^ arguments
]

{ #category : 'accessing' }
ScpMessageTrace >> arguments: anObject [

	arguments := anObject
]

{ #category : 'printing' }
ScpMessageTrace >> asString [

	^ sender asString 
		, ' sent ', selector asString
		, ' to ', receiver asString 
		, ' with ', arguments asString
]

{ #category : 'testing' }
ScpMessageTrace >> isMessage [

	^ true
]

{ #category : 'testing' }
ScpMessageTrace >> isMessageReceived [

	^ false
]

{ #category : 'testing' }
ScpMessageTrace >> isMessageSent [

	^ false
]

{ #category : 'testing' }
ScpMessageTrace >> isMessageToSuper [

	^ false
]

{ #category : 'accessing' }
ScpMessageTrace >> receiver [

	^ receiver
]

{ #category : 'accessing' }
ScpMessageTrace >> receiver: anObject [

	receiver := anObject
]

{ #category : 'accessing' }
ScpMessageTrace >> selector [

	^ selector
]

{ #category : 'accessing' }
ScpMessageTrace >> selector: anObject [

	selector := anObject
]

{ #category : 'accessing' }
ScpMessageTrace >> sender [

	^ sender
]

{ #category : 'accessing' }
ScpMessageTrace >> sender: anObject [

	sender := anObject
]
