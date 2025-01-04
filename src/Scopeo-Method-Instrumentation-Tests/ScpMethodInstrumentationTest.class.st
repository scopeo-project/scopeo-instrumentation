Class {
	#name : 'ScpMethodInstrumentationTest',
	#superclass : 'TestCase',
	#instVars : [
		'instVar'
	],
	#category : 'Scopeo-Method-Instrumentation-Tests',
	#package : 'Scopeo-Method-Instrumentation-Tests'
}

{ #category : 'helpers' }
ScpMethodInstrumentationTest >> methodWithAssignment [

	instVar := 42
]

{ #category : 'helpers' }
ScpMethodInstrumentationTest >> methodWithCascadeMessage [

	Transcript
		show: 42;
		yourself
]

{ #category : 'helpers' }
ScpMethodInstrumentationTest >> methodWithMessage [

	42 printString
]

{ #category : 'helpers' }
ScpMethodInstrumentationTest >> methodWithMessageWithArgument [

	#( 1 2 3 4 ) at: 4
]

{ #category : 'helpers' }
ScpMethodInstrumentationTest >> methodWithReturn [

	^ 42
]

{ #category : 'running' }
ScpMethodInstrumentationTest >> tearDown [

	instVar := nil.

	(self class >> #methodWithCascadeMessage) instrumentation uninstall.
	(self class >> #methodWithAssignment) instrumentation uninstall.
	(self class >> #methodWithMessage) instrumentation uninstall.
	(self class >> #methodWithMessageWithArgument) instrumentation uninstall.
	(self class >> #methodWithReturn) instrumentation uninstall.
	
	super tearDown
]

{ #category : 'tests' }
ScpMethodInstrumentationTest >> testAfterHandler [

	| after |
	
	"Arrange"
	after := nil.
	
	(self class >> #methodWithAssignment) instrumentation
		 register: (ScpMethodInstrumentation new
				handler: (ScpAfterHandler new
					evaluate: [ :op | after := instVar ];
					yourself);
				yourself);
	 	 install.
	
	"Act"
	self methodWithAssignment.
	
	"Assert"
	self assert: after equals: 42.
	self assert: instVar equals: 42
]

{ #category : 'tests' }
ScpMethodInstrumentationTest >> testBeforeHandler [
	
	"Arrange"	
	| before |
	
	before := nil.
	
	(self class >> #methodWithAssignment) instrumentation
		 register: (ScpMethodInstrumentation new
				handler: (ScpBeforeHandler new
					evaluate: [ :op | before := instVar ];
					yourself);
				yourself);
	 	 install.
	
	"Act"
	self methodWithAssignment.
	
	"Assert"
	self assert: before isNil.
	self assert: instVar equals: 42
]

{ #category : 'tests' }
ScpMethodInstrumentationTest >> testCascadeMessage [

	| operations |
	
	"Arrange"
	operations := OrderedCollection new.
	
	(self class >> #methodWithCascadeMessage) instrumentation
		 register: (ScpMessageInstrumentation new
				handler: (ScpBeforeHandler new
					evaluate: [ :op | operations add: op ];
					yourself);
				yourself);
	 	 install.
	
	"Act"
	self methodWithCascadeMessage.
	
	"Assert"
	self assert: operations size equals: 2.
	
	self assert: operations first receiver equals: Transcript.
	self assert: operations first selector equals: #show:.
	self assert: operations first arguments first equals: 42.
	
	self assert: operations second receiver equals: Transcript.
	self assert: operations second selector equals: #yourself.
	self assert: operations second arguments isEmpty
]

{ #category : 'tests' }
ScpMethodInstrumentationTest >> testInsteadHandler [

	| operations |
	
	"Arrange"
	operations := OrderedCollection new.
	
	(self class >> #methodWithCascadeMessage) instrumentation
		 register: (ScpMessageInstrumentation new
				handler: (ScpBeforeHandler new
					evaluate: [ :op | operations add: op ];
					yourself);
				yourself);
	 	 install.
	
	"Act"
	self methodWithCascadeMessage.
	
	"Assert"
	self assert: operations size equals: 2.
	
	self assert: operations first receiver equals: Transcript.
	self assert: operations first selector equals: #show:.
	self assert: operations first arguments first equals: 42.
	
	self assert: operations second receiver equals: Transcript.
	self assert: operations second selector equals: #yourself.
	self assert: operations second arguments isEmpty
]

{ #category : 'tests' }
ScpMethodInstrumentationTest >> testMessage [

	| operation |
	
	"Arrange"
	operation := nil.
	
	(self class >> #methodWithMessage) instrumentation
		 register: (ScpMessageInstrumentation new
				handler: (ScpBeforeHandler new
					evaluate: [ :op | operation := op ];
					yourself);
				yourself);
	 	 install.
	
	"Act"
	self methodWithMessage.
	
	"Assert"
	self assert: operation receiver equals: 42.
	self assert: operation selector equals: #printString.
	self assert: operation arguments isEmpty
]

{ #category : 'tests' }
ScpMethodInstrumentationTest >> testMessageWithArgument [

	| operation |
	
	"Arrange"
	operation := nil.
	
	(self class >> #methodWithMessageWithArgument) instrumentation
		 register: (ScpMessageInstrumentation new
				handler: (ScpBeforeHandler new
					evaluate: [ :op | operation := op ];
					yourself);
				yourself);
	 	 install.
	
	"Act"
	self methodWithMessageWithArgument.
	
	"Assert"
	self assert: (operation receiver isKindOf: Collection).
	self assert: operation selector equals: #at:.
	self assert: operation arguments first equals: 4
]
