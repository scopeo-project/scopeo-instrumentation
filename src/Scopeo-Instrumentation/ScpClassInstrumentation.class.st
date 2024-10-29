Class {
	#name : 'ScpClassInstrumentation',
	#superclass : 'ScpInstrumentation',
	#classInstVars : [
		'proxies'
	],
	#category : 'Scopeo-Instrumentation',
	#package : 'Scopeo-Instrumentation'
}

{ #category : 'instance creation' }
ScpClassInstrumentation class >> applyOn: aClass usingHandler: anInstrumentationHandler [
	
	aClass isClass ifFalse: [ ^ aClass ].

	^ self new
		handler: anInstrumentationHandler;
		class: aClass;
		install;
		proxy

	"

	proxies ifNil: [ proxies := WeakKeyDictionary new ].
	^ proxies at: aClass ifAbsentPut: [ 
		self new
			handler: anInstrumentationHandler; 
			initializeClass: aClass;
			proxy
	] 
"
]

{ #category : 'instance removal' }
ScpClassInstrumentation class >> uninstall: aClass [

	proxies ifNotNil: [ :p |  
		p removeKey: aClass ifAbsent: [ 
			'No instrumentation for ',  aClass, '.' 	
		]
	]
]

{ #category : 'instance creation' }
ScpClassInstrumentation >> class: aClass [

	target := aClass
]

{ #category : 'actions' }
ScpClassInstrumentation >> install [

	targetClass := target classSide.
	target := target newAnonymousSubclass.

	anoClass := target classSide.
	
	self initializeInstVar

	"Smalltalk globals at: targetClass instanceSide name put: proxy."
]

{ #category : 'accessing' }
ScpClassInstrumentation >> target [

	^ targetClass instanceSide
]

{ #category : 'actions' }
ScpClassInstrumentation >> uninstall [

	Smalltalk globals at: targetClass instanceSide name put: targetClass instanceSide.
]
