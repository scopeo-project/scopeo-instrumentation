Class {
	#name : 'ScpMethodUpdater',
	#superclass : 'Object',
	#classInstVars : [
		'instance'
	],
	#category : 'Scopeo-Instrumentation-GenericMethodModification',
	#package : 'Scopeo-Instrumentation',
	#tag : 'GenericMethodModification'
}

{ #category : 'accessing' }
ScpMethodUpdater class >> start [

	instance ifNil: [ instance := self new ]
]

{ #category : 'accessing' }
ScpMethodUpdater class >> stop [

	instance ifNotNil: [ :i | i stop ]
]

{ #category : 'system annoucements' }
ScpMethodUpdater >> handleMethodModified: aMethodModified [

	aMethodModified oldMethod isModifiedMethod ifTrue: [ 
		 aMethodModified oldMethod modification 
			method: aMethodModified newMethod;
			install
	]
]

{ #category : 'initialization' }
ScpMethodUpdater >> initialize [

	self class codeChangeAnnouncer
		when: MethodModified
		send: #handleMethodModified:
		to: self
]

{ #category : 'accessing' }
ScpMethodUpdater >> stop [

	self class codeChangeAnnouncer unsubscribe: self
]
