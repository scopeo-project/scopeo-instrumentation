Class {
	#name : 'ScpMethodModification',
	#superclass : 'Object',
	#instVars : [
		'modifier',
		'method',
		'ast'
	],
	#category : 'Scopeo-Instrumentation-GenericMethodModification',
	#package : 'Scopeo-Instrumentation',
	#tag : 'GenericMethodModification'
}

{ #category : 'parameters' }
ScpMethodModification >> addIndirection: anIndirection [

	anIndirection registerInModifier: modifier
]

{ #category : 'accessing' }
ScpMethodModification >> ast [

	ast ifNil: [ self error: 'Modification not yet applied to a method' ].
	
	^ ast
]

{ #category : 'initialization' }
ScpMethodModification >> initialize [

	modifier := ScpMethodModifier new
]

{ #category : 'services' }
ScpMethodModification >> install [

	| modifiedMethod |

	ast := modifier visitMethod: method.

	modifiedMethod := method methodClass compiler compile: ast formattedCode.
	modifiedMethod := ScpModifiedMethod fromCompiledMethod: modifiedMethod.
	modifiedMethod modification: self.

	method methodClass
		addSelector: method selector
		withMethod: modifiedMethod
]

{ #category : 'accessing' }
ScpMethodModification >> method [

	^ method
]

{ #category : 'parameters' }
ScpMethodModification >> method: aMethod [

	method := aMethod
]

{ #category : 'services' }
ScpMethodModification >> uninstall [

	method methodClass removeSelectorSilently: method selector.
	method methodClass addSelector: method selector withMethod: method
]
