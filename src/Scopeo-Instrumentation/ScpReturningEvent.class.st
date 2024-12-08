Class {
	#name : 'ScpReturningEvent',
	#superclass : 'ScpObjectEvent',
	#instVars : [
		'return'
	],
	#category : 'Scopeo-Instrumentation-GenericMethodModification',
	#package : 'Scopeo-Instrumentation',
	#tag : 'GenericMethodModification'
}

{ #category : 'testing' }
ScpReturningEvent >> hasReturned [

	^ return isNotEmpty
]

{ #category : 'initialization' }
ScpReturningEvent >> initialize [

	return := ScpReturnEmpty new
]

{ #category : 'accessing' }
ScpReturningEvent >> return [

	^ return
]

{ #category : 'accessing' }
ScpReturningEvent >> return: anObject [

	return := ScpReturnObject new 
		object: anObject; 
		yourself
]
