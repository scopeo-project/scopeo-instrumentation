Class {
	#name : 'ScpMethodEvent',
	#superclass : 'ScpReturningEvent',
	#category : 'Scopeo-Instrumentation-GenericMethodModification',
	#package : 'Scopeo-Instrumentation',
	#tag : 'GenericMethodModification'
}

{ #category : 'instance creation' }
ScpMethodEvent class >> newFrom: aRFMethodOperation [

	^ self new
		object: aRFMethodOperation receiver;
		selector: aRFMethodOperation selector;
		arguments: aRFMethodOperation arguments;
		yourself
]

{ #category : 'testing' }
ScpMethodEvent >> isMethod [

	^ true
]
