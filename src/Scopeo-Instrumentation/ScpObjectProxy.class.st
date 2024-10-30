Class {
	#name : #ScpObjectProxy,
	#superclass : #nil,
	#traits : 'ScpProxy',
	#classTraits : 'ScpProxy classTrait',
	#category : #'Scopeo-Instrumentation'
}

{ #category : #'reflective operations' }
ScpObjectProxy >> basicIdentityHash [
	"See ProtoObject >> #basicIdentityHash"

	<primitive: 75>
	self primitiveFailed
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

{ #category : #'as yet unclassified' }
ScpObjectProxy >> uninstrument [

	instrumentation disable.

	instrumentation object class superclass adoptInstance: instrumentation object.
	
	instrumentation object become: self
]
