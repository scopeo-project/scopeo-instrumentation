Class {
	#name : 'ScpNodeIndirection',
	#superclass : 'ScpIndirection',
	#category : 'Scopeo-Method-Instrumentation',
	#package : 'Scopeo-Method-Instrumentation'
}

{ #category : 'parameters' }
ScpNodeIndirection >> condition: aConditionBlock [

	condition := aConditionBlock
]

{ #category : 'private - services' }
ScpNodeIndirection >> generateFor: aNode usingModifier: aModifier [

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
ScpNodeIndirection >> generateFor: aNode usingModifier: aModifier argument: anArgument [

	self subclassResponsibility
]

{ #category : 'private - services' }
ScpNodeIndirection >> isApplicableFor: aNode [

	^ condition ifNil: [ true ] ifNotNil: [ :c | c value: aNode ]
]

{ #category : 'private - services' }
ScpNodeIndirection >> register: anInstrumentation [

	self subclassResponsibility
]
