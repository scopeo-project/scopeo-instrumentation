Class {
	#name : 'ScpMethodCallIndirection',
	#superclass : 'ScpIndirection',
	#instVars : [
		'arguments'
	],
	#category : 'Scopeo-Method-Instrumentation',
	#package : 'Scopeo-Method-Instrumentation'
}

{ #category : 'testing' }
ScpMethodCallIndirection class >> isAbstract [

	^ self == ScpMethodCallIndirection
]

{ #category : 'accessing' }
ScpMethodCallIndirection >> arguments [

	^ arguments
]

{ #category : 'accessing' }
ScpMethodCallIndirection >> arguments: anObject [

	arguments := anObject
]

{ #category : 'as yet unclassified' }
ScpMethodCallIndirection >> reifyArguments [

	indirectionArguments add: (ScpIndirectionArgument new
		indirection: self;
		selector: #arguments:;
		argument: [ :astnode :inst | 
			RBArrayNode statements: (astnode arguments collect: [ :a | 
				inst visitNodes: a 
			]) 
		];
		yourself
	).
]

{ #category : 'as yet unclassified' }
ScpMethodCallIndirection >> reifyReceiver [

	self subclassResponsibility
]

{ #category : 'as yet unclassified' }
ScpMethodCallIndirection >> reifySender [

	self subclassResponsibility
]
