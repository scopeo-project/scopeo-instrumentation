Class {
	#name : 'ScpTraceSourceSelectionRegistry',
	#superclass : 'Object',
	#instVars : [
		'announcer',
		'selections'
	],
	#classInstVars : [
		'instance'
	],
	#category : 'Scopeo-Method-Instrumentation-Installer-Model',
	#package : 'Scopeo-Method-Instrumentation-Installer',
	#tag : 'Model'
}

{ #category : 'accessing' }
ScpTraceSourceSelectionRegistry class >> instance [

	^ instance ifNil: [ instance := self new ]
]

{ #category : 'event' }
ScpTraceSourceSelectionRegistry >> announceUpdate [

	self announcer announce: ScpTraceSourceSelectionRegistryEvent 
]

{ #category : 'accessing' }
ScpTraceSourceSelectionRegistry >> announcer [

	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : 'adding' }
ScpTraceSourceSelectionRegistry >> at: aName [

	^ selections at: aName ifAbsent: [ nil ]
]

{ #category : 'adding' }
ScpTraceSourceSelectionRegistry >> at: aName put: aSelection [

	selections at: aName ifPresent: [
		self error:
			'A trace source selection named ' , aName , ' already exists.' ].

	selections at: aName put: aSelection.
	self announceUpdate
]

{ #category : 'initialization' }
ScpTraceSourceSelectionRegistry >> initialize [

	selections := Dictionary new
]

{ #category : 'as yet unclassified' }
ScpTraceSourceSelectionRegistry >> method: aMethodSelector of: aClass [

	"
		This method retrieves a the original method that may have been rewritten by Scopeo.
		If the method has not been part of Scopeo instrumentation, we look for the method in the Pharo system.
	"
	self flag: #deprecated. "TODO: since this method is called each time a call is made in the execution, this is highly inefficient."
	
	^ (self selections collect: [ :s | s methodAt: aMethodSelector]) 
		detect: [ :m | m isNotNil and: [ m methodClass = aClass ] ] 
		ifNone: [ aClass lookupSelector: aMethodSelector ]
]

{ #category : 'adding' }
ScpTraceSourceSelectionRegistry >> remove: aName [

	selections removeKey: aName ifAbsent: [ ^ self ].
	self announceUpdate
]

{ #category : 'accessing' }
ScpTraceSourceSelectionRegistry >> selections [

	^ selections
]
