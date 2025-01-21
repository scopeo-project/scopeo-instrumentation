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

	| oldMethod newMethod |

	oldMethod := aMethodModified oldMethod.
	newMethod := aMethodModified newMethod.

	(oldMethod isInstrumented and: [ newMethod isInstrumented not ]) ifTrue: [ 
		 oldMethod instrumentation installOn: newMethod
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
