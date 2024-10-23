Class {
	#name : 'ScpObjectInstrumentation',
	#superclass : 'ASTProgramNodeVisitor',
	#instVars : [
		'object',
		'objectClass',
		'objectAnoClass'
	],
	#category : 'Scopeo-Instrumentation',
	#package : 'Scopeo-Instrumentation'
}

{ #category : 'instance creation' }
ScpObjectInstrumentation class >> applyOn: anObject [

	anObject isLiteral ifTrue: [ ^ anObject ].
	^ self new initializeObject: anObject

]

{ #category : 'intrumenting' }
ScpObjectInstrumentation >> astForAssignment: anASTElement [

	^ RBMessageNode
		  receiver: (RBVariableNode named: #_SCOPEO)
		  selector: (ScpInstrumentationHandler >> #assignment:object:value:) selector
		  arguments: {
				  (RBLiteralValueNode value: anASTElement variable name).
				  (RBVariableNode selfNode).
				  anASTElement value 
			}
]

{ #category : 'intrumenting' }
ScpObjectInstrumentation >> astForPropagation: aReceiverNode [

	aReceiverNode isSelfVariable ifTrue: [ ^ self astForSelf ].

	^ ASTMessageNode
		receiver: aReceiverNode
		selector: #instrument
		arguments: {}
]

{ #category : 'intrumenting' }
ScpObjectInstrumentation >> astForSelf [

	^ RBVariableNode named: #_proxy
]

{ #category : 'handling' }
ScpObjectInstrumentation >> handle: aMessage [

	"<debuggerCompleteToSender>"
	
	| return |
	self halt.
	(objectClass lookupSelector: aMessage selector) 
		ifNil: [ MessageNotUnderstood new message: aMessage ; receiver: object; signal ]
		ifNotNil: [ :method |	self instrument: method ].
	
	return := MirrorPrimitives
		  withReceiver: object
		  perform: ('_', aMessage selector) asSymbol
		  withArguments: aMessage arguments.
	
	_SCOPEO 
		message: aMessage 
		sender: thisContext sender sender receiver 
		receiver: object 
		return: return.
		
 	^ return

	
]

{ #category : 'initialization' }
ScpObjectInstrumentation >> initializeObject: anObject [

	object := anObject isClass ifTrue: [ anObject class ] ifFalse: [ anObject ].
	
	objectClass := object class.
	
	objectClass isAnonymous ifTrue: [ ^ objectClass instrument ].
	
	objectAnoClass := objectClass newAnonymousSubclass.
	objectAnoClass adoptInstance: object.
	
	^ self initializeProxy
]

{ #category : 'initialization' }
ScpObjectInstrumentation >> initializeProxy [
	
	| proxy |
	
	proxy := ScpObjectProxy newFor: self.
	
	object isClass 
		ifTrue: [
			objectAnoClass compile: 'instrument
				^ _proxy
			'
		] 
		ifFalse: [ 
			| temp |
			temp := object. object := proxy. proxy := temp.
			object become: proxy.
		].
	
	objectAnoClass addInstVarNamed: '_proxy'.
	MirrorPrimitives
		fixedFieldOf: object
		at: (objectAnoClass slotNamed: '_proxy' asSymbol) index
		put: proxy.
		
	^ proxy
	
]

{ #category : 'intrumenting' }
ScpObjectInstrumentation >> instrument: aMethod [

	"Instrument the selector and compile it in the subclass, if:
	- The object has been attached to an anonymous subclass.
	- That anonymous subclass does not already contains the selector in argument."

	objectAnoClass ifNil: [ ^ self ].
	(objectAnoClass includesSelector: ('_' , aMethod selector) asSymbol) ifTrue: [ ^ self ]. 
	[ objectAnoClass compile: (self visitMethodNode: aMethod ast) formattedCode ]
		on: Error
		do: [ :e | e crTrace ].
		
]

{ #category : 'actions' }
ScpObjectInstrumentation >> uninstall [

	
]

{ #category : 'intrumenting' }
ScpObjectInstrumentation >> visitAssignmentNode: anAssignmentNode [

	self visitNode: anAssignmentNode value.
	
	anAssignmentNode variable isInstanceVariable ifFalse: [ ^ self ].
	anAssignmentNode parent 
		addNode: (self astForAssignment: anAssignmentNode) 
		before: anAssignmentNode.
	
	
]

{ #category : 'intrumenting' }
ScpObjectInstrumentation >> visitMessageNode: aMessageNode [

	self visitNode: aMessageNode receiver.

	aMessageNode isSuperSend 
		ifTrue: [ 
			aMessageNode receiver: RBVariableNode selfNode.
			aMessageNode selector: (self visitSuperMethod: aMessageNode selector)
		]
		ifFalse: [
			aMessageNode receiver: (self astForPropagation: aMessageNode receiver).
		].
	
	aMessageNode arguments collect: [ :each | 
		self visitNode: each 
	]
]

{ #category : 'intrumenting' }
ScpObjectInstrumentation >> visitMethodNode: aMethodNode [

	| method |
	
	method := aMethodNode copy.
	method selector: '_' , method selector.
	method body addSelfReturn.
	self visitNode: method body.
	"method body addNodeFirst: (ASTMessageNode
	receiver: (ASTVariableNode named: #self)
	selector: #halt)."
		
	^ method
]

{ #category : 'intrumenting' }
ScpObjectInstrumentation >> visitReturnNode: aReturnNode [
	
	self visitNode: aReturnNode value.
	
	aReturnNode value isVariable ifFalse: [ ^ self ].
	aReturnNode value name = #self ifFalse: [ ^ self ].
	aReturnNode value: self astForSelf.
]

{ #category : 'intrumenting' }
ScpObjectInstrumentation >> visitSuperMethod: aSelector [

	| method ast |
	
	method := objectClass superclass lookupSelector: aSelector.
	
	ast := RBParser parseMethod: method methodClass name , '_' , method sourceCode.

	method := self visitMethodNode: ast.

	objectAnoClass compile: method formattedCode.

	^ method selector
]
