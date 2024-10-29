Class {
	#name : 'ScpObjectInstrumentation',
	#superclass : 'ScpInstrumentation',
	#instVars : [
		'uninstalling'
	],
	#category : 'Scopeo-Instrumentation',
	#package : 'Scopeo-Instrumentation'
}

{ #category : 'instance creation' }
ScpObjectInstrumentation class >> applyOn: anObject usingHandler: anInstrumentationHandler [

	anObject isLiteral | anObject isBlock ifTrue: [ ^ anObject ].
	^ self new
		object: anObject handler: anInstrumentationHandler;
		install;
		proxy
		

]

{ #category : 'actions' }
ScpObjectInstrumentation >> install [

	| temp |

	objectClass := object class.
	objectClass isAnonymous ifTrue: [ ^ self ].
	
	self initializeLookupClass: objectClass newAnonymousSubclass.
	
	lookupClass adoptInstance: object.
	
	temp := object. 
	object := proxy. 
	proxy := temp.

	object become: proxy.
]

{ #category : 'actions' }
ScpObjectInstrumentation >> uninstall [

	self disable.

	objectClass adoptInstance: object.
	
	proxy become: object.
]
