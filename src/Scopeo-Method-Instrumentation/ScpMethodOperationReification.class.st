Class {
	#name : 'ScpMethodOperationReification',
	#superclass : 'ScpOperationReification',
	#category : 'Scopeo-Method-Instrumentation-Indirections',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Indirections'
}

{ #category : 'as yet unclassified' }
ScpMethodOperationReification >> operationClass [

	^ ScpMethodOperation
]

{ #category : 'accessing' }
ScpMethodOperationReification >> reifications [

	^ { 
		ScpMethodOperation >> #method: -> ScpMethodReification new .
		ScpMethodOperation >> #receiver: -> ScpObjectReification new .
		ScpMethodOperation >> #arguments: -> ScpArgumentsReification new .
		ScpMethodOperation >> #default: -> ScpDefaultMethodReification new
	}
]
