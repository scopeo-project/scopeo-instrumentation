Class {
	#name : 'ScpMethodInstrumented',
	#superclass : 'ProtoObject',
	#instVars : [
		'ast',
		'method',
		'handler',
		'instrumentation'
	],
	#category : 'Scopeo-Method-Instrumentation-Core',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Core'
}

{ #category : 'accessing' }
ScpMethodInstrumented >> ast [

	^ ast
]

{ #category : 'accessing' }
ScpMethodInstrumented >> ast: anAst [

	ast := anAst
]

{ #category : 'class membership' }
ScpMethodInstrumented >> class [

	^ instrumentation method class
]

{ #category : 'accessing' }
ScpMethodInstrumented >> compiledMethod [

	 ^ self
]

{ #category : 'reflective operations' }
ScpMethodInstrumented >> doesNotUnderstand: aMessage [

	| result |
	
	thisContext sender crTrace.

	result := aMessage sendTo: instrumentation method.
	(result == instrumentation method) ifTrue: [ ^ self ].
	
	^ result
]

{ #category : 'accessing' }
ScpMethodInstrumented >> handler: aHandler [

	handler := aHandler
]

{ #category : 'accessing' }
ScpMethodInstrumented >> instrumentation [

	^ instrumentation
]

{ #category : 'accessing' }
ScpMethodInstrumented >> instrumentation: anInstrumentation [

	instrumentation := anInstrumentation
]

{ #category : 'testing' }
ScpMethodInstrumented >> isInstrumented [

	^ true
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
