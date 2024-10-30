Class {
	#name : 'ScpInstrumentation',
	#superclass : 'Object',
	#traits : 'ScpInstrumentationMethodRewriter',
	#classTraits : 'ScpInstrumentationMethodRewriter classTrait',
	#instVars : [
		'enabled',
		'handler',
		'object',
		'objectClass',
		'lookupClass',
		'proxy'
	],
	#category : 'Scopeo-Instrumentation',
	#package : 'Scopeo-Instrumentation'
}

{ #category : 'services' }
ScpInstrumentation >> disable [

	enabled := false.
]

{ #category : 'services' }
ScpInstrumentation >> enable [

	enabled := true.
]

{ #category : 'private - hook' }
ScpInstrumentation >> handleMessage: aMessage [

	| return |
	self isEnabled ifFalse: [ 
		^ MirrorPrimitives
		  withReceiver: object
		  perform: aMessage selector
		  withArguments: aMessage arguments
		  inSuperclass: rewritingClass superclass.
	].
	self disable.
	
	(rewritingClass superclass lookupSelector: aMessage selector) ifNotNil: [ :m | 
		self instrument: m
	].

	handler 
		message: aMessage selector 
		sender: thisContext sender sender receiver 
		receiver: object 
		arguments: aMessage arguments.

	return := MirrorPrimitives
		  withReceiver: object
		  perform: aMessage selector
		  withArguments: aMessage arguments.
	
	handler return: return.
	self enable.
			
 	^ return

	
]

{ #category : 'parameters' }
ScpInstrumentation >> handler: aHandler [

	handler := aHandler
]

{ #category : 'initialization' }
ScpInstrumentation >> initialize [
	
	self disable

	
]

{ #category : 'private - rewriting' }
ScpInstrumentation >> instrument: aMethod [
	"
	Instrument the selector and compile it in the subclass, if:
	- The object has been attached to an anonymous subclass.
	- That anonymous subclass does not already contains the selector in argument.
	"
	rewritingClass ifNil: [ ^ self ].
	(rewritingClass includesSelector: aMethod selector) ifTrue: [ ^ self ]. 

	(aMethod hasPragmaNamed: #noInstrumentation) ifTrue: [ ^ self ].
	
	[ self rewrite: aMethod ]
		onErrorDo: [ :e | 
			Smalltalk logStdOutDuring: [ :logger |
				logger	 nextPutAll: e; cr 
			] 
		]
]

{ #category : 'services' }
ScpInstrumentation >> isEnabled [

	^ enabled
]

{ #category : 'parameters' }
ScpInstrumentation >> object: anObject [ 

	object := anObject	
]
