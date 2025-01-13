Class {
	#name : 'ScpIndirection',
	#superclass : 'Object',
	#instVars : [
		'handler',
		'selector',
		'arguments',
		'condition',
		'handlerASTNode'
	],
	#category : 'Scopeo-Instrumentation-GenericMethodModification',
	#package : 'Scopeo-Instrumentation',
	#tag : 'GenericMethodModification'
}

{ #category : 'parameters' }
ScpIndirection >> arguments: aCollection [

	arguments := aCollection
]

{ #category : 'parameters' }
ScpIndirection >> condition: aConditionBlock [

	condition := aConditionBlock
]

{ #category : 'parameters' }
ScpIndirection >> handler: anObject [

	handler := anObject.
	handlerASTNode := RBLiteralValueNode value: handler
]

{ #category : 'parameters' }
ScpIndirection >> selector: aSelector [

	selector := aSelector
]
