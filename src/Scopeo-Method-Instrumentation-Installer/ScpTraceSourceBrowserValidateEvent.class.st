Class {
	#name : 'ScpTraceSourceBrowserValidateEvent',
	#superclass : 'Announcement',
	#instVars : [
		'selection'
	],
	#category : 'Scopeo-Method-Instrumentation-Installer-Source-Browser-UI',
	#package : 'Scopeo-Method-Instrumentation-Installer',
	#tag : 'Source-Browser-UI'
}

{ #category : 'accessing' }
ScpTraceSourceBrowserValidateEvent >> selection [

	^ selection
]

{ #category : 'accessing' }
ScpTraceSourceBrowserValidateEvent >> selection: aScpTraceSourceSelection [

	selection := aScpTraceSourceSelection
]
