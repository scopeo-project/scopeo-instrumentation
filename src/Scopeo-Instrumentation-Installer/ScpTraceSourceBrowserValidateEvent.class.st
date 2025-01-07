Class {
	#name : 'ScpTraceSourceBrowserValidateEvent',
	#superclass : 'Announcement',
	#instVars : [
		'selection'
	],
	#category : 'Scopeo-Instrumentation-Installer-Source-Browser-UI',
	#package : 'Scopeo-Instrumentation-Installer',
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
