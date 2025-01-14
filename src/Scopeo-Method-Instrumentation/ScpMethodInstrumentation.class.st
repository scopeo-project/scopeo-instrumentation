Class {
	#name : 'ScpMethodInstrumentation',
	#superclass : 'Object',
	#instVars : [
		'modifier',
		'methodIndirection',
		'instrumented'
	],
	#category : 'Scopeo-Method-Instrumentation',
	#package : 'Scopeo-Method-Instrumentation'
}

{ #category : 'cleanup' }
ScpMethodInstrumentation class >> uninstallAll [

	self allInstancesDo: [ :i |
		i uninstall	
	]
]

{ #category : 'parameters' }
ScpMethodInstrumentation >> addIndirection: anIndirection [

	anIndirection register: self
]

{ #category : 'initialization' }
ScpMethodInstrumentation >> initialize [

	modifier := ScpMethodModifier new.
	instrumented := WeakValueDictionary new.
	methodIndirection := ScpMethodIndirection class >> #run:on:arguments:.
]

{ #category : 'services' }
ScpMethodInstrumentation >> installOn: aMethod [

	| ast modifiedMethod |
	ast := modifier visitMethod: aMethod.
	modifiedMethod := ast generateMethod.

	ScpModifiedMethod adoptInstance: modifiedMethod.
	modifiedMethod ast: ast.
	modifiedMethod sourceCode: aMethod sourceCode.
	modifiedMethod instrumentation: self.
	modifiedMethod original: aMethod.

	instrumented at: aMethod name put: modifiedMethod.

	aMethod methodClass ifNotNil: [ :class |
		class
			addAndClassifySelector: aMethod selector
			withMethod: (ScpMethodInstrumented new
					 indirection: methodIndirection;
					 method: modifiedMethod;
					 yourself)
			inProtocol: aMethod protocol ].

	^ modifiedMethod
]

{ #category : 'private' }
ScpMethodInstrumentation >> registerAssignmentIndirection: anIndirection [

	modifier addAssignmentIndirection: anIndirection
]

{ #category : 'private' }
ScpMethodInstrumentation >> registerMessageIndirection: anIndirection [

	modifier addMessageIndirection: anIndirection
]

{ #category : 'private' }
ScpMethodInstrumentation >> registerMethodIndirection: anIndirection [

	methodIndirection := anIndirection generate
]

{ #category : 'as yet unclassified' }
ScpMethodInstrumentation >> reinstall [

	instrumented valuesDo: [ :m | 
		self installOn: m original 
	]
]

{ #category : 'services' }
ScpMethodInstrumentation >> uninstall [

	instrumented valuesDo: [ :m |
		m methodClass ifNotNil: [ :class |
			class
				addAndClassifySelector: m selector
				withMethod: m original
				inProtocol: m protocol
		]
	]
	
	

]
