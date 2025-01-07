Class {
	#name : 'ScpTraceRecorderHandler',
	#superclass : 'AnObsoleteScpInstrumentationHandler',
	#category : 'Scopeo-Method-Instrumentation-Installer-Model',
	#package : 'Scopeo-Method-Instrumentation-Installer',
	#tag : 'Model'
}

{ #category : 'testing' }
ScpTraceRecorderHandler class >> isAbstract [

	^ self == ScpTraceRecorderHandler
]

{ #category : 'accessing' }
ScpTraceRecorderHandler >> process [

	"Define here the behavior to execute to process the traces."
	self subclassResponsibility
]
