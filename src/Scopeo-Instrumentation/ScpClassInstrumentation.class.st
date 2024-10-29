Class {
	#name : 'ScpClassInstrumentation',
	#superclass : 'ScpInstrumentation',
	#category : 'Scopeo-Instrumentation',
	#package : 'Scopeo-Instrumentation'
}

{ #category : 'instance creation' }
ScpClassInstrumentation class >> applyOn: aClass usingHandler: anInstrumentationHandler [
	
	aClass isClass ifFalse: [ ^ aClass ].
	^ self new
		object: aClass handler: anInstrumentationHandler;
		install;
		proxy
]

{ #category : 'initialization' }
ScpClassInstrumentation >> install [

	objectClass := object classSide.
	object := object newAnonymousSubclass.

	self initializeLookupClass: object classSide.
	
	Smalltalk globals at: objectClass instanceSide name put: proxy.
]

{ #category : 'initialization' }
ScpClassInstrumentation >> uninstall [

	self disable.

	Smalltalk globals at: objectClass instanceSide name put: objectClass instanceSide.
]
