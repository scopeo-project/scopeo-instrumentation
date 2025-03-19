Class {
	#name : 'ScpDefaultReification',
	#superclass : 'ScpIndirectionReification',
	#category : 'Scopeo-Method-Instrumentation-Indirections',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Indirections'
}

{ #category : 'testing' }
ScpDefaultReification class >> isAbstract [

	^ self == ScpDefaultReification
]
