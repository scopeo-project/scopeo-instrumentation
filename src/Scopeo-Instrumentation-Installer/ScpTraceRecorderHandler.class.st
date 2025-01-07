Class {
	#name : 'ScpTraceRecorderHandler',
	#superclass : 'AnObsoleteScpInstrumentationHandler',
	#category : 'Scopeo-Instrumentation-Installer-Model',
	#package : 'Scopeo-Instrumentation-Installer',
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
