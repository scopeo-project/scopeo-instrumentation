Class {
	#name : 'ScpInstrumentationInstaller',
	#superclass : 'ASTProgramNodeVisitor',
	#instVars : [
		'handler',
		'enabled',
		'linkBeforeAssignment',
		'linkInsteadMethod',
		'linkInsteadMessage',
		'linkInsteadMessageToSuper',
		'linkInsteadMessageToSelf'
	],
	#category : 'Scopeo-Instrumentation-GenericMethodModification',
	#package : 'Scopeo-Instrumentation',
	#tag : 'GenericMethodModification'
}

{ #category : 'services' }
ScpInstrumentationInstaller >> disable [

	enabled := false 
]

{ #category : 'services' }
ScpInstrumentationInstaller >> enable [

	enabled := true
]

{ #category : 'accessing' }
ScpInstrumentationInstaller >> handler [

	^ handler
]

{ #category : 'parameters' }
ScpInstrumentationInstaller >> handler: aHandler [

	handler := aHandler
]

{ #category : 'initialization' }
ScpInstrumentationInstaller >> initialize [

	self disable
]

{ #category : 'services' }
ScpInstrumentationInstaller >> instrument: aMethod [

	aMethod ast acceptVisitor: self
]

{ #category : 'services' }
ScpInstrumentationInstaller >> instrument: aMethod install: aClass [ 

	(aClass includesSelector: aMethod selector) ifFalse: [ 
		aClass addSelector: aMethod selector withMethod: (
			aClass compiler compile: aMethod sourceCode
		)	
	].
	self instrument: aClass >> aMethod selector.
]

{ #category : 'services' }
ScpInstrumentationInstaller >> isEnabled [

	^ enabled 
]

{ #category : 'private' }
ScpInstrumentationInstaller >> linkBeforeAssignment [

	^ linkBeforeAssignment ifNil: [ 
		linkBeforeAssignment := MetaLink new.
		linkBeforeAssignment metaObject: [ :operation |
			self isEnabled 
				ifTrue: [
					self disable.
					handler onAssignmentEvent: (
						ScpAssignmentEvent newFrom: operation
					).
					self enable.
				]
		].
		linkBeforeAssignment control: #before.
		linkBeforeAssignment selector: #value:.
		linkBeforeAssignment arguments: #( operation ).
	]
]

{ #category : 'private' }
ScpInstrumentationInstaller >> linkInsteadMessage [

	^ linkInsteadMessage ifNil: [ 
		linkInsteadMessage := MetaLink new.
		linkInsteadMessage metaObject: [ :operation | 
			| event |
			self isEnabled 
				ifTrue: [
					self disable.
					event := ScpMessageEvent newFrom: operation.
					handler onMessageEvent: event.
					event return: operation value.
					self enable
				]
				ifFalse: [ operation value ]
		].
		linkInsteadMessage control: #instead.
		linkInsteadMessage selector: #value:.
		linkInsteadMessage arguments: #( operation ).
	]
]

{ #category : 'private' }
ScpInstrumentationInstaller >> linkInsteadMessageToSelf [

	^ linkInsteadMessageToSelf ifNil: [ 
		linkInsteadMessageToSelf := MetaLink new.
		linkInsteadMessageToSelf metaObject: [ :operation | 
			| event |
			self isEnabled 
				ifTrue: [
					self disable.
					event := ScpMessageToSelfEvent newFrom: operation.
					handler onMessageEvent: event.
					event return: operation value.
					self enable
				]
				ifFalse: [ operation value ]
		].
		linkInsteadMessageToSelf control: #instead.
		linkInsteadMessageToSelf selector: #value:.
		linkInsteadMessageToSelf arguments: #( operation ).
	]
]

{ #category : 'private' }
ScpInstrumentationInstaller >> linkInsteadMessageToSuper [

	^ linkInsteadMessageToSuper ifNil: [ 
		linkInsteadMessageToSuper := MetaLink new.
		linkInsteadMessageToSuper metaObject: [ :operation | 
			| event |
			self isEnabled 
				ifTrue: [
					self disable.
					event := ScpMessageToSuperEvent newFrom: operation.
					handler onMessageEvent: event.
					event return: operation value.
					self enable
				]
				ifFalse: [ operation value ]
		].
		linkInsteadMessageToSuper control: #instead.
		linkInsteadMessageToSuper selector: #value:.
		linkInsteadMessageToSuper arguments: #( operation ).
	]
]

{ #category : 'private' }
ScpInstrumentationInstaller >> linkInsteadMethod [

	^ linkInsteadMethod ifNil: [ 
		linkInsteadMethod := MetaLink new.
		linkInsteadMethod metaObject: [ :operation |
			| event |
			self isEnabled 
				ifTrue: [
					self disable.
					event := ScpMethodEvent newFrom: operation.
					handler onMethodEvent: event.
					event return: operation value.
					self enable
				]
				ifFalse: [ operation value ]
		].
		linkInsteadMethod control: #instead.
		linkInsteadMethod selector: #value:.
		linkInsteadMethod arguments: #( operation ).
	]
]

{ #category : 'services' }
ScpInstrumentationInstaller >> uninstrument [

	self disable.
	self linkInsteadMethod uninstrument.
	self linkInsteadMessage uninstrument.
	self linkBeforeAssignment uninstrument
]

{ #category : 'visiting' }
ScpInstrumentationInstaller >> visitAssignmentNode: anAssignmentNode [
	
	anAssignmentNode link: self linkBeforeAssignment.
	
	super visitAssignmentNode: anAssignmentNode
]

{ #category : 'visiting' }
ScpInstrumentationInstaller >> visitMessageNode: aMessageNode [
	
	aMessageNode isSuperSend 
		ifTrue: [ aMessageNode link: self linkInsteadMessageToSuper ]
		ifFalse: [ 
			aMessageNode isSelfSend 
				ifTrue: [ aMessageNode link: self linkInsteadMessageToSelf ]
				ifFalse: [ aMessageNode link: self linkInsteadMessage ]			
		].	
	
	super visitMessageNode: aMessageNode
]

{ #category : 'visiting' }
ScpInstrumentationInstaller >> visitMethodNode: aMethodNode [
	
	aMethodNode link: self linkInsteadMethod.
	
	super visitMethodNode: aMethodNode
]
