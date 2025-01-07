Class {
	#name : 'ScpTraceSourceSelection',
	#superclass : 'Object',
	#instVars : [
		'packages',
		'classes',
		'methods'
	],
	#category : 'Scopeo-Method-Instrumentation-Installer-Model',
	#package : 'Scopeo-Method-Instrumentation-Installer',
	#tag : 'Model'
}

{ #category : 'accessing' }
ScpTraceSourceSelection >> classes [

	^ classes
]

{ #category : 'modifying' }
ScpTraceSourceSelection >> classes: aCollection [

	classes := aCollection asOrderedCollection
]

{ #category : 'initialization' }
ScpTraceSourceSelection >> initialize [

	packages := OrderedCollection empty.
	classes := OrderedCollection empty.
	methods := Dictionary empty
	
]

{ #category : 'accessing' }
ScpTraceSourceSelection >> methodAt: aMethodName [

	"Unused method, to remove in the future"
	
	self flag: #deprecated.

	^ methods at: aMethodName ifAbsent: [ ^ nil ]
]

{ #category : 'accessing' }
ScpTraceSourceSelection >> methods [

	^ methods
]

{ #category : 'modifying' }
ScpTraceSourceSelection >> methods: aCollection [

	methods := aCollection asOrderedCollection
]

{ #category : 'accessing' }
ScpTraceSourceSelection >> packages [

	^ packages
]

{ #category : 'modifying' }
ScpTraceSourceSelection >> packages: aCollection [

	packages := aCollection asOrderedCollection 
]
