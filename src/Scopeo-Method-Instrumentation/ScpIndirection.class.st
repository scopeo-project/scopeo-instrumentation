Class {
	#name : 'ScpIndirection',
	#superclass : 'Object',
	#instVars : [
		'instrumenter',
		'handler',
		'handlerSelector',
		'condition',
		'beOptimized',
		'reifications'
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

	| handlerSelectorKeywords |

	handlerSelectorKeywords := (handlerSelector splitOn: $:) select: [ :w | w isNotEmpty ].
	handlerSelectorKeywords size = reifications size ifFalse: [ 
		self error: 'The handler selector does match the required reifications.'
	].

	^ RBMessageNode new
		receiver: (RBLiteralValueNode value: handler);
		selector: handlerSelector;
		arguments: (reifications collect: [ :r | 
			r generateForNode: anASTProgramNode
		]);
		indirectionSourceNode: anASTProgramNode;
		indirection: self;
		yourself
]

{ #category : 'parameters' }
ScpIndirection >> handler: anObject [

	handler := anObject
]

{ #category : 'parameters' }
ScpIndirection >> handlerSelector: aSelector [

	handlerSelector := aSelector
]

{ #category : 'private - instrumenter' }
ScpIndirection >> indirection: anInstrumenter [

	instrumenter := anInstrumenter.
	self registerInInstrumenter
]

{ #category : 'initialization' }
ScpIndirection >> initialize [

	beOptimized := false.
	reifications := OrderedCollection new.
	
]

{ #category : 'accessing' }
ScpIndirection >> instrumenter [

	^ instrumenter
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

	reifications add: (ScpContextReification new
       indirection: self;
       yourself)
]

{ #category : 'parameters' }
ScpIndirection >> reifyDefault [

	self subclassResponsibility
]

{ #category : 'parameters' }
ScpIndirection >> reifyMethod [

	reifications add: (ScpMethodIndirection new
       indirection: self;
       yourself)
]

{ #category : 'parameters' }
ScpIndirection >> reifyNode [

	reifications add: (ScpNodeReification new
       indirection: self;
       yourself)
]

{ #category : 'parameters' }
ScpIndirection >> reifyObject [
	
	reifications add: (ScpObjectReification new
       indirection: self;
       yourself)
	
]

{ #category : 'parameters' }
ScpIndirection >> reifyOperation [

	self subclassResponsibility
]
