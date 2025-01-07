Class {
	#name : 'ScpTraceSourceMenuValidateEvent',
	#superclass : 'Announcement',
	#instVars : [
		'selection'
	],
	#category : 'Scopeo-Method-Instrumentation-Installer-Source-Menu-UI',
	#package : 'Scopeo-Method-Instrumentation-Installer',
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
