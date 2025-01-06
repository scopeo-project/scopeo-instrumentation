Class {
	#name : 'ScpMethodInstrumented',
	#superclass : 'ProtoObject',
	#instVars : [
		'method',
		'handler'
	],
	#category : 'Scopeo-Method-Instrumentation-Core',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Core'
}

{ #category : 'reflective operations' }
ScpMethodInstrumented >> doesNotUnderstand: aMessage [

	| result |
	
	result := aMessage sendTo: method.
	(result == method) ifTrue: [ ^ self ].
	
	^ result
]

{ #category : 'accessing' }
ScpMethodInstrumented >> handler: aHandler [

	handler := aHandler
]

{ #category : 'accessing' }
ScpMethodInstrumented >> method: aMethod [

	method := aMethod
]

{ #category : 'evaluation' }
ScpMethodInstrumented >> run: aSelector with: aArguments in: aReceiver [

	^ handler handle: (ScpMethodOperation new
			   method: method;
			   receiver: aReceiver;
			   arguments: aArguments;
			   yourself)
]

{ #category : 'accessing' }
ScpMethodInstrumented >> yourself [

	^ self
]
