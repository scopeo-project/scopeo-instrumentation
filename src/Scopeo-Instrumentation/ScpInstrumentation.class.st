Class {
	#name : 'ScpInstrumentation',
	#superclass : 'Object',
	#instVars : [
		'modifier',
		'methodIndirection',
		'instrumented'
	],
	#category : 'Scopeo-Instrumentation-ScopeoMethodInstrumentation',
	#package : 'Scopeo-Instrumentation',
	#tag : 'ScopeoMethodInstrumentation'
}

{ #category : 'parameters' }
ScpInstrumentation >> addIndirection: anIndirection [

	anIndirection registerInModifier: modifier
]

{ #category : 'initialization' }
ScpInstrumentation >> initialize [

	modifier := ScpMethodModifier new.
	instrumented := IdentitySet new
]

{ #category : 'services' }
ScpInstrumentation >> installOn: aMethod [
	
	| ast modifiedMethod |
	
	ast := modifier visitMethod: aMethod.
	
	modifiedMethod := aMethod 
		methodClass compiler 
		compile: ast source.
	
	ScpModifiedMethod adoptInstance: modifiedMethod.
	modifiedMethod ast: ast.
	modifiedMethod sourceCode: aMethod sourceCode.
	modifiedMethod instrumentation: self.
	
	instrumented add: modifiedMethod.
	
	aMethod methodClass ifNotNil: [ :class | 
		class addAndClassifySelector: aMethod selector
			withMethod: (ScpMethodInstrumented new
				indirection: methodIndirection;
				method: modifiedMethod;
 				yourself)
			inProtocol: aMethod protocol.
	].
	
	^ modifiedMethod
		
]

{ #category : 'private' }
ScpInstrumentation >> registerAssignmentIndirection: anIndirection [

	modifier addAssignmentIndirection: anIndirection
]

{ #category : 'private' }
ScpInstrumentation >> registerMessageIndirection: anIndirection [

	modifier addMessageIndirection: anIndirection
]

{ #category : 'private' }
ScpInstrumentation >> registerMethodIndirection: anIndirection [

	methodIndirection := anIndirection
]

{ #category : 'services' }
ScpInstrumentation >> uninstall [

	instrumented do: [ :m |
		m methodClass ifNotNil: [ :class |
			class
				addAndClassifySelector: m selector
				withMethod: m original
				inProtocol: m protocol
		]
	]
	
	

]
