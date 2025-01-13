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

	self class allInstancesDo: [ :i |
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
	instrumented := IdentitySet new.
	methodIndirection := ScpMethodIndirection class >> #run:on:arguments:.
]

{ #category : 'services' }
ScpMethodInstrumentation >> installOn: aMethod [

	| ast modifiedMethod |
	ast := modifier visitMethod: aMethod.

	modifiedMethod := ast doSemanticAnalysis generateMethod.

	ScpModifiedMethod adoptInstance: modifiedMethod.
	modifiedMethod ast: ast.
	modifiedMethod sourceCode: aMethod sourceCode.
	modifiedMethod instrumentation: self.

	instrumented add: modifiedMethod.

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

{ #category : 'services' }
ScpMethodInstrumentation >> uninstall [

	instrumented do: [ :m |
		m methodClass ifNotNil: [ :class |
			class
				addAndClassifySelector: m selector
				withMethod: m original
				inProtocol: m protocol
		]
	]
	
	

]
