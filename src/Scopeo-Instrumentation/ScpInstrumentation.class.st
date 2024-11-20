Class {
	#name : 'ScpInstrumentation',
	#superclass : 'Object',
	#instVars : [
		'target',
		'handler',
		'handlerVariableName'
	],
	#classInstVars : [
		'instance',
		'enabled'
	],
	#category : 'Scopeo-Instrumentation-ScopeoMethodInstrumentation',
	#package : 'Scopeo-Instrumentation',
	#tag : 'ScopeoMethodInstrumentation'
}

{ #category : 'testing' }
ScpInstrumentation class >> disable [

	enabled := false
]

{ #category : 'testing' }
ScpInstrumentation class >> enable [

	enabled := true
]

{ #category : 'testing' }
ScpInstrumentation class >> isEnabled [

	^ enabled ifNil: [ false ]
]

{ #category : 'cleanup' }
ScpInstrumentation class >> uninstallAll [

	<script: 'self uninstallAll'>
	
	ScpInstrumentationRegistry instance valuesDo: [ :i | i uninstall ]
]

{ #category : 'private' }
ScpInstrumentation >> handler [

	^ handler
]

{ #category : 'services' }
ScpInstrumentation >> handler: aHandler [

	handler := aHandler
]

{ #category : 'private' }
ScpInstrumentation >> handlerVariableName [

	^ handlerVariableName
]

{ #category : 'services' }
ScpInstrumentation >> install [

	^ self subclassResponsibility
]

{ #category : 'private' }
ScpInstrumentation >> installHandlerVariableOn: anObject [

	(anObject hasClassVarNamed: self handlerVariableName) ifTrue: [ ^ self ].
	anObject addClassVarNamed: self handlerVariableName.	
	anObject classVarNamed: self handlerVariableName put: self handler
]

{ #category : 'services' }
ScpInstrumentation >> isInstalled [

	^ ScpInstrumentationRegistry instance includesKey: target
]

{ #category : 'private' }
ScpInstrumentation >> modification [

	^ self subclassResponsibility
]

{ #category : 'private' }
ScpInstrumentation >> target [

	^ target
]

{ #category : 'services' }
ScpInstrumentation >> target: anObjectOrClass [

	target := anObjectOrClass.
	
	handlerVariableName := #handler, target hash asString
	
]

{ #category : 'services' }
ScpInstrumentation >> uninstall [

	^ self subclassResponsibility
]

{ #category : 'private' }
ScpInstrumentation >> uninstallHandlerVariableFrom: anObject [

	(anObject hasClassVarNamed: self handlerVariableName) ifFalse: [ ^ self ].
	anObject removeClassVarNamed: self handlerVariableName

]
