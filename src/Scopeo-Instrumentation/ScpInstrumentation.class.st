Class {
	#name : #ScpInstrumentation,
	#superclass : #Object,
	#instVars : [
		'handler',
		'methodsToInstrument',
		'visitor'
	],
	#classInstVars : [
		'instrumentedMethods'
	],
	#category : #'Scopeo-Instrumentation'
}

{ #category : #private }
ScpInstrumentation class >> uninstallAll [

	<script: 'self uninstallAll'>
	ScpInstrumentationRegistry instance instrumentations do: [ :i | 
		i uninstall 
	]

]

{ #category : #private }
ScpInstrumentation >> assignment: aBlockAssignment variable: aVariable of: anObject value: aValue [

	handler onAssignment: aVariable of: anObject value: aValue.
	^ aBlockAssignment value
]

{ #category : #parameters }
ScpInstrumentation >> handler: aHandler [

	handler := aHandler



	
]

{ #category : #initialization }
ScpInstrumentation >> initialize [

	visitor := ScpInstrumentationRBVisitor new
		indirectionIdentifier: self hash;
		yourself
]

{ #category : #services }
ScpInstrumentation >> install [

	self methodsToInstrument ifEmpty: [ ^ self ].
	
	self registry register: self.
	
	self methodsToInstrument do: [ :method |
		| ast |
		ast := method ast copy.

		Smalltalk logStdOutDuring: [:logger |
			logger nextPutAll: method name; cr 
		].

		ast := visitor visit: ast.
		method methodClass compile: ast formattedCode.

		[ self registry addMethod: method ] 
			on: Error 
			do: [ self uninstall ]
	]
]

{ #category : #private }
ScpInstrumentation >> message: aSelector from: aSender to: aReceiver with: anArguments [

	handler
		onMethodCall: aSelector
		from: aSender
		to: aReceiver
		with: anArguments.

	^ self methodReturn:
		  (aReceiver perform: aSelector withArguments: anArguments)
]

{ #category : #private }
ScpInstrumentation >> method: aSelector from: aSender to: aReceiver with: anArguments [

	handler
		onMethodCall: aSelector
		from: aSender
		to: aReceiver
		with: anArguments.
]

{ #category : #private }
ScpInstrumentation >> methodReturn: aValue [

	handler onMethodReturn: aValue.
	^ aValue
]

{ #category : #accessing }
ScpInstrumentation >> methodsToInstrument [

	^ methodsToInstrument
]

{ #category : #parameters }
ScpInstrumentation >> methodsToInstrument: aMethodCollection [

	(self registry instrumentedMethods includesAny: aMethodCollection) ifTrue: [ 
		self error: 'At least one of the methods provided has already been instrumented.' 
	].
	methodsToInstrument := aMethodCollection
]

{ #category : #private }
ScpInstrumentation >> registry [

	^ ScpInstrumentationRegistry instance
]

{ #category : #services }
ScpInstrumentation >> uninstall [
	
	self methodsToInstrument ifNotNil: [ :methods | 
		methods do: [ :m | 
			m methodClass addSelector: m selector withMethod: m.
			self registry removeMethod: m
		]
	].
	self registry unregister: self
]
