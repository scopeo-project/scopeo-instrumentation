Class {
	#name : 'ScpMessageReturnTrace',
	#superclass : 'ScpReturnTrace',
	#category : 'Scopeo-Instrumentation-Installer-Trace-Model',
	#package : 'Scopeo-Instrumentation-Installer',
	#tag : 'Trace-Model'
}

{ #category : 'as yet unclassified' }
ScpMessageReturnTrace class >> fromTraces: aTraces startingAt: anIndex [

	(aTraces at: anIndex) ~~ #messageReturn ifTrue: [ ^ nil ].

	^ self new
		node: (aTraces at: anIndex + 1);
		object: (aTraces at: anIndex + 2);
		yourself
]

{ #category : 'as yet unclassified' }
ScpMessageReturnTrace >> addToExecution: anExecution [

	^ anExecution addMessageReturn: self
]

{ #category : 'as yet unclassified' }
ScpMessageReturnTrace >> asString [

	^ 'message return ', object asString
]

{ #category : 'as yet unclassified' }
ScpMessageReturnTrace >> isMessageReturn [

	^ true
]
