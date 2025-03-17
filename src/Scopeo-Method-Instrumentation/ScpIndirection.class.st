Class {
	#name : 'ScpIndirection',
	#superclass : 'Object',
	#instVars : [
		'instrumenter',
		'indirectionArguments',
		'handler',
		'handlerSelector',
		'condition'
	],
	#category : 'Scopeo-Method-Instrumentation-Indirections',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Indirections'
}

{ #category : 'private - parameters' }
ScpIndirection >> condition: aConditionBlock [

	condition := aConditionBlock
]

{ #category : 'private - instrumenter' }
ScpIndirection >> generateForNode: anASTProgramNode [

	| newNode messages |

	messages := OrderedCollection new.
	messages addAll: (indirectionArguments collect: [ :a | 
		(a generateForNode: anASTProgramNode)
			indirectionSourceNode: anASTProgramNode;
			indirection:	 self;
			yourself	
	]).
	
	newNode := RBMessageNode 
		receiver: (RBLiteralValueNode value: self)
		selector: #handle:
		arguments: { RBCascadeNode messages: messages }.
  
	newNode indirectionSourceNode: anASTProgramNode.
	newNode indirection: self.
	
	^ newNode
]

{ #category : 'private - instrumenter' }
ScpIndirection >> generateOperationForNode: anASTProgramNode [

	self subclassResponsibility
]

{ #category : 'private - actions' }
ScpIndirection >> handle: anScpOperation [

	<debuggerCompleteToSender>

	^ handler perform: handlerSelector withArguments: { anScpOperation } 
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

{ #category : 'testing' }
ScpIndirection >> isPartOfInstrumentation [

	^ true
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
ScpIndirection >> reifyDefaultOperation [

	self subclassResponsibility
]

{ #category : 'parameters' }
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
