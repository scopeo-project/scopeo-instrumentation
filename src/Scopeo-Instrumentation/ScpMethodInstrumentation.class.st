Class {
	#name : 'ScpMethodInstrumentation',
	#superclass : 'ScpInstrumentation',
	#category : 'Scopeo-Instrumentation-Instrumentations',
	#package : 'Scopeo-Instrumentation',
	#tag : 'Instrumentations'
}

{ #category : 'private' }
ScpMethodInstrumentation >> registerIn: anInstrumentation [

	anInstrumentation registerMethodInstrumentation: self
]
