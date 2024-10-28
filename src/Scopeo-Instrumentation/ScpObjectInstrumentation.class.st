Class {
	#name : 'ScpObjectInstrumentation',
	#superclass : 'ScpAbstractInstrumentation',
	#category : 'Scopeo-Instrumentation',
	#package : 'Scopeo-Instrumentation'
}

{ #category : 'instance creation' }
ScpObjectInstrumentation class >> applyOn: anObject [

	anObject isLiteral ifTrue: [ ^ anObject ].
	^ self new initializeObject: anObject

]

{ #category : 'initialization' }
ScpObjectInstrumentation >> initializeObject: anObject [

	target := anObject.
	targetClass := target class.
	
	targetClass isAnonymous ifTrue: [ ^ targetClass instrument ].
	anoClass := targetClass newAnonymousSubclass.
	anoClass adoptInstance: target.
	
	^ self initializeProxy
]

{ #category : 'initialization' }
ScpObjectInstrumentation >> initializeProxy [
	
	| temp |
	
	super initializeProxy.

	temp := target. 
	target := proxy. 
	proxy := temp.

	target become: proxy.
	
	^ proxy
]

{ #category : 'actions' }
ScpObjectInstrumentation >> uninstall [

	
]
