Class {
	#name : 'ScpObjectInstrumentation',
	#superclass : 'ScpInstrumentation',
	#category : 'Scopeo-Instrumentation',
	#package : 'Scopeo-Instrumentation'
}

{ #category : 'instance creation' }
ScpObjectInstrumentation class >> applyOn: anObject usingHandler: anInstrumentationHandler [

	anObject isLiteral | anObject isBlock ifTrue: [ ^ anObject ].
	^ self new 
		handler: anInstrumentationHandler;
		object: anObject;
		install;
		proxy
		

]

{ #category : 'actions' }
ScpObjectInstrumentation >> install [

	| temp |

	targetClass := target class.
	
	targetClass isAnonymous ifTrue: [ ^ self ].
	anoClass := targetClass newAnonymousSubclass.
	anoClass adoptInstance: target.
	
	self initializeInstVars.
	
	temp := target. 
	target := proxy. 
	proxy := temp.

	target become: proxy.
]

{ #category : 'initialization' }
ScpObjectInstrumentation >> object: anObject [

	target := anObject
]

{ #category : 'accessing' }
ScpObjectInstrumentation >> target [

	^ target
]

{ #category : 'actions' }
ScpObjectInstrumentation >> uninstall [

	targetClass adoptInstance: target.
	proxy become: target
]
