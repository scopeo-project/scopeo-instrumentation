Class {
	#name : #ScpObjectProxy,
	#superclass : #nil,
	#instVars : [
		'object',
		'handler',
		'modification'
	],
	#category : #'Scopeo-Instrumentation-ScopeoMethodInstrumentation'
}

{ #category : #'reflective operations' }
ScpObjectProxy >> basicIdentityHash [
	"See ProtoObject >> #basicIdentityHash"

	<primitive: 75>
	self primitiveFailed
]

{ #category : #'deferred message' }
ScpObjectProxy >> doesNotUnderstand: aMessage [

	<debuggerCompleteToSender>
	
	(object class hasSelector: aMessage selector) ifFalse: [ 
		(object class superclass lookupSelector: aMessage selector) ifNotNil: [ :m | 
			m applyModification: modification andIfAbsentInstallIn: object class. 
		].	
	].

	^ MirrorPrimitives
			withReceiver: object
		  	perform: aMessage selector
		  	withArguments: aMessage arguments
		  	inSuperclass: object class superclass. 
]

{ #category : #comparing }
ScpObjectProxy >> hash [

	^ self identityHash
]

{ #category : #comparing }
ScpObjectProxy >> identityHash [
	"See ProtoObject >> #identityHash"

	^ self basicIdentityHash bitShift: 8
]

{ #category : #services }
ScpObjectProxy >> instrument: anInstrumentationHandler [

	^ self
]

{ #category : #'primitive failure' }
ScpObjectProxy >> primitiveFail [
	"See ProtoObject >> #primitiveFail"

	^ self primitiveFailed
]

{ #category : #'primitive failure' }
ScpObjectProxy >> primitiveFailed [
	"See ProtoObject >> #primitiveFailed"
	
	^ self primitiveFailed: thisContext sender selector
]

{ #category : #'primitive failure' }
ScpObjectProxy >> primitiveFailed: selector [
	"See ProtoObject >> #primitiveFailed:"

	PrimitiveFailed signalFor: selector
]

{ #category : #services }
ScpObjectProxy >> uninstrument [

	^ ScpInstrumentationRegistry instance
		  at: object
		  ifPresent: [ :i | i uninstall ]
]
