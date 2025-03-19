Class {
	#name : 'ScpOperationReification',
	#superclass : 'ScpIndirectionReification',
	#category : 'Scopeo-Method-Instrumentation-Indirections',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Indirections'
}

{ #category : 'testing' }
ScpOperationReification class >> isAbstract [

	^ self == ScpOperationReification
]

{ #category : 'private - reification' }
ScpOperationReification >> generateForNode: anASTProgramNode [

	| receiver |
	
	receiver := RBMessageNode
		receiver: (RBVariableNode named: self operationClass name) 
		selector: #new.
				
	^ RBCascadeNode messages: (self reifications collect: [ :method :reification | 
		reification indirection: self indirection.
		RBMessageNode 
			receiver: receiver 
			selector: method selector
			arguments: { reification generateForNode: anASTProgramNode } 
	])
]

{ #category : 'private - reification' }
ScpOperationReification >> operationClass [

	self subclassResponsibility
]

{ #category : 'private - reification' }
ScpOperationReification >> reifications [

	self subclassResponsibility
]
