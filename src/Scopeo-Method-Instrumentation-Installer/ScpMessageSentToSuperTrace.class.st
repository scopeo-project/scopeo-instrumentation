Class {
	#name : 'ScpMessageSentToSuperTrace',
	#superclass : 'ScpMessageSentTrace',
	#category : 'Scopeo-Method-Instrumentation-Installer-Trace-Model',
	#package : 'Scopeo-Method-Instrumentation-Installer',
	#tag : 'Trace-Model'
}

{ #category : 'accessing' }
ScpMessageSentToSuperTrace class >> fromTraces: aTraces startingAt: anIndex [

	(aTraces at: anIndex) ~~ #super ifTrue: [ ^ nil ].

	^ self new
		node: (aTraces at: anIndex + 1);
		selector: (aTraces at: anIndex + 2);
		sender: (aTraces at: anIndex + 3);
		receiver: (aTraces at: anIndex + 3);
		arguments: (aTraces at: anIndex + 4);
		yourself
]

{ #category : 'adding' }
ScpMessageSentToSuperTrace >> addToExecution: anExecution [

	^ anExecution addMessageSentToSuper: self
]

{ #category : 'as yet unclassified' }
ScpMessageSentToSuperTrace >> asString [

	^ 'super: ', super asString
]

{ #category : 'testing' }
ScpMessageSentToSuperTrace >> isMessageToSuper [

	^ true
]

{ #category : 'accessing' }
ScpMessageSentToSuperTrace >> size [

	^ 4
]
