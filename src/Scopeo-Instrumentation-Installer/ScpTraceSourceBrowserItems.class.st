Class {
	#name : 'ScpTraceSourceBrowserItems',
	#superclass : 'Object',
	#instVars : [
		'filter',
		'selection'
	],
	#category : 'Scopeo-Instrumentation-Installer-Source-Browser-UI',
	#package : 'Scopeo-Instrumentation-Installer',
	#tag : 'Source-Browser-UI'
}

{ #category : 'accessing' }
ScpTraceSourceBrowserItems >> classes [

	^ self
		  filter: (selection packages flatCollect: [ :p | p classes ]) asSet asOrderedCollection
		  including: filter classes
]

{ #category : 'parameters' }
ScpTraceSourceBrowserItems >> filter: aScpTraceSourceBrowserFilter [

	filter := aScpTraceSourceBrowserFilter
]

{ #category : 'private' }
ScpTraceSourceBrowserItems >> filter: aCollection including: aString [

	^ aCollection select: [ :e |
		  aString isEmptyOrNil or: [
			  e name asString
				  includesSubstring: aString
				  caseSensitive: false ] ]
]

{ #category : 'accessing' }
ScpTraceSourceBrowserItems >> methods [

	^ self
		  filter:
			  ((selection packages flatCollect: [ :p | p methods ]) select: [
				   :m | selection classes includes: m methodClass ])
		  including: filter methods
]

{ #category : 'accessing' }
ScpTraceSourceBrowserItems >> packages [

	^ self filter: Smalltalk packages asOrderedCollection including: filter packages
]

{ #category : 'parameters' }
ScpTraceSourceBrowserItems >> selection: aScpTraceSourceBrowserSelection [

	selection := aScpTraceSourceBrowserSelection
]
