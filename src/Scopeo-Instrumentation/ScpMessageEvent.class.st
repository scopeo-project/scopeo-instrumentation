Class {
	#name : 'ScpMessageEvent',
	#superclass : 'ScpReturningEvent',
	#category : 'Scopeo-Instrumentation-GenericMethodModification',
	#package : 'Scopeo-Instrumentation',
	#tag : 'GenericMethodModification'
}

{ #category : 'instance creation' }
ScpMessageEvent class >> newFrom: aRFMessageOperation [

	^ self new
		object: aRFMessageOperation receiver;
		selector: aRFMessageOperation selector;
		arguments: aRFMessageOperation arguments;
		yourself
]

{ #category : 'testing' }
ScpMessageEvent >> isMessageToSelf [

	^ false
]

{ #category : 'testing' }
ScpMessageEvent >> isMessageToSuper [

	^ false
]
