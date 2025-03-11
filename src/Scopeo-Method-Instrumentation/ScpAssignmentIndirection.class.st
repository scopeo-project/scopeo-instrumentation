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

{ #category : 'accessing' }
ScpAssignmentIndirection >> newValue [

	^ newValue
]

{ #category : 'private - parameters' }
ScpAssignmentIndirection >> newValue: anObject [

	newValue := anObject
]

{ #category : 'accessing' }
ScpAssignmentIndirection >> oldValue [

	^ oldValue
]

{ #category : 'private - parameters' }
ScpAssignmentIndirection >> oldValue: anObject [

	oldValue := anObject
]

{ #category : 'private - instrumenter' }
ScpAssignmentIndirection >> registerInInstrumenter [

	instrumenter addAssignmentIndirection: self
]

{ #category : 'parameters' }
ScpAssignmentIndirection >> reifyDefaultOperation [

	indirectionArguments add: (ScpIndirectionArgument new
		indirection: self;
		selector: #operation:;
		argument: [ :astnode :inst | 
			RBBlockNode
				body: (RBSequenceNode statements: { 
					RBAssignmentNode
						variable: astnode variable
						value: (inst visitNode: astnode) 
				})
		];
		yourself
	)

	
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
