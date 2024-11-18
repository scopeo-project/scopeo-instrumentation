Class {
	#name : #ScpInstrumentation,
	#superclass : #Object,
	#instVars : [
		'target',
		'handler',
		'handlerVariableName'
	],
	#classInstVars : [
		'instance'
	],
	#category : #'Scopeo-Instrumentation-ScopeoMethodInstrumentation'
}

{ #category : #accessing }
ScpInstrumentation class >> instance [

	^ instance ifNil: [ instance := self new ]
]

{ #category : #accessing }
ScpInstrumentation >> handler: aHandler [

	handler := aHandler
]

{ #category : #actions }
ScpInstrumentation >> install [

	^ self subclassResponsibility
]

{ #category : #testing }
ScpInstrumentation >> isInstalled [

	^ ScpInstrumentationRegistry instance includesKey: target
]

{ #category : #accessing }
ScpInstrumentation >> target: anObjectOrClass [

	target := anObjectOrClass.
	
	handlerVariableName := #handler, target hash asString
	
]

{ #category : #actions }
ScpInstrumentation >> uninstall [

	^ self subclassResponsibility
]
