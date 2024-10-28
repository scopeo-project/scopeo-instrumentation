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
	#name : 'ScpProxy',
	#superclass : 'Object',
	#instVars : [
		'instrumentation'
	],
	#category : 'Scopeo-Instrumentation',
	#package : 'Scopeo-Instrumentation'
}

{ #category : 'instance creation' }
ScpProxy class >> newFor: anInstrumentation [

	| proxy |

	proxy := self new.

	MirrorPrimitives
		fixedFieldOf: proxy
		at: (self slotNamed: #instrumentation) index
		put: anInstrumentation.

	^ proxy
]

{ #category : 'reflective operations' }
ScpProxy >> basicIdentityHash [
	"See ProtoObject >> #basicIdentityHash"

	<primitive: 75>
	self primitiveFailed
]

{ #category : 'reflective operations' }
ScpProxy >> doesNotUnderstand: aMessage [

	<debuggerCompleteToSender>

	^ instrumentation handle: aMessage 
]

{ #category : 'comparing' }
ScpProxy >> hash [

	^ self identityHash
]

{ #category : 'comparing' }
ScpProxy >> identityHash [
	"See ProtoObject >> #identityHash"

	^ self basicIdentityHash bitShift: 8
]

{ #category : 'as yet unclassified' }
ScpProxy >> instrument [

	^ self
]

{ #category : 'primitive failure' }
ScpProxy >> primitiveFail [
	"See ProtoObject >> #primitiveFail"

	^ self primitiveFailed
]

{ #category : 'primitive failure' }
ScpProxy >> primitiveFailed [
	"See ProtoObject >> #primitiveFailed"
	
	^ self primitiveFailed: thisContext sender selector
]

{ #category : 'primitive failure' }
ScpProxy >> primitiveFailed: selector [
	"See ProtoObject >> #primitiveFailed:"

	PrimitiveFailed signalFor: selector
]
