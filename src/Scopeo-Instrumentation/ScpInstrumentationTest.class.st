Class {
	#name : 'ScpInstrumentationTest',
	#superclass : 'TestCase',
	#instVars : [
		'instVar',
		'observableInstVar',
		'installer',
		'handler'
	],
	#category : 'Scopeo-Instrumentation-Tests',
	#package : 'Scopeo-Instrumentation',
	#tag : 'Tests'
}

{ #category : 'accessing' }
ScpInstrumentationTest >> events [

	^ installer handler events
]

{ #category : 'as yet unclassified' }
ScpInstrumentationTest >> pharoSyntaxExample: aNumber [

	"A method that illustrate every part of Smalltalk syntax"
	<menu>
	| y block |
	
	y := self hash + super hash.
	
	true & false not & (nil isNil) ifTrue: [ 
		block := [ instVar := aNumber].
		observableInstVar := block value.
	].

	instVar = y ifTrue: [ ^ instVar ].

	#($a #a 'a' 1  1.0) do: [ :each |
		Transcript
			show: (each class name);
			show: (each printString);
			show: ' '	
	]
]

{ #category : 'running' }
ScpInstrumentationTest >> setUp [

	installer := ScpInstrumentationInstaller new.
	installer instrument: (self class >> #pharoSyntaxExample:).
	installer handler: ScpInstrumentationHandlerTest new.
	installer enable
]

{ #category : 'running' }
ScpInstrumentationTest >> tearDown [

	installer uninstrument
]

{ #category : 'tests' }
ScpInstrumentationTest >> testMessageSent [

	| message return |

	self pharoSyntaxExample: 42.

	message := self events at: 12.
	return := self events at: 13.

	self assert: message isMessage.
	self assert: message node identicalTo: 169.
	self assert: message sender identicalTo: self.
	self assert: message selector identicalTo: #isNil.
	self assert: message receiver identicalTo: nil.
	self assert: message arguments isEmpty.
	
	self assert: return isReturn.
	self assert: return isMessageReturn.
	self assert: return node identicalTo: 169.
	self assert: return object identicalTo: true
]
