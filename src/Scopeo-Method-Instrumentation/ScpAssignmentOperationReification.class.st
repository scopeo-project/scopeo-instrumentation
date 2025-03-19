Class {
	#name : 'ScpAssignmentOperationReification',
	#superclass : 'ScpOperationReification',
	#category : 'Scopeo-Method-Instrumentation-Indirections',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Indirections'
}

{ #category : 'as yet unclassified' }
ScpAssignmentOperationReification >> operationClass [

	^ ScpAssignmentOperation
]

{ #category : 'accessing' }
ScpAssignmentOperationReification >> reifications [

	^ { 
		ScpAssignmentOperation >> #node: -> ScpNodeReification new .
		ScpAssignmentOperation >> #oldValue: -> ScpOldValueReification new .
		ScpAssignmentOperation >> #newValue: -> ScpNewValueReification new .
		ScpAssignmentOperation >> #default: -> ScpDefaultAssignmentReification new
	}
]
