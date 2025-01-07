Class {
	#name : 'ScpMessageSentTrace',
	#superclass : 'ScpMessageTrace',
	#category : 'Scopeo-Method-Instrumentation-Installer-Trace-Model',
	#package : 'Scopeo-Method-Instrumentation-Installer',
	#tag : 'Trace-Model'
}

{ #category : 'accessing' }
ScpMessageSentTrace class >> fromTraces: aTraces startingAt: anIndex [

	^ (super fromTraces: aTraces startingAt: anIndex)
		ifNil: [  
			(aTraces at: anIndex) ~~ #send ifTrue: [ ^ nil ].

			self new
				node: (aTraces at: anIndex + 1);
				selector: (aTraces at: anIndex + 2);
				sender: (aTraces at: anIndex + 3);
				receiver: (aTraces at: anIndex + 4);
				arguments: (aTraces at: anIndex + 5);
				yourself
		]
]

{ #category : 'adding' }
ScpMessageSentTrace >> addToExecution: anExecution [

	^ anExecution addMessageSent: self
]

{ #category : 'testing' }
ScpMessageSentTrace >> isMessageSent [

	^ true
]

{ #category : 'testing' }
ScpMessageSentTrace >> isMessageToSuper [

	^ false
]

{ #category : 'accessing' }
ScpMessageSentTrace >> size [

	^ 5
]
