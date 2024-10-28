Class {
	#name : 'ScpClassInstrumentation',
	#superclass : 'ScpAbstractInstrumentation',
	#classInstVars : [
		'proxies'
	],
	#category : 'Scopeo-Instrumentation',
	#package : 'Scopeo-Instrumentation'
}

{ #category : 'applying' }
ScpClassInstrumentation class >> applyOn: aClass [

	aClass isClass ifFalse: [ ^ aClass ].

	proxies ifNil: [ proxies := WeakKeyDictionary new ].
	^ proxies at: aClass ifAbsentPut: [ 
		self new initializeClass: aClass 
	] 

]

{ #category : 'initialization' }
ScpClassInstrumentation >> initializeClass: aClass [

	targetClass := aClass classSide.
	target := aClass newAnonymousSubclass.
	anoClass := target classSide.
	
	^ self initializeProxy
]
