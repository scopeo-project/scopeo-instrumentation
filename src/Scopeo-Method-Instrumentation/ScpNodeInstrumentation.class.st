Class {
	#name : 'ScpNodeInstrumentation',
	#superclass : 'ScpInstrumentation',
	#instVars : [
		'condition',
		'handlerASTNode'
	],
	#category : 'Scopeo-Method-Instrumentation-Instrumentations',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Instrumentations'
}

{ #category : 'testing' }
ScpNodeInstrumentation class >> isAbstract [

	^ self == ScpNodeInstrumentation
]

{ #category : 'comparing' }
ScpNodeInstrumentation >> = anInstrumentation [

	^ super = anInstrumentation and: [ anInstrumentation condition = condition ]
]

{ #category : 'private' }
ScpNodeInstrumentation >> condition [

	^ condition
]

{ #category : 'parameters' }
ScpNodeInstrumentation >> condition: aConditionBlock [

	condition := aConditionBlock
]

{ #category : 'private' }
ScpNodeInstrumentation >> generateFor: aNode usingModifier: aModifier [

	self subclassResponsibility
]

{ #category : 'parameters' }
ScpNodeInstrumentation >> handler: aHandler [

	super handler: aHandler.
	handlerASTNode := RBMessageNode
		receiver: (RBVariableNode named: #ScpHandlerRegistry)
		selector: #get:
		arguments: { (RBLiteralValueNode value: handler hash) }
]

{ #category : 'private' }
ScpNodeInstrumentation >> isApplicableFor: aNode [

	^ condition ifNil: [ true ] ifNotNil: [ :c | c value: aNode ]
]
