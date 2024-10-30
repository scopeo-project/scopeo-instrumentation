Class {
	#name : #ScpClassInstrumentation,
	#superclass : #ScpInstrumentation,
	#category : 'Scopeo-Instrumentation'
}

{ #category : #'instance creation' }
ScpClassInstrumentation class >> applyOn: aClass usingHandler: anInstrumentationHandler [
	
	aClass isClass ifFalse: [ ^ aClass ].
	^ self new
		object: aClass handler: anInstrumentationHandler;
		install;
		proxy
]

{ #category : #initialization }
ScpClassInstrumentation >> install [
	
	objectClass := object classSide copy.

	self initializeLookupClass: object.
	lookupClass := lookupClass classSide.
	lookupClass methodDictionary removeAll.
	
	self enable.

	
]

{ #category : #initialization }
ScpClassInstrumentation >> uninstall [

	self disable.
	
	lookupClass methodDictionary: objectClass methodDict.
	object removeClassVarNamed: self class handlerSymbol.
	object removeClassVarNamed: self class proxySymbol
	
	
]
