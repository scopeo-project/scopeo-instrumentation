Class {
	#name : 'ScpMethodUpdater',
	#superclass : 'Object',
	#classInstVars : [
		'instance'
	],
	#category : 'Scopeo-Method-Instrumentation',
	#package : 'Scopeo-Method-Instrumentation'
}

{ #category : 'accessing' }
ScpMethodUpdater class >> start [

	instance ifNil: [ instance := self new ].
	instance start
]

{ #category : 'accessing' }
ScpMethodUpdater class >> stop [

	instance ifNotNil: [ :i | i stop ]
]

{ #category : 'system annoucements' }
ScpMethodUpdater >> handleMethodModified: aMethodModified [

	aMethodModified oldMethod isInstrumented ifTrue: [ 
		 aMethodModified oldMethod instrumentation 
			installOn: aMethodModified newMethod
	]
]

{ #category : 'initialization' }
ScpMethodUpdater >> start [

	self class codeChangeAnnouncer
		when: MethodModified
		send: #handleMethodModified:
		to: self
]

{ #category : 'accessing' }
ScpMethodUpdater >> stop [

	self class codeChangeAnnouncer unsubscribe: self
]
