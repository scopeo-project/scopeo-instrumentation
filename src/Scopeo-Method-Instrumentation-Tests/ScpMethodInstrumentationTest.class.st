Class {
	#name : 'ScpMethodInstrumentationTest',
	#superclass : 'TestCase',
	#instVars : [
		'instVar',
		'observableInstVar'
	],
	#category : 'Scopeo-Method-Instrumentation-Tests',
	#package : 'Scopeo-Method-Instrumentation-Tests'
}

{ #category : 'initialization' }
ScpMethodInstrumentationTest >> initialize [

	self class initializeSlots: self.
	super initialize.
]

{ #category : 'helpers' }
ScpMethodInstrumentationTest >> methodWithAssignment [

	instVar := 42
]

{ #category : 'helpers' }
ScpMethodInstrumentationTest >> methodWithAssignmentObservable [

	observableInstVar := 42
]

{ #category : 'helpers' }
ScpMethodInstrumentationTest >> methodWithMessageInBlock [

	[ :v | v printString ] value: 42
]

{ #category : 'helpers' }
ScpMethodInstrumentationTest >> methodWithMessageInBlockInBlock [

	 [ [ :v | v printString ] value: 42 ] value 
]

{ #category : 'helpers' }
ScpMethodInstrumentationTest >> methodWithMessageToBlock [

	[ ] value
]

{ #category : 'helpers' }
ScpMethodInstrumentationTest >> methodWithMessageWithArgument [

	#( 1 2 3 4 ) at: 4
]

{ #category : 'helpers' }
ScpMethodInstrumentationTest >> methodWithReturn [

	^ 42
]

{ #category : 'helpers' }
ScpMethodInstrumentationTest >> methodWithReturnWithMessage [

	^ 42 asFloat
]

{ #category : 'running' }
ScpMethodInstrumentationTest >> tearDown [

	instVar := nil.
	observableInstVar := nil.

	(self class methods select: [ :m | 
		(m selector beginsWith: #method) and: [ m isInstrumented ] 
	]) 
	do: [ :m | 
		m instrumentation uninstall 
	].

	super tearDown
]

{ #category : 'tests' }
ScpMethodInstrumentationTest >> testAssignment [

	| object variable oldValue newValue |
	
	"Arrange"
	ScpMethodInstrumentation new
		addIndirection: (ScpAssignmentIndirection new
			handler: [ :obj :var :old :new | 
				object	 := obj.
				variable := var.
				oldValue := old.
				newValue := new
			];
			selector: #value:value:value:value:;
			arguments: #( object variable oldValue newValue );
			yourself
		);
		installOn: (self class >> #methodWithAssignment).
			
	"Act"
	self methodWithAssignment.
	
	"Assert"
	self assert: object equals: self.
	self assert: variable equals: #instVar.
	self assert: oldValue equals: nil.
	self assert: newValue equals: 42.
	self assert: instVar equals: nil.
]

{ #category : 'tests' }
ScpMethodInstrumentationTest >> testAssignmentObservable [

	| object variable oldValue newValue |
	
	"Arrange"
	ScpMethodInstrumentation new
		addIndirection: (ScpAssignmentIndirection new
			handler: [ :obj :var :old :new | 
				object	 := obj.
				variable := var.
				oldValue := old.
				newValue := new
			];
			selector: #value:value:value:value:;
			arguments: #( object variable oldValue newValue );
			yourself
		);
		installOn: (self class >> #methodWithAssignmentObservable).
		
	"Act"
	self methodWithAssignmentObservable.
	
	"Assert"
	self assert: object equals: self.
	self assert: variable equals: #observableInstVar.
	self assert: oldValue equals: nil.
	self assert: newValue equals: 42
]

{ #category : 'tests' }
ScpMethodInstrumentationTest >> testAssignmentWithMessage [

	| instrumentation object variable oldValue newValue sender selector receiver arguments |
	
	"Arrange"
	instrumentation := ScpMethodInstrumentation new.
	
	instrumentation addIndirection: (ScpAssignmentIndirection new
			handler: [ :obj :var :old :new | 
				object	 := obj.
				variable := var.
				oldValue := old.
				newValue := new
			];
			selector: #value:value:value:value:;
			arguments: #( object variable oldValue newValue );
			yourself
		).
	
	instrumentation addIndirection: (ScpMessageIndirection new
			handler: [ :snd :sct :rcv :args | 
				sender	 := snd.
				selector := sct.
				receiver := rcv.
				arguments := args.
				84
			];
			selector: #value:value:value:value:;
			arguments: #( sender selector receiver arguments );
			yourself
		).
			
	instrumentation installOn: (self class >> #methodWithAssignmentWithMessage).

	"Act"
	self methodWithAssignmentWithMessage.
	
	"Assert"
	self assert: object equals: self.
	self assert: variable equals: #instVar.
	self assert: oldValue equals: nil.
	self assert: newValue equals: 84.
	
	self assert: sender equals: self.
	self assert: receiver equals: 42.
	self assert: selector equals: #asFloat.
	self assert: arguments isEmpty.
]

{ #category : 'tests' }
ScpMethodInstrumentationTest >> testCascadeMessage [

	| operations |
	
	"Arrange"
	
	operations := OrderedCollection new.
	
	ScpMethodInstrumentation new
		addIndirection: (ScpMessageIndirection new
			handler: [ :snd :sct :rcv :args | 				
				operations add: { 
					#sender -> snd.  
					#selector -> sct.  
					#receiver -> rcv.  
					#arguments -> args 
				} asDictionary
			];
			selector: #value:value:value:value:;
			arguments: #( sender selector receiver arguments );
			yourself
		);
		installOn: (self class >> #methodWithCascadeMessage).
	
	"Act"
	self methodWithCascadeMessage.
	
	"Assert"
	self assert: operations size equals: 2.
	
	self assert: (operations first at: #sender) equals: self.
	self assert: (operations first at: #receiver) equals: Transcript.
	self assert: (operations first at: #selector) equals: #show:.
	self assert: (operations first at: #arguments) first equals: 42.
	
	self assert: (operations second at: #sender) equals: self.
	self assert: (operations second at: #receiver) equals: Transcript.
	self assert: (operations second at: #selector) equals: #yourself.
	self assert: (operations second at: #arguments) isEmpty
]

{ #category : 'tests' }
ScpMethodInstrumentationTest >> testMessage [
	
	| sender selector receiver arguments |
	
	"Arrange"
	ScpMethodInstrumentation new
		addIndirection: (ScpMessageIndirection new
			handler: [ :snd :sct :rcv :args | 
				sender	 := snd.
				selector := sct.
				receiver := rcv.
				arguments := args.
			];
			selector: #value:value:value:value:;
			arguments: #( sender selector receiver arguments );
			yourself
		);
		installOn: (self class >> #methodWithMessage).
	
	"Act"
	self methodWithMessage.
	
	"Assert"
	self assert: sender equals: self.
	self assert: receiver equals: 42.
	self assert: selector equals: #printString.
	self assert: arguments isEmpty
]

{ #category : 'tests' }
ScpMethodInstrumentationTest >> testMessageInBlock [

	| operation |
	
	"Arrange"
	operation := nil.
	
	(self class >> #methodWithMessageInBlock) instrumentation
		 register: (ScpMessageInstrumentation new
				handler: (ScpBeforeHandler new
					evaluate: [ :op | operation := op ];
					yourself);
				condition: [ :n | n receiver isBlock not ]
				yourself);
	 	 install.
	
	"Act"
	self methodWithMessageInBlock.
	
	"Assert"
	self assert: operation receiver equals: 42.
	self assert: operation selector equals: #printString.
	self assert: operation arguments isEmpty
]

{ #category : 'tests' }
ScpMethodInstrumentationTest >> testMessageInBlockInBlock [

	| operation |
	
	"Arrange"
	operation := nil.
	
	(self class >> #methodWithMessageInBlockInBlock) instrumentation
		 register: (ScpMessageInstrumentation new
				handler: (ScpBeforeHandler new
					evaluate: [ :op | operation := op ];
					yourself);
				condition: [ :n | n receiver isBlock not ]
				yourself);
	 	 install.
	
	"Act"
	self methodWithMessageInBlockInBlock.
	
	"Assert"
	self assert: operation receiver equals: 42.
	self assert: operation selector equals: #printString.
	self assert: operation arguments isEmpty
]

{ #category : 'tests' }
ScpMethodInstrumentationTest >> testMessageToBlock [

	| operation |
	
	"Arrange"
	operation := nil.
	
	(self class >> #methodWithMessageToBlock) instrumentation
		 register: (ScpMessageInstrumentation new
				handler: (ScpBeforeHandler new
					evaluate: [ :op | operation := op ];
					yourself);
				yourself);
	 	 install.
	
	"Act"
	self methodWithMessageToBlock.
	
	"Assert"
	self assert: operation receiver isBlock.
	self assert: operation selector equals: #value.
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

{ #category : 'tests' }
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

{ #category : 'tests' }
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
