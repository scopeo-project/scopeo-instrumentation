Class {
	#name : 'ScpInstrumentation',
	#superclass : 'Object',
	#instVars : [
		'handler',
		'methodsToInstrument',
		'visitor',
		'enabled'
	],
	#category : 'Scopeo-Instrumentation',
	#package : 'Scopeo-Instrumentation'
}

{ #category : 'private' }
ScpInstrumentation class >> uninstall [

	<script: 'self uninstall'>
	self allInstancesDo: [ :i | 
		i uninstall
	]

]

{ #category : 'services' }
ScpInstrumentation >> disable [

	self isEnabled ifFalse: [ ^ self ].
	
	self useDefaultHandler
]

{ #category : 'services' }
ScpInstrumentation >> enable [

	self isEnabled ifTrue: [ ^ self ].
	
	Smalltalk globals at: #'_SCOPEO' put: handler.
]

{ #category : 'services' }
ScpInstrumentation >> handler [

	^ handler
]

{ #category : 'parameters' }
ScpInstrumentation >> handler: aHandler [

	handler := aHandler



	
]

{ #category : 'initialization' }
ScpInstrumentation >> initialize [

	visitor := ScpInstrumentationMethodVisitor new
]

{ #category : 'services' }
ScpInstrumentation >> install [

	| errors |

	self isInstalled ifTrue: [ self error: 'Instrumentation already installed' ].
	handler ifNil: [ self error: 'No instrumentation handler provided' ].

	self methodsToInstrument ifEmpty: [ ^ self ].

	"Waiting for the user to provide a handler and enable the usage of the instrumentation with it."
	self useDefaultHandler.

	errors := OrderedCollection new.
	self methodsToInstrument do: [ :method |
		| ast |
		ast := visitor visitMethod: method.
		[ method methodClass compile: ast formattedCode ]
			on: Error
			do: [ :e | errors add: e. ].
	].

	self logSummary: errors
]

{ #category : 'services' }
ScpInstrumentation >> isEnabled [
	
	self isInstalled ifFalse: [ ^ false ].
	
	^ (Smalltalk globals at: #'_SCOPEO') class ~~ ScpInstrumentationHandler
]

{ #category : 'services' }
ScpInstrumentation >> isInstalled [

	^ Smalltalk globals includesKey: #'_SCOPEO'
]

{ #category : 'private' }
ScpInstrumentation >> logSummary: aErrors [

	| numberOfMethods |

	numberOfMethods := self methodsToInstrument size.
	
	self inform:
		'Scopeo: instrumented '
		, (numberOfMethods - aErrors size) asString , '/'
		, numberOfMethods asString , ' methods.' .
	
	Smalltalk logStdOutDuring: [ :logger |
		aErrors do: [ :e | 
			logger	 nextPutAll: e; cr 
		]
	]
]

{ #category : 'services' }
ScpInstrumentation >> methodsToInstrument [

	^ methodsToInstrument
]

{ #category : 'parameters' }
ScpInstrumentation >> methodsToInstrument: aMethodCollection [

	methodsToInstrument := aMethodCollection
]

{ #category : 'services' }
ScpInstrumentation >> uninstall [
	
	self disable.
	self methodsToInstrument ifNotNil: [ :methods | 
		methods do: [ :m | 
			m methodClass addSelector: m selector withMethod: m.
		]
	].
	Smalltalk globals removeKey: #'_SCOPEO' ifAbsent: [ "Do nothing" ].
]

{ #category : 'private' }
ScpInstrumentation >> useDefaultHandler [

	Smalltalk globals at: #'_SCOPEO' put: ScpInstrumentationHandler new.
]
