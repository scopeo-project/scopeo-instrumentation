Class {
	#name : 'ScpTrace',
	#superclass : 'Object',
	#instVars : [
		'node'
	],
	#category : 'Scopeo-Instrumentation-Installer-Trace-Model',
	#package : 'Scopeo-Instrumentation-Installer',
	#tag : 'Trace-Model'
}

{ #category : 'accessing' }
ScpTrace class >> fromTraces: aScpIterator startingAt: anIndex [

	^ (self subclasses collect: [ :c | c fromTraces: aScpIterator startingAt: anIndex ])
		detect: [ :t | t isNotNil ]
		ifNone: [ nil ]
]

{ #category : 'testing' }
ScpTrace class >> isAbstract [

	^ self == ScpTrace
]

{ #category : 'adding' }
ScpTrace >> addToExecution: anExecution [

	self subclassResponsibility
]

{ #category : 'testing' }
ScpTrace >> isAssignment [

	^ false
]

{ #category : 'testing' }
ScpTrace >> isMessage [

	^ false
]

{ #category : 'testing' }
ScpTrace >> isReturn [

	^ false
]

{ #category : 'accessing' }
ScpTrace >> node [

	^ node
]

{ #category : 'accessing' }
ScpTrace >> node: anObject [

	node := anObject
]

{ #category : 'printing' }
ScpTrace >> printOn: aStream [

	aStream << self asString
]

{ #category : 'accessing' }
ScpTrace >> size [

	self subclassResponsibility
]
