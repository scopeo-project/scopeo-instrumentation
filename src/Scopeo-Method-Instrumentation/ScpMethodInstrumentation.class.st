Class {
	#name : 'ScpMethodInstrumentation',
	#superclass : 'Object',
	#instVars : [
		'methodIndirection',
		'instrumented',
		'instrumenter'
	],
	#category : 'Scopeo-Method-Instrumentation-Instrumentation',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Instrumentation'
}

{ #category : 'cleanup' }
ScpMethodInstrumentation class >> uninstallAll [

	self allInstancesDo: [ :i |
		i uninstall	
	]
]

{ #category : 'parameters' }
ScpMethodInstrumentation >> addIndirection: anIndirection [

	"Ask the indirection to register itself in the instrumenter"

	instrumenter ifNil: [ 
		self error: 'Instrumenter not initialized.' 
	].

	anIndirection indirection: instrumenter
]

{ #category : 'services' }
ScpMethodInstrumentation >> applyOn: aMethod [
	
	"Apply instrumentation on the method and return a new compiled method with the behavioral changes."

	^ instrumenter instrument: aMethod
]

{ #category : 'initialization' }
ScpMethodInstrumentation >> initialize [

	instrumenter := ScpMethodInstrumenter new
		instrumentation: self;
		yourself.
		
	instrumented := WeakValueDictionary new
]

{ #category : 'services' }
ScpMethodInstrumentation >> installOn: aMethod [

	"Apply the instrumentation on a given method and install that instrumentation on the method class."

	| instrumentedMethod |

	instrumentedMethod := self applyOn: aMethod.

	instrumented at: aMethod name put: instrumentedMethod.

	aMethod methodClass ifNotNil: [ :class |
		class
			addAndClassifySelector: aMethod selector
			withMethod: instrumentedMethod
			inProtocol: aMethod protocol 
	].

	^ instrumentedMethod
]

{ #category : 'services' }
ScpMethodInstrumentation >> reinstall [

	instrumented valuesDo: [ :m | 
		self installOn: m original 
	]
]

{ #category : 'services' }
ScpMethodInstrumentation >> uninstall [

	instrumented valuesDo: [ :m |
		m methodClass ifNotNil: [ :class |
			class removeSelectorSilently: m selector.
			class
				addAndClassifySelector: m selector
				withMethod: m original
				inProtocol: m protocol
		]
	]
	
	

]
