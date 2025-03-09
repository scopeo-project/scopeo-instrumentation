Class {
	#name : 'ScpIndirection',
	#superclass : 'Object',
	#instVars : [
		'handler',
		'condition',
		'context',
		'instrumenter',
		'indirectionArguments',
		'node',
		'object',
		'handlerSelector',
		'method'
	],
	#category : 'Scopeo-Method-Instrumentation',
	#package : 'Scopeo-Method-Instrumentation'
}

{ #category : 'private - parameters' }
ScpIndirection >> condition: aConditionBlock [

	condition := aConditionBlock
]

{ #category : 'accessing' }
ScpIndirection >> context [

	^ context
]

{ #category : 'private - parameters' }
ScpIndirection >> context: anObject [

	context := anObject	 
]

{ #category : 'private - instrumenter' }
ScpIndirection >> generateForNode: anASTProgramNode [

	| newNode messages |

	messages := OrderedCollection new.
	messages addAll: (indirectionArguments collect: [ :a | 
		a generateForNode: anASTProgramNode 
	]).
	messages add: (RBMessageNode 
		receiver: (RBLiteralValueNode value: self)
		selector: #perform
	).
	
	newNode := RBCascadeNode messages: messages.
	
	newNode indirectionSourceNode: anASTProgramNode.
	newNode indirection: self.
	
	^ newNode
    
]

{ #category : 'parameters' }
ScpIndirection >> handler: anObject [

	handler := anObject
]

{ #category : 'parameters' }
ScpIndirection >> handlerSelector: aSelector [

	handlerSelector := aSelector
]

{ #category : 'initialization' }
ScpIndirection >> initialize [

	indirectionArguments := OrderedCollection new
]

{ #category : 'accessing' }
ScpIndirection >> instrumenter [

	^ instrumenter
]

{ #category : 'private - instrumenter' }
ScpIndirection >> instrumenter: anInstrumenter [

	instrumenter := anInstrumenter.
	self registerInInstrumenter
]

{ #category : 'private - instrumenter' }
ScpIndirection >> isApplicableFor: aNode [

	^ condition ifNil: [ true ] ifNotNil: [ :c | c value: aNode ]
]

{ #category : 'accessing' }
ScpIndirection >> node [

	^ node
]

{ #category : 'private - parameters' }
ScpIndirection >> node: anASTProgramNode [

	node := anASTProgramNode
]

{ #category : 'private - parameters' }
ScpIndirection >> object: anObject [

	object := anObject	 
]

{ #category : 'private - actions' }
ScpIndirection >> perform [

	^ handler perform: handlerSelector withArguments: { self } 
]

{ #category : 'private - actions' }
ScpIndirection >> performDefaultOperation [

	self subclassResponsibility
]

{ #category : 'private - instrumenter' }
ScpIndirection >> registerInInstrumenter [

	self subclassResponsibility
]

{ #category : 'parameters' }
ScpIndirection >> reifyContext [

	indirectionArguments addFirst: (ScpIndirectionArgument new 
		indirection: self;
		selector: #context:;
		argument: [ RBVariableNode thisContextNode ] ; 
		yourself
	)
]

{ #category : 'parameters' }
ScpIndirection >> reifyDefaultOperationData [

	self subclassResponsibility
]

{ #category : 'as yet unclassified' }
ScpIndirection >> reifyMethod [

	indirectionArguments add: (ScpIndirectionArgument new
		indirection: self;
		selector: #method:;
		argument: [ :astnode :inst | 
			RBLiteralValueNode value: (
				inst hasIndirectionForBody 
					ifTrue: [ inst instrument: astnode compiledMethod ]
					ifFalse: [ astnode compiledMethod ]
			)
		];
		yourself
	)
]

{ #category : 'parameters' }
ScpIndirection >> reifyNode [

	indirectionArguments add: (ScpIndirectionArgument new
		indirection: self;
		selector: #node:;
		argument: [ :astnode | RBLiteralValueNode value: astnode ];
		yourself		
	)
]

{ #category : 'parameters' }
ScpIndirection >> reifyObject [
	
	indirectionArguments add: (ScpIndirectionArgument new
		indirection: self;
		selector: #object:;
		argument: [ :astnode | RBVariableNode selfNode ];
		yourself
	).
	
]
