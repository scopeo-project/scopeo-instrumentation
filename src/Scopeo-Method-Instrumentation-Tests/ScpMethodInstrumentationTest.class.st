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
ScpMethodInstrumentationTest >> methodWithMessageReceiver [

	42 printString crTrace
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
			reifyObject; reifyNode; reifyOldValue; reifyNewValue;
			handler: [ :ind | 
				object	 := ind object.
				variable := ind node variable.
				oldValue := ind oldValue.
				newValue := ind newValue
			];
			handlerSelector: #value:;
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
			reifyObject; reifyNode; reifyOldValue; reifyNewValue;
			handler: [ :ind | 
				object	 := ind object.
				variable := ind node variable.
				oldValue := ind oldValue.
				newValue := ind newValue
			];
			handlerSelector: #value:;
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
			reifyObject; reifyNode; reifyOldValue; reifyNewValue;
			handler: [ :ind | 
				object	 := ind object.
				variable := ind node variable.
				oldValue := ind oldValue.
				newValue := ind newValue
			];
			handlerSelector: #value:;
			yourself
		).
	
	instrumentation addIndirection: (ScpMessageIndirection new
			reifySender; reifyNode; reifyReceiver; reifyArguments;
			handler: [ :ind | 
				sender	 := ind sender.
				selector := ind node selector.
				receiver := ind receiver.
				arguments := ind arguments.
				84
			];
			handlerSelector: #value:;
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
			reifySender; reifyNode; reifyReceiver; reifyArguments;
			handler: [ :ind | 				
				operations add: { 
					#sender -> ind sender.  
					#selector -> ind node selector.  
					#receiver -> ind receiver.  
					#arguments -> ind arguments
				} asDictionary
			];
			handlerSelector: #value:;
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
			reifySender; reifyNode; reifyReceiver; reifyArguments;
			handler: [ :inst | 
				sender	 := inst sender.
				selector := inst node selector.
				receiver := inst receiver.
				arguments := inst arguments.
			];
			handlerSelector: #value:;
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
			reifySender; reifyNode; reifyReceiver; reifyArguments;
			handler: [ :inst | 
				sender	 := inst sender.
				selector := inst node selector.
				receiver := inst receiver.
				arguments := inst arguments.
			];
			handlerSelector: #value:;
			condition: [ :n | n receiver isBlock not ];
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
			reifySender; reifyNode; reifyReceiver; reifyArguments;
			handler: [ :inst | 
				sender	 := inst sender.
				selector := inst node selector.
				receiver := inst receiver.
				arguments := inst arguments.
			];
			handlerSelector: #value:;
			condition: [ :n | n receiver isBlock not ];
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
ScpMethodInstrumentationTest >> testMessageReceiver [ 
	
	| selectors |
	
	"Arrange"
	selectors := OrderedCollection new.
	
	ScpMethodInstrumentation new
		addIndirection: (ScpMessageIndirection new
			reifyDefaultOperation; reifyNode;
			handler: [ :inst | 
				selectors add: inst node selector.
				inst performDefaultOperation
			];
			handlerSelector: #value:;
			yourself
		);
		installOn: (self class >> #methodWithMessageReceiver).
	
	"Act"
	self methodWithMessageReceiver.
	
	"Assert"
	self assert: selectors size equals: 2.
	self assert: selectors first equals: #crTrace.
	self assert: selectors second equals: #printString
]

{ #category : 'tests' }
ScpMethodInstrumentationTest >> testMessageToBlock [

	| sender selector receiver arguments |
	
	"Arrange"
	ScpMethodInstrumentation new
		addIndirection: (ScpMessageIndirection new
			reifySender; reifyNode; reifyReceiver; reifyArguments;
			handler: [ :inst | 
				sender	 := inst sender.
				selector := inst node selector.
				receiver := inst receiver.
				arguments := inst arguments.
			];
			handlerSelector: #value:;
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
			reifySender; reifyNode; reifyReceiver; reifyArguments;
			handler: [ :inst | 
				sender	 := inst sender.
				selector := inst node selector.
				receiver := inst receiver.
				arguments := inst arguments.
			];
			handlerSelector: #value:;
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
			reifyDefaultOperation;
			handler: [ :ind | operation := ind operation ];
			handlerSelector: #value:;
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
			reifyDefaultOperation; reifyNode; reifyReceiver; reifyArguments;
			handler: [ :ind | 
				selector := ind node selector.
				receiver := ind receiver.
				arguments := ind arguments.
				ind performDefaultOperation
			];
			handlerSelector: #value:;
			yourself
		).

	instrumentation addIndirection: (ScpMethodIndirection new
			reifyDefaultOperation;
			handler: [ :ind | result := ind performDefaultOperation ];
			handlerSelector: #value:;
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
