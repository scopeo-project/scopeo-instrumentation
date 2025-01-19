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
ScpMethodInstrumentationTest >> methodWithAssignmentWithMessage [ 

	instVar := 42 asFloat
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
	self assert: variable name equals: #instVar.
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
	self assert: variable name equals: #observableInstVar.
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
	self assert: variable name equals: #instVar.
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
			condition: [ :n | n receiver isBlock not ];
			selector: #value:value:value:value:;
			arguments: #( sender selector receiver arguments );
			yourself
		);
		installOn: (self class >> #methodWithMessageInBlock).
	
	"Act"
	self methodWithMessageInBlock.
	
	"Assert"
	self assert: sender equals: self.
	self assert: receiver equals: 42.
	self assert: selector equals: #printString.
	self assert: arguments isEmpty
]

{ #category : 'tests' }
ScpMethodInstrumentationTest >> testMessageInBlockInBlock [

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
			condition: [ :n | n receiver isBlock not ];
			selector: #value:value:value:value:;
			arguments: #( sender selector receiver arguments );
			yourself
		);
		installOn: (self class >> #methodWithMessageInBlockInBlock).
	
	"Act"
	self methodWithMessageInBlockInBlock.
	
	"Assert"
	self assert: sender equals: self.
	self assert: receiver equals: 42.
	self assert: selector equals: #printString.
	self assert: arguments isEmpty
]

{ #category : 'tests' }
ScpMethodInstrumentationTest >> testMessageToBlock [

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
		installOn: (self class >> #methodWithMessageToBlock).
	
	"Act"
	self methodWithMessageToBlock.
	
	"Assert"
	self assert: sender equals: self.
	self assert: receiver isBlock.
	self assert: selector equals: #value.
	self assert: arguments isEmpty
]

{ #category : 'tests' }
ScpMethodInstrumentationTest >> testMessageWithArgument [

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
		installOn: (self class >> #methodWithMessageWithArgument).
		
	"Act"
	self methodWithMessageWithArgument.
	
	"Assert"
	self assert: sender equals: self.
	self assert: (receiver isKindOf: Collection).
	self assert: selector equals: #at:.
	self assert: arguments first equals: 4
]

{ #category : 'tests' }
ScpMethodInstrumentationTest >> testReturn [

	| operation |
	
	"Arrange"
	ScpMethodInstrumentation new
		addIndirection: (ScpMethodIndirection new
			handler: [ :op | operation := op ];
			selector: #value:;
			arguments: #( operation );
			yourself
		);
		installOn: (self class >> #methodWithReturn).
	
	
	"Act"
	self methodWithReturn.
	
	"Assert"
	self assert: operation value equals: 42
]

{ #category : 'tests' }
ScpMethodInstrumentationTest >> testReturnWithMessage [

	| instrumentation selector receiver arguments result |
	
	"Arrange"
	instrumentation := ScpMethodInstrumentation new.
	
	instrumentation addIndirection: (ScpMessageIndirection new
			handler: [ :op :sct :rcv :args | 
				selector := sct.
				receiver := rcv.
				arguments := args.
				op value
			];
			selector: #value:value:value:value:;
			arguments: #( operation selector receiver arguments );
			yourself
		).

	instrumentation addIndirection: (ScpMethodIndirection new
			handler: [ :op | 
				result	 := op value.
			];
			selector: #value:;
			arguments: #( operation );
			yourself
		).

	instrumentation installOn: (self class >> #methodWithReturnWithMessage).
		
	"Act"
	self methodWithReturnWithMessage.
	
	"Assert"
	self assert: receiver equals: 42.
	self assert: selector equals: #asFloat.
	self assert: arguments isEmpty.
	
	self assert: result equals: 42.0
]
