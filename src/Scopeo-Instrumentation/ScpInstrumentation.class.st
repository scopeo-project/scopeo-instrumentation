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

{ #category : 'protocol' }
ScpInstrumentation >> disable [

	Smalltalk globals at: #'_SCOPEO' put: ScpInstrumentationHandler new.
]

{ #category : 'protocol' }
ScpInstrumentation >> enable [

	Smalltalk globals at: #'_SCOPEO' put: handler.
]

{ #category : 'accessing' }
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

	self disable. "Let the user decide whenever enabling the instrumentation"

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

{ #category : 'testing' }
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

{ #category : 'accessing' }
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
