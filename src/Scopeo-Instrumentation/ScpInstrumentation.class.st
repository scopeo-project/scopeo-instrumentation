Class {
	#name : 'ScpInstrumentation',
	#superclass : 'Object',
	#instVars : [
		'handler',
		'methodsToInstrument',
		'visitor'
	],
	#classInstVars : [
		'instrumentedMethods'
	],
	#category : 'Scopeo-Instrumentation',
	#package : 'Scopeo-Instrumentation'
}

{ #category : 'private' }
ScpInstrumentation class >> uninstallAll [

	<script: 'self uninstallAll'>
	ScpInstrumentationRegistry instance instrumentations do: [ :i | 
		i uninstall 
	]

]

{ #category : 'parameters' }
ScpInstrumentation >> handler: aHandler [

	handler := aHandler



	
]

{ #category : 'initialization' }
ScpInstrumentation >> initialize [

	visitor := ScpInstrumentationMethodVisitor new
		indirectionIdentifier: self hash;
		yourself
]

{ #category : 'services' }
ScpInstrumentation >> install [

	| numberOfErrors numberOfMethods |
	numberOfErrors := 0.
	numberOfMethods := self methodsToInstrument size.

	numberOfMethods < 0 ifTrue: [ ^ self ].

	self registry register: self.

	self methodsToInstrument do: [ :method |
		| ast |
		ast := visitor visitMethod: method.

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

{ #category : 'private' }
ScpInstrumentation >> method: aSelector sender: aSender receiver: aReceiver arguments: anArguments [

	aSender class = self class ifTrue: [ ^ self ].

	handler
		method: aSelector
		sender: aSender
		receiver: aReceiver
		arguments: anArguments
]

{ #category : 'accessing' }
ScpInstrumentation >> methodsToInstrument [

	^ methodsToInstrument
]

{ #category : 'parameters' }
ScpInstrumentation >> methodsToInstrument: aMethodCollection [

	(self registry instrumentedMethods includesAny: aMethodCollection) ifTrue: [ 
		self error: 'At least one of the methods provided has already been instrumented.' 
	].
	methodsToInstrument := aMethodCollection
]

{ #category : 'private' }
ScpInstrumentation >> node: aNodeId assignment: aBlock variable: aVariable object: anObject value: aValue [

	handler
		node: aNodeId
		assignment: aVariable 
		object: anObject 
		value: aValue.
		
	^ aBlock value: aValue
]

{ #category : 'private' }
ScpInstrumentation >> node: aNodeId message: aSelector sender: aSender receiver: aReceiver arguments: anArguments [

	handler
		node: aNodeId
		message: aSelector
		sender: aSender
		receiver: aReceiver
		arguments: anArguments.

	^ self 
		node: aNodeId
		return: (aReceiver perform: aSelector withArguments: anArguments)
		sender: aSender
]

{ #category : 'private' }
ScpInstrumentation >> node: aNodeId return: aValue sender: aSender [

	aSender class = self class ifFalse: [
		handler node: aNodeId return: aValue
	].
	^ aValue
]

{ #category : 'private' }
ScpInstrumentation >> node: aNodeId super: aSelector sender: aSender arguments: anArguments class: aClass [

	handler node: aNodeId super: aSelector sender: aSender arguments: anArguments.

	^ self
		  node: aNodeId
		  return: (aSender
				   perform: aSelector
				   withArguments: anArguments
				   inSuperclass: aClass superclass)
		  sender: aSender
]

{ #category : 'private' }
ScpInstrumentation >> registry [

	^ ScpInstrumentationRegistry instance
]

{ #category : 'services' }
ScpInstrumentation >> uninstall [
	
	self methodsToInstrument ifNotNil: [ :methods | 
		methods do: [ :m | 
			m methodClass addSelector: m selector withMethod: m.
			self registry removeMethod: m
		]
	].
	self registry unregister: self
]
