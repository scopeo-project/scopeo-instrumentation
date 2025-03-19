Class {
	#name : 'ScpMessageOperationReification',
	#superclass : 'ScpOperationReification',
	#category : 'Scopeo-Method-Instrumentation-Indirections',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Indirections'
}

{ #category : 'as yet unclassified' }
ScpMessageOperationReification >> operationClass [

	^ ScpMessageOperation
]

{ #category : 'accessing' }
ScpMessageOperationReification >> reifications [

	^ { 
		ScpMessageOperation >> #node: -> ScpNodeReification new .
		ScpMessageOperation >> #receiver: -> ScpMessageReceiverReification new .
		ScpMessageOperation >> #arguments: -> ScpArgumentsReification new .
		ScpMessageOperation >> #default: -> ScpDefaultMessageReification new
	}
]
