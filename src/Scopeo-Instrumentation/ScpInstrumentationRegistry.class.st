Class {
	#name : #ScpInstrumentationRegistry,
	#superclass : #WeakKeyDictionary,
	#classInstVars : [
		'instance'
	],
	#category : #'Scopeo-Instrumentation-ScopeoMethodInstrumentation'
}

{ #category : #accessing }
ScpInstrumentationRegistry class >> instance [

	^ instance ifNil: [ instance := self new ]
]

{ #category : #cleanup }
ScpInstrumentationRegistry class >> uninstallAll [

	<script: 'self uninstallAll'>
	
	self instance valuesDo: [ :i | i uninstall ]
]
