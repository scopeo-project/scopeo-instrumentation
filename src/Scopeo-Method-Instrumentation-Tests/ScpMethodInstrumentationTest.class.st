Class {
	#name : #ScpMethodInstrumentationTest,
	#superclass : #TestCase,
	#instVars : [
		'#instVar',
		'#observableInstVar => ObservableSlot'
	],
	#category : #'Scopeo-Method-Instrumentation-Tests'
}

{ #category : #initialization }
ScpMethodInstrumentationTest >> initialize [

	self class initializeSlots: self.
	super initialize.
]

{ #category : #helpers }
ScpMethodInstrumentationTest >> methodWithAssignment [

	instVar := 42
]

{ #category : #helpers }
ScpMethodInstrumentationTest >> methodWithAssignmentObservable [

	observableInstVar := 42
]

{ #category : #helpers }
ScpMethodInstrumentationTest >> methodWithAssignmentWithMessage [

	instVar := 42 asFloat
]

{ #category : #helpers }
ScpMethodInstrumentationTest >> methodWithCascadeMessage [

	Transcript
		show: 42;
		yourself
]

{ #category : #helpers }
ScpMethodInstrumentationTest >> methodWithMessage [

	42 printString
]

{ #category : #helpers }
ScpMethodInstrumentationTest >> methodWithMessageWithArgument [

	#( 1 2 3 4 ) at: 4
]

{ #category : #helpers }
ScpMethodInstrumentationTest >> methodWithReturn [

	^ 42
]

{ #category : #helpers }
ScpMethodInstrumentationTest >> methodWithReturnWithMessage [

	^ 42 asFloat
]

{ #category : #running }
ScpMethodInstrumentationTest >> tearDown [

	instVar := nil.
	observableInstVar := nil.

	(self class methods select: [ :s | s selector beginsWith: #method ]) 
		do: [ :m | m instrumentation uninstall ].

	super tearDown
]

{ #category : #tests }
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

{ #category : #tests }
ScpMethodInstrumentationTest >> testAssignment [

	| operation |
	
	"Arrange"
	operation := nil.
	
	(self class >> #methodWithAssignment) instrumentation
		 register: (ScpAssignmentInstrumentation new
				handler: (ScpBeforeHandler new
					evaluate: [ :op | operation := op ];
					yourself);
				yourself);
	 	 install.
	
	"Act"
	self methodWithAssignment.
	
	"Assert"
	self assert: operation isAssignment.
	self assert: operation object equals: self.
	self assert: operation variable equals: #instVar.
	self assert: operation oldValue equals: nil.
	self assert: operation newValue equals: 42
]

{ #category : #tests }
ScpMethodInstrumentationTest >> testAssignmentObservable [

	| operation |
	
	"Arrange"
	operation := nil.
	
	(self class >> #methodWithAssignmentObservable) instrumentation
		 register: (ScpAssignmentInstrumentation new
				handler: (ScpBeforeHandler new
					evaluate: [ :op | operation := op ];
					yourself);
				yourself);
	 	 install.
	
	"Act"
	self methodWithAssignmentObservable.
	
	"Assert"
	self assert: operation isAssignment.
	self assert: operation object equals: self.
	self assert: operation variable equals: #observableInstVar.
	self assert: operation oldValue equals: nil.
	self assert: operation newValue equals: 42
]

{ #category : #tests }
ScpMethodInstrumentationTest >> testAssignmentWithMessage [

	| assignment message |
	
	"Arrange"
	assignment := nil.
	message := nil.
	
	(self class >> #methodWithAssignmentWithMessage) instrumentation
		 register: (ScpAssignmentInstrumentation new
				handler: (ScpBeforeHandler new
					evaluate: [ :op | assignment := op ];
					yourself);
				yourself);
	 	 install.
	
	(self class >> #methodWithAssignmentWithMessage) instrumentation
		 register: (ScpMessageInstrumentation new
				handler: (ScpBeforeHandler new
					evaluate: [ :op | message := op ];
					yourself);
				yourself);
	 	 install.

	"Act"
	self methodWithAssignmentWithMessage.
	
	"Assert"
	self assert: assignment isAssignment.
	self assert: assignment object equals: self.
	self assert: assignment variable equals: #instVar.
	self assert: assignment oldValue equals: nil.
	self assert: assignment newValue equals: 42.0.
	
	self assert: message isMessage.
	self assert: message receiver equals: 42.
	self assert: message selector equals: #asFloat.
	self assert: message arguments isEmpty.
]

{ #category : #tests }
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

{ #category : #tests }
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

{ #category : #tests }
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

{ #category : #tests }
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

{ #category : #tests }
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

{ #category : #tests }
ScpMethodInstrumentationTest >> testReturn [

	| operation |
	
	"Arrange"
	operation := nil.
	
	(self class >> #methodWithReturn) instrumentation
		 register: (ScpMethodInstrumentation new
				handler: (ScpAfterHandler new
					evaluate: [ :op | operation := op ];
					yourself);
				yourself);
	 	 install.
	
	"Act"
	self methodWithReturn.
	
	"Assert"
	self assert: operation result equals: 42
]

{ #category : #tests }
ScpMethodInstrumentationTest >> testReturnWithMessage [

	| return message |
	
	"Arrange"
	return := nil.
	message := nil.
	
	(self class >> #methodWithReturnWithMessage) instrumentation
		 register: (ScpMethodInstrumentation new
				handler: (ScpAfterHandler new
					evaluate: [ :op | return := op ];
					yourself);
				yourself);
	 	 install.

	(self class >> #methodWithReturnWithMessage) instrumentation
		 register: (ScpMessageInstrumentation new
				handler: (ScpAfterHandler new
					evaluate: [ :op | message := op ];
					yourself);
				yourself);
	 	 install.
	
	"Act"
	self methodWithReturnWithMessage.
	
	"Assert"
	self assert: message isMessage.
	self assert: message receiver equals: 42.
	self assert: message selector equals: #asFloat.
	self assert: message arguments isEmpty.
	
	self assert: return isMethod.
	self assert: return result equals: 42.0
]
