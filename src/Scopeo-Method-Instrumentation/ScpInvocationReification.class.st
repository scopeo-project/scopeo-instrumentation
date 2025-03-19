Class {
	#name : 'ScpInvocationReification',
	#superclass : 'ScpIndirectionReification',
	#category : 'Scopeo-Method-Instrumentation-Indirections',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Indirections'
}

{ #category : 'testing' }
ScpInvocationReification class >> isAbstract [

	^ self == ScpInvocationReification
]
