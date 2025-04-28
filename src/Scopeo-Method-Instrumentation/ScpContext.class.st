Class {
	#name : 'ScpContext',
	#superclass : 'RBProgramNodeVisitor',
	#instVars : [
		'ast',
		'parent',
		'receiver',
		'arguments',
		'environment',
		'method',
		'parameters',
		'bindings',
		'return',
		'caller',
		'isBlock'
	],
	#category : 'Scopeo-Method-Instrumentation-Instrumentation',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Instrumentation'
}

{ #category : 'instance creation' }
ScpContext class >> fromBlock: aBlock [

	^ (self fromContext: aBlock home)
		ast: aBlock sourceNode;
		yourself
]

{ #category : 'instance creation' }
ScpContext class >> fromContext: aContext [

	^ self new
		receiver: (aContext ifNotNil: [ :c | c receiver ]);
		arguments: (aContext ifNil: [ {  } ] ifNotNil: [ :c | c arguments ]);
		ast: (aContext ifNotNil: [ :c | c method sourceNode]);
		yourself
]

{ #category : 'accessing' }
ScpContext >> arguments [

	^ arguments
]

{ #category : 'accessing' }
ScpContext >> arguments: aCollection [

	arguments := aCollection.
	
	arguments size < parameters size ifTrue: [ 
		self error: 'Code expecting '
			, parameters size asString
			, ' arguments, while '
			, arguments size asString 
			, ' were provided.' .
	].
	
	1 to: parameters size do: [ :index |
		bindings at: (parameters at: index) put: (arguments at: index)
	]
]

{ #category : 'converting' }
ScpContext >> asContext [

	^ Context sender: nil receiver: receiver method: method arguments: arguments
]

{ #category : 'accessing' }
ScpContext >> ast [

	^ ast
]

{ #category : 'accessing' }
ScpContext >> ast: anAst [
	
	| methodNode |

	ast := anAst.
	
	ast ifNil: [ ^ self ].
	
	methodNode := ast methodOrBlockNode.
	[ methodNode isNil or: [ methodNode isMethod ] ] whileFalse: [ 
		methodNode := methodNode parent.
	].

	method := methodNode compiledMethod
]

{ #category : 'testing' }
ScpContext >> beBlock [

	isBlock := true
]

{ #category : 'accessing' }
ScpContext >> bindings [

	^ bindings
]

{ #category : 'accessing' }
ScpContext >> bindings: anObject [

	bindings := anObject
]

{ #category : 'accessing' }
ScpContext >> caller: aCaller [

	caller := aCaller
]

{ #category : 'evaluating' }
ScpContext >> cull: firstArg [
	
	caller ifNil: [ caller := thisContext sender ].
	
	^ self value: firstArg
]

{ #category : 'evaluating' }
ScpContext >> cull: firstArg cull: secondArg [

	caller ifNil: [ caller := thisContext sender ].
	
	^ self value: firstArg value: secondArg
]

{ #category : 'evaluating' }
ScpContext >> cull: firstArg cull: secondArg cull: thirdArg [
	
	caller ifNil: [ caller := thisContext sender ].
	
	^ self value: firstArg value: secondArg value: thirdArg
]

{ #category : 'evaluating' }
ScpContext >> cull: firstArg cull: secondArg cull: thirdArg cull: fourthArg [
	
	caller ifNil: [ caller := thisContext sender ].
	
	^ self value: firstArg value: secondArg value: thirdArg value: fourthArg 
]

{ #category : 'controlling' }
ScpContext >> doWhileFalse: conditionBlock [
	"Evaluate the receiver once, then again as long the value of conditionBlock is false."

	| result |
	
	caller ifNil: [ caller := thisContext sender ].
		
	[result := self value.
	conditionBlock value] whileFalse.

	^ result
]

{ #category : 'controlling' }
ScpContext >> doWhileTrue: conditionBlock [
	"Evaluate the receiver once, then again as long the value of conditionBlock is true."

	| result |
	
	caller ifNil: [ caller := thisContext sender ].
	
	[result := self value.
	conditionBlock value] whileTrue.

	^ result
]

{ #category : 'exceptions' }
ScpContext >> ensure: aBlock [
	
	caller ifNil: [ caller := thisContext sender ].
	
	^ [ self value ] ensure: [ aBlock value ]
]

{ #category : 'services' }
ScpContext >> evaluate [

	| result |
	
	caller := parent ifNil: [ 
		self resolveOuterContext
	].

	result := self visitNode: ast.
	
	result isBlock ifTrue: [ 
		result caller: nil 
	].

	^ result
]

{ #category : 'as yet unclassified' }
ScpContext >> evaluateInstanceAssignment: aVariableName old: anOldValue new: aNewValue [
]

{ #category : 'as yet unclassified' }
ScpContext >> evaluateMessage: aMessageNode on: aReceiver [

	^ self evaluateMessage: aMessageNode on: aReceiver withArgs: (aMessageNode arguments collect: [ :a |
		|arg|
		arg := self visitNode: a.
		return ifNotEmpty: [ :r | ^ r ].
		arg
	])
	

]

{ #category : 'as yet unclassified' }
ScpContext >> evaluateMessage: aMessageNode on: aReceiver withArgs: aArguments [

	| lookupClass methodToExecute methodArguments |
	
	methodArguments := aArguments.
	
	lookupClass := aMessageNode isSuperSend 
		ifTrue: [ method methodClass superclass ]
		ifFalse: [ aReceiver class ].
		
	methodToExecute := lookupClass lookupSelector: aMessageNode selector.	
	methodToExecute ifNil: [ 
		methodToExecute := lookupClass lookupSelector: #doesNotUnderstand:.
		methodArguments := { 
			MessageSend 
				receiver: aReceiver 
				selector: aMessageNode selector
				arguments: aArguments 
		}
	].

	(self useDefaultInterpreterFor: methodToExecute) ifTrue: [ 
		^ self evaluateMethod: methodToExecute on: aReceiver withArgs: methodArguments asArray
	].

	^ self evaluateMethodNode: methodToExecute ast on: aReceiver withArgs: methodArguments asArray
	

]

{ #category : 'as yet unclassified' }
ScpContext >> evaluateMethod: aMethodToExecute on: aReceiver withArgs: aArguments [

	^ aReceiver withArgs: aArguments executeMethod: aMethodToExecute 
]

{ #category : 'as yet unclassified' }
ScpContext >> evaluateMethodNode: aMethodNode on: aReceiver withArgs: aArguments [

	^ (self visitMethodOrBlockNode: aMethodNode)
		arguments: aArguments;
		receiver: aReceiver;
		evaluate
	
]

{ #category : 'testing' }
ScpContext >> hasReturned [

	^ return isNotEmpty or: [ caller class == self class and: [ caller hasReturned ] ]
]

{ #category : 'exceptions' }
ScpContext >> ifCurtailed: aBlock [
	"Evaluate the receiver with an abnormal termination action.
	 Evaluate aBlock only if execution is unwound during execution
	 of the receiver.  If execution of the receiver finishes normally do
	 not evaluate aBlock.  N.B.  This method is *not* implemented as a
	 primitive.  Primitive 198 always fails.  The VM uses prim 198 in a
	 context's method as the mark for an ensure:/ifCurtailed: activation."
	
	caller ifNil: [ caller := thisContext sender ].
		
	^ [ self value ] on: Error do: aBlock 
]

{ #category : 'initialization' }
ScpContext >> initialize [
	
	isBlock := false.
	
	return := Stack new.
	bindings := Dictionary new.
	arguments := OrderedCollection new.
	parameters := OrderedCollection new.
	
	
]

{ #category : 'testing' }
ScpContext >> isBlock [

	^ isBlock
]

{ #category : 'accessing' }
ScpContext >> parameters: aCollection [

	parameters := aCollection
]

{ #category : 'accessing' }
ScpContext >> parent [

	^ parent
]

{ #category : 'accessing' }
ScpContext >> parent: anObject [

	parent := anObject
]

{ #category : 'accessing' }
ScpContext >> receiver [

	^ receiver
]

{ #category : 'accessing' }
ScpContext >> receiver: anObject [

	receiver := anObject
]

{ #category : 'as yet unclassified' }
ScpContext >> resolveOuterContext [
	
	| outer|
	outer := thisContext.
	
	[ outer receiver class == self class ] whileTrue: [ 
		outer := outer sender.
	].
	
	^ outer 
]

{ #category : 'testing' }
ScpContext >> return [

	^ return 
		ifEmpty: [ caller return ]
		ifNotEmpty: [ :r | r top ]
]

{ #category : 'accessing' }
ScpContext >> return: anObject [

	return push: anObject.
	
	isBlock ifTrue: [ 
		caller return: anObject
	].
	
	^ return top
]

{ #category : 'as yet unclassified' }
ScpContext >> useDefaultInterpreterFor: aMethod [

	aMethod isPrimitive ifTrue: [ ^ true ].
	aMethod isFFIMethod ifTrue: [ ^ true ].
	aMethod methodClass = ScpContext ifTrue: [ ^ true ].
	
	(aMethod hasPragmaNamed: #noInstrumentation) ifTrue: [ ^ true ].	

	aMethod methodClass = UndefinedObject ifTrue: [ ^ false ].
	
	(aMethod package name beginsWith: #Kernel) ifTrue: [ ^ true ].
	(aMethod package name beginsWith: #FreeType) ifTrue: [ ^ true ].
	(aMethod package name beginsWith: #UnifiedFFI) ifTrue: [ ^ true ].
	(aMethod package name beginsWith: #Collection) ifTrue: [ ^ true ].
	
	^ false

]

{ #category : 'evaluating' }
ScpContext >> value [

	^ self evaluate
]

{ #category : 'evaluating' }
ScpContext >> value: firstArg [
		
   self arguments: { firstArg }.

   ^ self evaluate
]

{ #category : 'evaluating' }
ScpContext >> value: firstArg value: secondArg [

   self arguments: {
		firstArg.
		secondArg 
	}.

   ^ self evaluate
]

{ #category : 'evaluating' }
ScpContext >> value: firstArg value: secondArg value: thirdArg [

   self arguments: {
		firstArg.
		secondArg.
		thirdArg
	}.

   ^ self evaluate
]

{ #category : 'evaluating' }
ScpContext >> value: firstArg value: secondArg value: thirdArg value: fourthArg [

   self arguments: {
		firstArg.
		secondArg.
		thirdArg.
      fourthArg 
	}.

   ^ self evaluate
]

{ #category : 'evaluating' }
ScpContext >> valueNoContextSwitch [
	
	^ self value
]

{ #category : 'visiting' }
ScpContext >> visitArgumentNodes: anArgumentCollection [

	^ anArgumentCollection collect: [ :a | a name ]
]

{ #category : 'visiting' }
ScpContext >> visitArrayNode: anArrayNode [

	^ (anArrayNode statements collect: [ :each | 
		self visitNode: each 
	]) asArray

]

{ #category : 'visiting' }
ScpContext >> visitAssignmentNode: anAssignmentNode [

	| value |

	value := self visitNode: anAssignmentNode value.
	self hasReturned ifTrue: [ ^ self return ].
	
	anAssignmentNode variable isLiteralVariable ifTrue: [ 
		anAssignmentNode variable variable write: value
	].
	
	anAssignmentNode variable isTempVariable ifTrue: [ 
		bindings at: anAssignmentNode variable name put: value.
	]. 

	anAssignmentNode variable isInstanceVariable ifTrue: [ 
		self evaluateInstanceAssignment: anAssignmentNode old: (anAssignmentNode variable variable read: receiver) new: value.  
		anAssignmentNode variable variable write: value to: receiver.
	].

	^ value

	
]

{ #category : 'visiting' }
ScpContext >> visitBlockNode: aBlockNode [

	^ (self visitMethodOrBlockNode: aBlockNode)
		bindings: bindings;
		beBlock;
		yourself
]

{ #category : 'visiting' }
ScpContext >> visitCascadeNode: aCascadeNode [

	| messageReceiver |
	
	messageReceiver := self visitNode: aCascadeNode receiver.

	^ (aCascadeNode messages collect: [ :message |
		self evaluateMessage: message on: messageReceiver 
	]) last
]

{ #category : 'visiting' }
ScpContext >> visitInstanceVariableNode: aSelfNode [
	
	^ receiver readSlot: aSelfNode variable
]

{ #category : 'visiting' }
ScpContext >> visitLiteralArrayNode: aRBLiteralArrayNode [

	^ (aRBLiteralArrayNode contents collect: [ :l |
		self visitNode: l	
	]) asArray
]

{ #category : 'visiting' }
ScpContext >> visitLiteralNode: aLiteralNode [

	^ aLiteralNode value
]

{ #category : 'visiting - variables' }
ScpContext >> visitLiteralVariableNode: aLiteralVariableNode [

	^ aLiteralVariableNode variable value
]

{ #category : 'visiting' }
ScpContext >> visitLocalVariableNode: aVariableNode [
	
	^ bindings at: aVariableNode name ifAbsent: [ ^ nil ]
]

{ #category : 'visiting' }
ScpContext >> visitMessageNode: aMessageNode [

	| messageReceiver |
	
	messageReceiver := self visitNode: aMessageNode receiver.
	self hasReturned ifTrue: [ ^ self return ].
	
	^ self 
		evaluateMessage: aMessageNode 
		on: messageReceiver
]

{ #category : 'visiting' }
ScpContext >> visitMethodNode: aMethodNode [

	^ (self visitMethodOrBlockNode: aMethodNode) evaluate
]

{ #category : 'visiting' }
ScpContext >> visitMethodOrBlockNode: aMethodOrBlockNode [

	^ self class new
		parent: self;
		caller: caller;
		receiver: receiver;
		ast: aMethodOrBlockNode body;
		parameters: (self visitArgumentNodes: aMethodOrBlockNode arguments);
		yourself
]

{ #category : 'visiting' }
ScpContext >> visitReturnNode: aReturnNode [
	
	^ self return: (self visitNode: aReturnNode value)
]

{ #category : 'visiting' }
ScpContext >> visitSelfNode: aSelfNode [

	^ receiver
]

{ #category : 'visiting' }
ScpContext >> visitSequenceNode: aSequenceNode [

	| result |

	aSequenceNode statements do: [ :statement | 
		result := self visitNode: statement.
		self hasReturned ifTrue: [ ^ self return ].
	].

	aSequenceNode methodOrBlockNode isBlock ifTrue: [ 
		^ result		
	].

	^ receiver
]

{ #category : 'visiting' }
ScpContext >> visitSuperNode: aSuperNode [

	^ receiver
]

{ #category : 'visiting' }
ScpContext >> visitThisContextNode: aThisContextNode [

	^ self asContext
]

{ #category : 'visiting' }
ScpContext >> visitVariableNode: aVariableNode [
	
	^ bindings at: aVariableNode name
]

{ #category : 'controlling' }
ScpContext >> whileFalse [
	"Ordinarily compiled in-line, and therefore not overridable.
	This is in case the message is sent to other than a literal block.
	Evaluate the receiver, as long as its value is false."
	(self hasReturned not and: [ self value not ]) ifTrue: [
		self whileFalse
	]
]

{ #category : 'controlling' }
ScpContext >> whileFalse: aBlock [
	"Ordinarily compiled in-line, and therefore not overridable.
	This is in case the message is sent to other than a literal block.
	Evaluate the argument, aBlock, as long as the value of the receiver is false."
	(self hasReturned not and: [ self value not ]) ifTrue: [
		aBlock value.
		self whileFalse: aBlock
	].
	^ nil
]

{ #category : 'controlling' }
ScpContext >> whileNil: aBlock [
	"Unlike #whileTrue/False: this is not compiled inline."
	^ [self value isNil] whileTrue: [aBlock value]
]

{ #category : 'controlling' }
ScpContext >> whileNotNil: aBlock [
	"Unlike #whileTrue/False: this is not compiled inline."
	^ [self value isNotNil] whileTrue: [aBlock value]
]

{ #category : 'controlling' }
ScpContext >> whileTrue [
	"Ordinarily compiled in-line, and therefore not overridable.
	This is in case the message is sent to other than a literal block.
	Evaluate the receiver, as long as its value is true."
	(self hasReturned not and: [ self value ]) ifTrue: [
		self whileTrue
	]
]

{ #category : 'controlling' }
ScpContext >> whileTrue: aBlock [
	"Ordinarily compiled in-line, and therefore not overridable.
	This is in case the message is sent to other than a literal block.
	Evaluate the argument, aBlock, as long as the value of the receiver is true."
	
	(self hasReturned not and: [ self value ]) ifTrue: [
		aBlock value. 
		self whileTrue: aBlock 
	].
	^ nil
]
