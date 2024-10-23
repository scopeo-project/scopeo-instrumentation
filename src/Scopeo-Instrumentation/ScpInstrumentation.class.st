Class {
	#name : 'ScpInstrumentation',
	#superclass : 'Object',
	#instVars : [
		'handler',
		'methodsToInstrument',
		'visitor',
		'enabled'
	],
	#classInstVars : [
		'instance'
	],
	#category : 'Scopeo-Instrumentation',
	#package : 'Scopeo-Instrumentation'
}

{ #category : 'applying' }
ScpInstrumentation class >> applyOn: anObject [

	^ self instance 
		instrument: anObject; 
		install;
		enable;
		yourself  
]

{ #category : 'accessing' }
ScpInstrumentation class >> instance [

	^ instance ifNil: [ instance := self new ]
]

{ #category : 'private' }
ScpInstrumentation class >> uninstall [

	<script: 'self uninstall'>
	self instance uninstall
]

{ #category : 'services' }
ScpInstrumentation >> disable [

	Smalltalk globals at: #'_SCOPEO' put: ScpInstrumentationHandler new.
]

{ #category : 'services' }
ScpInstrumentation >> enable [

	Smalltalk globals at: #'_SCOPEO' put: handler.
]

{ #category : 'services' }
ScpInstrumentation >> handler [

	^ handler
]

{ #category : 'parameters' }
ScpInstrumentation >> handler: aHandler [

	handler := aHandler



	
]

{ #category : 'initialization' }
ScpInstrumentation >> initialize [

	self initializeDefaultHandler
]

{ #category : 'initialization' }
ScpInstrumentation >> initializeDefaultHandler [

	handler := ScpInstrumentationTracer new
]

{ #category : 'services' }
ScpInstrumentation >> install [

	self isInstalled ifTrue: [ ^ self ].
	self disable.
]

{ #category : 'intrumenting' }
ScpInstrumentation >> instrument: anObject [

	^ ScpObjectInstrumentation applyOn: anObject 
]

{ #category : 'services' }
ScpInstrumentation >> isEnabled [
	
	self isInstalled ifFalse: [ ^ false ].
	
	^ (Smalltalk globals at: #'_SCOPEO') class ~~ ScpInstrumentationHandler
]

{ #category : 'services' }
ScpInstrumentation >> isInstalled [

	^ Smalltalk globals includesKey: #'_SCOPEO'
]

{ #category : 'services' }
ScpInstrumentation >> uninstall [
	
	self disable.
	self initializeDefaultHandler.
	Smalltalk globals removeKey: #'_SCOPEO' ifAbsent: [ "Do nothing" ].
	ScpObjectInstrumentation allInstancesDo: [ :i | i uninstall ]
]
