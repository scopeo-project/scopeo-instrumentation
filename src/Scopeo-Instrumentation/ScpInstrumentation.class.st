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
ScpInstrumentation >> assignment: aBlock variable: aVariable object: anObject value: aValue [

	handler onAssignment: aVariable of: anObject value: aValue.
	^ aBlock value: aValue
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

	| numberOfErrors numberOfMethods |
	numberOfErrors := 0.
	numberOfMethods := self methodsToInstrument size.

	numberOfMethods < 0 ifTrue: [ ^ self ].

	self registry register: self.

	self methodsToInstrument do: [ :method |
		| ast |
		ast := method ast copy.
		ast := visitor visit: ast.

		[ method methodClass compile: ast formattedCode ]
			on: Error
			do: [ :e |
				numberOfErrors := numberOfErrors + 1.
				Smalltalk logStdOutDuring: [ :logger |
					logger
						nextPutAll: e;
						cr ] ].

		[ self registry addMethod: method ]
			on: Error
			do: [ self uninstall ] ].

	self inform:
		'Scopeo: instrumenting '
		, (numberOfMethods - numberOfErrors) asString , '/'
		, numberOfMethods asString , ' methods.'
]

{ #category : #private }
ScpInstrumentation >> message: aSelector from: aSender to: aReceiver with: anArguments [

	handler
		onMethodCall: aSelector
		from: aSender
		to: aReceiver
		with: anArguments.

	^ self
		  methodReturn: (aReceiver perform: aSelector withArguments: anArguments)
		  to: aSender
]

{ #category : #private }
ScpInstrumentation >> method: aSelector from: aSender to: aReceiver with: anArguments [

	aSender class = self class ifTrue: [ ^ self ].

	handler
		onMethodCall: aSelector
		from: aSender
		to: aReceiver
		with: anArguments
]

{ #category : #private }
ScpInstrumentation >> methodReturn: aValue to: aSender [

	aSender class = self class ifFalse: [
			handler onMethodReturn: aValue
		
		].
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

{ #category : #private }
ScpInstrumentation >> superMessage: aSelector from: aSender with: anArguments in: aClass [

	handler onSuperCall: aSelector from: aSender with: anArguments.

	^ self
		  methodReturn: (aSender
				   perform: aSelector
				   withArguments: anArguments
				   inSuperclass: aClass superclass)
		  to: aSender
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
