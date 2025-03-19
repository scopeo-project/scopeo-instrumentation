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
ScpAssignmentIndirection >> registerInInstrumenter [

	instrumenter addAssignmentIndirection: self
]

{ #category : 'parameters' }
ScpAssignmentIndirection >> reifyDefault [
	
	reifications add: (ScpDefaultAssignmentReification new
       indirection: self;
       yourself)

	
]

{ #category : 'parameters' }
ScpAssignmentIndirection >> reifyNewValue [

	reifications add: (ScpNewValueReification new
       indirection: self;
       yourself)
]

{ #category : 'parameters' }
ScpAssignmentIndirection >> reifyOldValue [
	
	reifications add: (ScpOldValueReification new
       indirection: self;
       yourself)
	
]

{ #category : 'parameters' }
ScpAssignmentIndirection >> reifyOperation [ 

	reifications add: (ScpAssignmentOperationReification new
       indirection: self;
       yourself)
]
