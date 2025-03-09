Class {
	#name : 'ScpMessageIndirection',
	#superclass : 'ScpMethodCallIndirection',
	#instVars : [
		'sender',
		'receiver'
	],
	#category : 'Scopeo-Method-Instrumentation',
	#package : 'Scopeo-Method-Instrumentation'
}

{ #category : 'accessing' }
ScpMessageIndirection >> performDefaultOperation [

	^ object 
		perform: self selector
		withArguments: arguments 
		inSuperclass: (
			node isSuperSend 
				ifTrue: [ object class superclass ]
				ifFalse: [ object class ]
		)
]

{ #category : 'accessing' }
ScpMessageIndirection >> receiver [

	^ receiver
]

{ #category : 'accessing' }
ScpMessageIndirection >> receiver: anObject [

	receiver := anObject
]

{ #category : 'private - services' }
ScpMessageIndirection >> registerInInstrumenter [

	instrumenter addMessageIndirection: self
]

{ #category : 'as yet unclassified' }
ScpMessageIndirection >> reifyReceiver [

	indirectionArguments add: (ScpIndirectionArgument new
		indirection: self;
		selector: #receiver:;
		argument: [ :astnode :inst |
			inst visitNode: astnode receiver 
		];
		yourself
	).
]

{ #category : 'as yet unclassified' }
ScpMessageIndirection >> reifySender [

	self reifyObject
]

{ #category : 'accessing' }
ScpMessageIndirection >> selector [

	^ node selector
]

{ #category : 'accessing' }
ScpMessageIndirection >> sender [

	^ object
]
