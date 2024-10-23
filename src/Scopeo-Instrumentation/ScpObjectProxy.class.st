"
I intercept all messages received by a given object.

To do so, I have no parent class (my parent class is nil).

To maintain the hash consistency with the original object, I reimplement the following methods from ProtoObject:
- basicIdentityHash
- hash
- identityHash
- primitiveFail
- primitiveFailed
- primitiveFailed:

"
Class {
	#name : 'ScpObjectProxy',
	#superclass : 'Object',
	#instVars : [
		'instrumentation'
	],
	#category : 'Scopeo-Instrumentation',
	#package : 'Scopeo-Instrumentation'
}

{ #category : 'instance creation' }
ScpObjectProxy class >> newFor: anInstrumentation [

	| proxy |

	proxy := self new.

	MirrorPrimitives
		fixedFieldOf: proxy
		at: (self slotNamed: #instrumentation) index
		put: anInstrumentation.

	^ proxy
]

{ #category : 'reflective operations' }
ScpObjectProxy >> basicIdentityHash [
	"See ProtoObject >> #basicIdentityHash"

	<primitive: 75>
	self primitiveFailed
]

{ #category : 'reflective operations' }
ScpObjectProxy >> doesNotUnderstand: aMessage [

	<debuggerCompleteToSender>
	
	^ instrumentation handle: aMessage 
]

{ #category : 'comparing' }
ScpObjectProxy >> hash [

	^ self identityHash
]

{ #category : 'comparing' }
ScpObjectProxy >> identityHash [
	"See ProtoObject >> #identityHash"

	^ self basicIdentityHash bitShift: 8
]

{ #category : 'as yet unclassified' }
ScpObjectProxy >> instrument [

	^ self
]

{ #category : 'primitive failure' }
ScpObjectProxy >> primitiveFail [
	"See ProtoObject >> #primitiveFail"

	^ self primitiveFailed
]

{ #category : 'primitive failure' }
ScpObjectProxy >> primitiveFailed [
	"See ProtoObject >> #primitiveFailed"
	
	^ self primitiveFailed: thisContext sender selector
]

{ #category : 'primitive failure' }
ScpObjectProxy >> primitiveFailed: selector [
	"See ProtoObject >> #primitiveFailed:"

	PrimitiveFailed signalFor: selector
]
