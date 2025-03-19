Class {
	#name : 'ScpOldValueReification',
	#superclass : 'ScpAssignmentReification',
	#category : 'Scopeo-Method-Instrumentation-Indirections',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Indirections'
}

{ #category : 'private - reification' }
ScpOldValueReification >> generateForNode: anASTProgramNode [

	^ anASTProgramNode variable
]
