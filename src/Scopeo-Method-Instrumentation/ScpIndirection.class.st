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
	#category : 'Scopeo-Method-Instrumentation',
	#package : 'Scopeo-Method-Instrumentation'
}

{ #category : 'parameters' }
ScpIndirection >> arguments: aCollection [

	arguments := aCollection
]

{ #category : 'parameters' }
ScpIndirection >> condition: aConditionBlock [

	condition := aConditionBlock
]

{ #category : 'private - services' }
ScpIndirection >> generateFor: aNode usingModifier: aModifier [

	| node |

	node := RBMessageNode new.
	node receiver: handlerASTNode.
	node selector: selector.
	node arguments: (arguments collect: [ :argument |
		 self
			 generateFor: aNode
			 usingModifier: aModifier
			 argument: argument 
	]).

	node indirectionSourceNode: aNode.

	^ node
]

{ #category : 'private - services' }
ScpIndirection >> generateFor: aNode usingModifier: aModifier argument: anArgument [

	self subclassResponsibility
]

{ #category : 'parameters' }
ScpIndirection >> handler: anObject [

	handler := anObject.
	handlerASTNode := RBLiteralValueNode value: handler
]

{ #category : 'initialization' }
ScpIndirection >> initialize [

	arguments := OrderedCollection new
]

{ #category : 'private - services' }
ScpIndirection >> isApplicableFor: aNode [

	^ condition ifNil: [ true ] ifNotNil: [ :c | c value: aNode ]
]

{ #category : 'private - services' }
ScpIndirection >> register: anInstrumenter [

	self subclassResponsibility
]

{ #category : 'parameters' }
ScpIndirection >> selector: aSelector [

	selector := aSelector
]
