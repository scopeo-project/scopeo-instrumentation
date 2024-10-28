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

	Smalltalk globals at: self class globalSymbol put: ScpInstrumentationHandler new.
]

{ #category : 'services' }
ScpInstrumentation >> enable [

	Smalltalk globals at: self class globalSymbol put: handler.
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

	^ anObject instrument 
]

{ #category : 'services' }
ScpInstrumentation >> isEnabled [
	
	self isInstalled ifFalse: [ ^ false ].
	
	^ (Smalltalk globals at: self class globalSymbol) class ~~ ScpInstrumentationHandler
]

{ #category : 'services' }
ScpInstrumentation >> isInstalled [

	^ Smalltalk globals includesKey: self class globalSymbol
]

{ #category : 'services' }
ScpInstrumentation >> uninstall [
	
	self disable.
	self initializeDefaultHandler.
	Smalltalk globals removeKey: self class globalSymbol ifAbsent: [ "Do nothing" ].
	ScpObjectInstrumentation allInstancesDo: [ :i | i uninstall ]
]
