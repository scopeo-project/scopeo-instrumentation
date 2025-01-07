Class {
	#name : 'ScpTraceSourceBrowserItemsUpdateEvent',
	#superclass : 'Announcement',
	#instVars : [
		'items'
	],
	#category : 'Scopeo-Instrumentation-Installer-Source-Browser-UI',
	#package : 'Scopeo-Instrumentation-Installer',
	#tag : 'Source-Browser-UI'
}

{ #category : 'accessing' }
ScpTraceSourceBrowserItemsUpdateEvent >> items [

	^ items
]

{ #category : 'accessing' }
ScpTraceSourceBrowserItemsUpdateEvent >> items: aScpTraceSourceBrowserItems [

	items := aScpTraceSourceBrowserItems
]
