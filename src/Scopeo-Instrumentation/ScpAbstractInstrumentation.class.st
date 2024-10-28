Class {
	#name : 'ScpAbstractInstrumentation',
	#superclass : 'RBProgramNodeVisitor',
	#instVars : [
		'proxy',
		'target',
		'targetClass',
		'anoClass'
	],
	#category : 'Scopeo-Instrumentation',
	#package : 'Scopeo-Instrumentation'
}

{ #category : 'private - constants' }
ScpAbstractInstrumentation class >> proxySlotSymbol [

	^ #_proxy
]

{ #category : 'intrumenting' }
ScpAbstractInstrumentation >> astForAssignment: anASTElement [

	^ RBMessageNode
		  receiver: (RBVariableNode named: ScpInstrumentationHandler globalSymbol)
		  selector: (ScpInstrumentationHandler >> #assignment:object:value:) selector
		  arguments: {
				  (RBLiteralValueNode value: anASTElement variable name).
				  (RBVariableNode selfNode).
				  anASTElement value 
			}
]

{ #category : 'intrumenting' }
ScpAbstractInstrumentation >> astForPropagation: aReceiverNode [

	aReceiverNode isSelfVariable ifTrue: [ ^ self astForSelf ].

	^ RBMessageNode
		receiver: aReceiverNode
		selector: #instrument
		arguments: {}
]

{ #category : 'intrumenting' }
ScpAbstractInstrumentation >> astForSelf [

	^ RBVariableNode named: self class proxySlotSymbol
]

{ #category : 'handling' }
ScpAbstractInstrumentation >> handle: aMessage [

	| return |

	(targetClass lookupSelector: aMessage selector) 
		ifNil: [ MessageNotUnderstood new message: aMessage ; receiver: target; signal ]
		ifNotNil: [ :method |	self instrument: method ].

	return := MirrorPrimitives
		  withReceiver: target
		  perform: aMessage selector
		  withArguments: aMessage arguments.
	
	_SCOPEO
		message: aMessage 
		sender: thisContext sender sender receiver 
		receiver: target
		return: return.
		
 	^ return

	
]

{ #category : 'initialization' }
ScpAbstractInstrumentation >> initializeProxy [

	proxy := ScpProxy newFor: self.

	anoClass addInstVarNamed: self class proxySlotSymbol.	
	MirrorPrimitives
		fixedFieldOf: target
		at: (anoClass slotNamed: self class proxySlotSymbol) index
		put: proxy.
		
	^ proxy
]

{ #category : 'intrumenting' }
ScpAbstractInstrumentation >> instrument: aMethod [

	"Instrument the selector and compile it in the subclass, if:
	- The object has been attached to an anonymous subclass.
	- That anonymous subclass does not already contains the selector in argument."

	anoClass ifNil: [ ^ self ].
	(anoClass includesSelector: aMethod selector) ifTrue: [ ^ self ]. 
	[ anoClass compile: (self visitMethodNode: aMethod ast) formattedCode ]
		on: Error
		do: [ :e | e crTrace ].
		
]

{ #category : 'intrumenting' }
ScpAbstractInstrumentation >> visitAssignmentNode: anAssignmentNode [

	self visitNode: anAssignmentNode value.
	
	anAssignmentNode variable isInstanceVariable ifFalse: [ ^ self ].
	anAssignmentNode parent 
		addNode: (self astForAssignment: anAssignmentNode) 
		before: anAssignmentNode.
	
	
]

{ #category : 'intrumenting' }
ScpAbstractInstrumentation >> visitMessageNode: aMessageNode [

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
ScpAbstractInstrumentation >> visitMethodNode: aMethodNode [

	| method |
	
	method := aMethodNode copy.
	method selector: method selector.
	method body addSelfReturn.
	self visitNode: method body.
		
	^ method
]

{ #category : 'intrumenting' }
ScpAbstractInstrumentation >> visitReturnNode: aReturnNode [
	
	self visitNode: aReturnNode value.
	
	aReturnNode value isVariable ifFalse: [ ^ self ].
	aReturnNode value name = #self ifFalse: [ ^ self ].
	aReturnNode value: self astForSelf.
]

{ #category : 'intrumenting' }
ScpAbstractInstrumentation >> visitSuperMethod: aSelector [

	| method ast |
	
	method := targetClass superclass lookupSelector: aSelector.
	
	ast := RBParser parseMethod: method methodClass name , '_' , method sourceCode.

	method := self visitMethodNode: ast.

	anoClass compile: method formattedCode.

	^ method selector
]
