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

	handler := ScpHandlerRegistry register: anObject.
	handlerASTNode := RBMessageNode
		receiver: (RBVariableNode named: #ScpHandlerRegistry)
		selector: #get:
		arguments: { (RBLiteralValueNode value: handler hash) }
]

{ #category : 'private - services' }
ScpIndirection >> isApplicableFor: aNode [

	^ condition ifNil: [ true ] ifNotNil: [ :c | c value: aNode ]
]

{ #category : 'private - services' }
ScpIndirection >> registerInModifier: aMethodModifier [

	self subclassResponsibility
]

{ #category : 'parameters' }
ScpIndirection >> selector: aSelector [

	selector := aSelector
]
