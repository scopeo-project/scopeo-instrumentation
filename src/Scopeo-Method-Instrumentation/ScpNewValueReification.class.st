Class {
	#name : 'ScpNewValueReification',
	#superclass : 'ScpAssignmentReification',
	#category : 'Scopeo-Method-Instrumentation-Indirections',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Indirections'
}

{ #category : 'private - reification' }
ScpNewValueReification >> generateForNode: anASTProgramNode [

	^ self instrumenter visitNode: anASTProgramNode value
]
