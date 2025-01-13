Class {
	#name : 'ScpMethodInstrumented',
	#superclass : 'ProtoObject',
	#instVars : [
		'method',
		'indirection'
	],
	#category : 'Scopeo-Instrumentation',
	#package : 'Scopeo-Instrumentation'
}

{ #category : 'reflective operations' }
ScpMethodInstrumented >> doesNotUnderstand: aMessage [

	| result |
	
	result := aMessage sendTo: method.
	(result == method) ifTrue: [ ^ self ].
	
	^ result
]

{ #category : 'accessing' }
ScpMethodInstrumented >> indirection: aMethodIndirection [

	indirection := aMethodIndirection
]

{ #category : 'initialization' }
ScpMethodInstrumented >> initialize [

	indirection := ScpMethodIndirection class >> #run:on:arguments: 
]

{ #category : 'accessing' }
ScpMethodInstrumented >> method: aMethod [

	method := aMethod
]

{ #category : 'evaluation' }
ScpMethodInstrumented >> run: aSelector with: aArguments in: aReceiver [

	^ self 
		withArgs: { method . aReceiver . aArguments } 
		executeMethod: indirection 
]

{ #category : 'accessing' }
ScpMethodInstrumented >> yourself [

	^ self
]
