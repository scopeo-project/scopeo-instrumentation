Class {
	#name : 'ScpAssignmentIndirection',
	#superclass : 'ScpIndirection',
	#instVars : [
		'oldValue',
		'newValue',
		'variable'
	],
	#category : 'Scopeo-Method-Instrumentation',
	#package : 'Scopeo-Method-Instrumentation'
}

{ #category : 'private - instrumenter' }
ScpAssignmentIndirection >> generateForNode: aNode [

	aNode variable isTempVariable 
		ifTrue: [ self reifyContext	]
		ifFalse: [ self reifyObject ].

	^ super generateForNode: aNode 
]

{ #category : 'accessing' }
ScpAssignmentIndirection >> newValue [

	^ newValue
]

{ #category : 'private - parameters' }
ScpAssignmentIndirection >> newValue: anObject [

	newValue := anObject
]

{ #category : 'accessing' }
ScpAssignmentIndirection >> object [

	^ object
]

{ #category : 'accessing' }
ScpAssignmentIndirection >> oldValue [

	^ oldValue
]

{ #category : 'private - parameters' }
ScpAssignmentIndirection >> oldValue: anObject [

	oldValue := anObject
]

{ #category : 'private - actions' }
ScpAssignmentIndirection >> performDefaultOperation [

	^ node variable isTempVariable 
		ifTrue: [	 variable write: newValue inContext: context ]
		ifFalse: [ variable write: newValue to: object ]
]

{ #category : 'private - instrumenter' }
ScpAssignmentIndirection >> registerInInstrumenter [

	instrumenter addAssignmentIndirection: self
]

{ #category : 'parameters' }
ScpAssignmentIndirection >> reifyDefaultOperationData [

	self reifyVariable.
	self reifyNewValue

]

{ #category : 'parameters' }
ScpAssignmentIndirection >> reifyNewValue [

	indirectionArguments add: (ScpIndirectionArgument new
		indirection: self;
		selector: #newValue:;
		argument: [ :astnode :inst | inst visitNode: astnode value ];
		yourself
	)
]

{ #category : 'parameters' }
ScpAssignmentIndirection >> reifyOldValue [
	
	indirectionArguments add: (ScpIndirectionArgument new
		indirection: self;
		selector: #oldValue:;
		argument: [ :astnode | astnode variable ];
		yourself
	).
	
]

{ #category : 'parameters' }
ScpAssignmentIndirection >> reifyVariable [

	indirectionArguments add: (ScpIndirectionArgument new
		indirection: self;
		selector: #variable:;
		argument: [ :astnode | RBLiteralValueNode value: astnode variable ];
		yourself
	).
	
]

{ #category : 'accessing' }
ScpAssignmentIndirection >> variable [

	^ variable
]

{ #category : 'private - parameters' }
ScpAssignmentIndirection >> variable: aVariable [

	variable := aVariable
]
