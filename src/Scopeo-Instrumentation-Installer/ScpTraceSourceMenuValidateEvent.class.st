Class {
	#name : 'ScpTraceSourceMenuValidateEvent',
	#superclass : 'Announcement',
	#instVars : [
		'selection'
	],
	#category : 'Scopeo-Instrumentation-Installer-Source-Menu-UI',
	#package : 'Scopeo-Instrumentation-Installer',
	#tag : 'Source-Menu-UI'
}

{ #category : 'accessing' }
ScpTraceSourceMenuValidateEvent >> selection [

	^ selection
]

{ #category : 'accessing' }
ScpTraceSourceMenuValidateEvent >> selection: anObject [

	selection := anObject
]
