Class {
	#name : 'ScpMethodInstrumentation',
	#superclass : 'ScpInstrumentation',
	#category : 'Scopeo-Method-Instrumentation-Instrumentations',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Instrumentations'
}

{ #category : 'private' }
ScpMethodInstrumentation >> registerIn: anInstrumentation [

	anInstrumentation registerMethodInstrumentation: self
]
