Class {
	#name : 'ScpReturnTrace',
	#superclass : 'ScpTrace',
	#instVars : [
		'object'
	],
	#category : 'Scopeo-Method-Instrumentation-Installer-Trace-Model',
	#package : 'Scopeo-Method-Instrumentation-Installer',
	#tag : 'Trace-Model'
}

{ #category : 'testing' }
ScpReturnTrace class >> isAbstract [

	^ self == ScpReturnTrace
]

{ #category : 'as yet unclassified' }
ScpReturnTrace >> isMessageReturn [

	^ false
]

{ #category : 'as yet unclassified' }
ScpReturnTrace >> isMethodReturn [

	^ false
]

{ #category : 'as yet unclassified' }
ScpReturnTrace >> isReturn [

	^ true
]

{ #category : 'as yet unclassified' }
ScpReturnTrace >> object [
	
	^ object
]

{ #category : 'as yet unclassified' }
ScpReturnTrace >> object: anObject [

	object := anObject 
]

{ #category : 'as yet unclassified' }
ScpReturnTrace >> size [

	^ 2
]
