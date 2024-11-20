Class {
	#name : 'MySubClass',
	#superclass : 'MyClass',
	#instVars : [
		'instVar',
		'observableInstVar'
	],
	#category : 'Scopeo-Instrumentation-Tests',
	#package : 'Scopeo-Instrumentation',
	#tag : 'Tests'
}

{ #category : 'as yet unclassified' }
MySubClass class >> myClassMethod [

	^ super myClassMethod
]

{ #category : 'as yet unclassified' }
MySubClass >> myClassMethod [

	^ super myClassMethod
]

{ #category : 'as yet unclassified' }
MySubClass >> pharoSyntaxExample: aNumber [

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
