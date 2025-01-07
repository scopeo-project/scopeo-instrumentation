Class {
	#name : 'ScpMessageReceivedTrace',
	#superclass : 'ScpMessageTrace',
	#category : 'Scopeo-Method-Instrumentation-Installer-Trace-Model',
	#package : 'Scopeo-Method-Instrumentation-Installer',
	#tag : 'Trace-Model'
}

{ #category : 'accessing' }
ScpMessageReceivedTrace class >> fromTraces: aTraces startingAt: anIndex [

	(aTraces at: anIndex) ~~ #received ifTrue: [ ^ nil ].

	^ self new
		selector: (aTraces at: anIndex + 1);
		sender: (aTraces at: anIndex + 2);
		receiver: (aTraces at: anIndex + 3);
		arguments: (aTraces at: anIndex + 4);
		yourself
]

{ #category : 'adding' }
ScpMessageReceivedTrace >> addToExecution: anExecution [

	^ anExecution addMessageReceived: self
]

{ #category : 'testing' }
ScpMessageReceivedTrace >> isMessageReceived [

	^ true
]

{ #category : 'accessing' }
ScpMessageReceivedTrace >> size [

	^ 4
]
