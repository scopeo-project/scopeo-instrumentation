Class {
	#name : 'ScpAssignmentIndirection',
	#superclass : 'ScpIndirection',
	#instVars : [
		'oldValue',
		'newValue'
	],
	#category : 'Scopeo-Method-Instrumentation-Indirections',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Indirections'
}

{ #category : 'private - instrumenter' }
ScpAssignmentIndirection >> generateOperationForNode: anASTProgramNode [

	^ RBMessageNode
		receiver: (RBVariableNode named: ScpAssignmentOperation name) 
		selector: #new 
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
						value: (inst visitNode: astnode value) 
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
