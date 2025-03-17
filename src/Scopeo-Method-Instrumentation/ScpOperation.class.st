Class {
	#name : 'ScpOperation',
	#superclass : 'Object',
	#instVars : [
		'context',
		'method',
		'node',
		'object',
		'operation'
	],
	#category : 'Scopeo-Method-Instrumentation-Operations',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Operations'
}

{ #category : 'testing' }
ScpOperation class >> isAbstract [

	^ self == ScpOperation
]

{ #category : 'accessing' }
ScpOperation >> context [

	^ context
]

{ #category : 'private - parameters' }
ScpOperation >> context: anObject [

	context := anObject	 
]

{ #category : 'testing' }
ScpOperation >> isAssignment [

	^ false
]

{ #category : 'testing' }
ScpOperation >> isMessage [

	^ false
]

{ #category : 'testing' }
ScpOperation >> isMethod [

	^ false
]

{ #category : 'accessing' }
ScpOperation >> method [

	^ method
]

{ #category : 'private - parameters' }
ScpOperation >> method: aMethod [

	method := aMethod
]

{ #category : 'accessing' }
ScpOperation >> node [

	^ node
]

{ #category : 'private - parameters' }
ScpOperation >> node: anASTProgramNode [

	node := anASTProgramNode
]

{ #category : 'private - parameters' }
ScpOperation >> object [

	^ object
]

{ #category : 'private - parameters' }
ScpOperation >> object: anObject [

	object := anObject 
]

{ #category : 'private - parameters' }
ScpOperation >> operation [

	^ operation
]

{ #category : 'private - parameters' }
ScpOperation >> operation: anObject [

	operation := anObject
]

{ #category : 'actions' }
ScpOperation >> performDefaultOperation [

	<debuggerCompleteToSender>
	
	^ operation value
]

{ #category : 'printing' }
ScpOperation >> stringFor: aBlock withDefault: aString [

	| str  |
	
	str := [ aBlock value asString ] onErrorDo: [ ^ aString ].

	str := str copyFrom: 1 to: (str size min: 40).	
	str size = 40 ifTrue: [ 
		str := str , '...'	
	].

	^ str
	
	
	
]
