Class {
	#name : 'ScpTraceRecorderSourceEvent',
	#superclass : 'Announcement',
	#instVars : [
		'source'
	],
	#category : 'Scopeo-Method-Instrumentation-Installer-Source-Recorder-UI',
	#package : 'Scopeo-Method-Instrumentation-Installer',
	#tag : 'Source-Recorder-UI'
}

{ #category : 'accessing' }
ScpTraceRecorderSourceEvent >> source [

	^ source
]

{ #category : 'accessing' }
ScpTraceRecorderSourceEvent >> source: anObject [

	source := anObject
]
