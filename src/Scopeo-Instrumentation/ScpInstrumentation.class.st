Class {
	#name : 'ScpInstrumentation',
	#superclass : 'RBProgramNodeVisitor',
	#instVars : [
		'proxy',
		'target',
		'targetClass',
		'anoClass',
		'handler',
		'inMetaLevel'
	],
	#category : 'Scopeo-Instrumentation',
	#package : 'Scopeo-Instrumentation'
}

{ #category : 'private - constants' }
ScpInstrumentation class >> handlerSymbol [

	^ #_handler
]

{ #category : 'testing' }
ScpInstrumentation class >> isAbstract [

	^ self == ScpInstrumentation
]

{ #category : 'as yet unclassified' }
ScpInstrumentation class >> metaLevelSymbol [

	^ #_metaLevel
]

{ #category : 'private - constants' }
ScpInstrumentation class >> proxySymbol [

	^ #_proxy
]

{ #category : 'visiting' }
ScpInstrumentation class >> tempVarSymbol [

	^ #_temp
]

{ #category : 'rewriting' }
ScpInstrumentation >> astForAssignment: anASTElement [
	
	| statements |

	statements := OrderedCollection new.
	statements add: (RBAssignmentNode 
		variable: self astForTempVariable
		value: anASTElement value
	).
	statements add: (self astForAssignmentHook: anASTElement).
	statements add: (RBAssignmentNode 
		variable: anASTElement variable 
		value: self astForTempVariable
	).
	
	^ statements
]

{ #category : 'rewriting' }
ScpInstrumentation >> astForAssignmentHook: anASTElement [

	^ RBMessageNode
		  receiver: self astForHandler
		  selector: (ScpInstrumentationHandler >> #assignment:object:value:) selector
		  arguments: {
				  (RBLiteralValueNode value: anASTElement variable name).
				  (RBVariableNode selfNode).
					self astForTempVariable
		  }
]

{ #category : 'rewriting' }
ScpInstrumentation >> astForHandler [

	^ RBVariableNode named: self class handlerSymbol
]

{ #category : 'rewriting' }
ScpInstrumentation >> astForMetaLevel [

	^ RBVariableNode named: self class metaLevelSymbol
]

{ #category : 'rewriting' }
ScpInstrumentation >> astForMetaLevel: aMethod [

	aMethod body addNodesFirst: { 
		RBMessageNode
		  receiver: self astForMetaLevel
		  selector: #ifTrue:
		  arguments: { 
				(RBBlockNode body:
				   (RBSequenceNode statements: { 
						(RBReturnNode value: 
							(RBMessageNode
								 receiver: (RBVariableNode superNode)
							    selector: aMethod selector))}))} .
		RBAssignmentNode
			variable: self astForMetaLevel
			value: (RBLiteralValueNode value: true)
	}.
	
	aMethod body addNodeLast: (RBAssignmentNode
			variable: self astForMetaLevel
			value: (RBLiteralValueNode value: false))
]

{ #category : 'rewriting' }
ScpInstrumentation >> astForMethod: anASTElement [

	^ RBMessageNode
		 receiver: (RBVariableNode named: self class handlerSymbol)
		 selector: (ScpInstrumentationHandler >> #message:sender:receiver:arguments:) selector
		 arguments: {
			 (RBLiteralValueNode value: anASTElement selector).
			 (RBMessageNode
					receiver: (RBMessageNode
			 			receiver: (RBMessageNode
					  		receiver: (RBMessageNode
							  	 receiver: (RBVariableNode named: #thisContext)
							   	 selector: #sender)
					      selector: #sender)
			 			selector: #sender)
					selector: #receiver).
			 RBVariableNode selfNode.
			 (RBArrayNode statements: anASTElement arguments) 
		}
]

{ #category : 'rewriting' }
ScpInstrumentation >> astForMethodHook: anASTElement [

	^ RBMessageNode
		 receiver: self astForHandler
		 selector: (ScpInstrumentationHandler >> #message:sender:receiver:arguments:) selector
		 arguments: {
			 (RBLiteralValueNode value: anASTElement selector).
			 (RBMessageNode
					receiver: (RBMessageNode
			 			receiver: (RBMessageNode
					  		receiver: (RBMessageNode
							  	 receiver: (RBVariableNode thisContextNode)
							   	 selector: #sender)
					      selector: #sender)
			 			selector: #sender)
					selector: #receiver).
			 RBVariableNode selfNode.
			 (RBArrayNode statements: anASTElement arguments) 
		}
]

{ #category : 'rewriting' }
ScpInstrumentation >> astForPropagation: anASTElementNode [

	anASTElementNode isSelfVariable ifTrue: [ ^ self astForSelf ].

	^ RBMessageNode
		  receiver: anASTElementNode
		  selector: #instrument:
		  arguments: { (RBVariableNode named: self class handlerSymbol) }
]

{ #category : 'rewriting' }
ScpInstrumentation >> astForReturn: anASTElement [

	| statements |

	statements := OrderedCollection new.
	statements add: (RBAssignmentNode 
		variable: self astForTempVariable
		value: anASTElement value
	).
	statements add: (self astForReturnHook: anASTElement).
	statements add: anASTElement.
	
	^ statements
]

{ #category : 'rewriting' }
ScpInstrumentation >> astForReturnHook: anASTElement [

	anASTElement value: self astForTempVariable.

	^ RBMessageNode
		  receiver: self astForHandler 
		  selector: (ScpInstrumentationHandler >> #return:) selector
		  arguments: { anASTElement value }
]

{ #category : 'rewriting' }
ScpInstrumentation >> astForSelf [

	^ RBVariableNode named: self class proxySymbol
]

{ #category : 'rewriting' }
ScpInstrumentation >> astForTempVariable [

	^ RBVariableNode named: self class tempVarSymbol
]

{ #category : 'handling' }
ScpInstrumentation >> handleMessage: aMessage [

	| return |

	(targetClass lookupSelector: aMessage selector) 
		ifNil: [ MessageNotUnderstood new message: aMessage; receiver: target; signal ]
		ifNotNil: [ :method |	self instrument: method ].
				
	return := MirrorPrimitives
		  withReceiver: target
		  perform: aMessage selector
		  withArguments: aMessage arguments.
		
 	^ return

	
]

{ #category : 'accessing' }
ScpInstrumentation >> handler: anInstrumentationHandler [

	handler := anInstrumentationHandler
]

{ #category : 'initialization' }
ScpInstrumentation >> initialize [

	proxy := ScpProxy newFor: self.
	inMetaLevel := false

	
]

{ #category : 'initialization' }
ScpInstrumentation >> initializeInstVar [

	anoClass addInstVarNamed: self class handlerSymbol.	
	anoClass addInstVarNamed: self class metaLevelSymbol.
	anoClass addInstVarNamed: self class proxySymbol.	
	
	MirrorPrimitives
		fixedFieldOf: target
		at: (anoClass slotNamed: self class handlerSymbol) index
		put: handler.
	MirrorPrimitives
		fixedFieldOf: target
		at: (anoClass slotNamed: self class metaLevelSymbol) index
		put: false.
	MirrorPrimitives
		fixedFieldOf: target
		at: (anoClass slotNamed: self class proxySymbol) index
		put: proxy.
]

{ #category : 'actions' }
ScpInstrumentation >> install [

	self subclassResponsibility
]

{ #category : 'intrumenting' }
ScpInstrumentation >> instrument: aMethod [

	"Instrument the selector and compile it in the subclass, if:
	- The object has been attached to an anonymous subclass.
	- That anonymous subclass does not already contains the selector in argument."

	anoClass ifNil: [ ^ self ].
	(anoClass includesSelector: aMethod selector) ifTrue: [ ^ self ]. 
	(aMethod hasPragmaNamed: #noInstrumentation) ifTrue: [ ^ self ].
	[ anoClass compile: (self visitMethodNode: aMethod ast) formattedCode ]
		onErrorDo: [ :e | 
			Smalltalk logStdOutDuring: [ :logger |
				logger	 nextPutAll: e; cr 
			] 
		]
]

{ #category : 'accessing' }
ScpInstrumentation >> proxy [

	^ proxy
]

{ #category : 'accessing' }
ScpInstrumentation >> target [

	self subclassResponsibility
]

{ #category : 'actions' }
ScpInstrumentation >> uninstall [

	self subclassResponsibility
]

{ #category : 'visiting' }
ScpInstrumentation >> visitAssignmentNode: anAssignmentNode [

	self visitNode: anAssignmentNode value.
	
	anAssignmentNode variable isInstanceVariable ifFalse: [ ^ self ].
	
	^ self astForAssignment: anAssignmentNode
]

{ #category : 'visiting' }
ScpInstrumentation >> visitMessageNode: aMessageNode [

	aMessageNode arguments do: [ :each | 
		self visitNode: each 
	].

	self visitNode: aMessageNode receiver.

	aMessageNode receiver isBlock ifTrue: [ ^ self ].
	aMessageNode isSuperSend 
		ifTrue: [ 
			aMessageNode receiver: RBVariableNode selfNode.
			aMessageNode selector: (self visitSuperMethod: aMessageNode selector)
		]
		ifFalse: [
			aMessageNode receiver: (self astForPropagation: aMessageNode receiver).
		].
	
	
]

{ #category : 'visiting' }
ScpInstrumentation >> visitMethodNode: aMethodNode [

	| method |
	
	method := aMethodNode copy.
	method body addSelfReturn.
	
	self visitNode: method body.
	
	self astForMetaLevel: method.
		
	^ method
]

{ #category : 'visiting' }
ScpInstrumentation >> visitReturnNode: aReturnNode [
	
	self visitNode: aReturnNode value.
	
	(aReturnNode value isVariable and: [ aReturnNode value name = #self ]) ifTrue: [
		aReturnNode value: self astForSelf.
	].
	
	^ self astForReturn: aReturnNode

	
]

{ #category : 'visiting' }
ScpInstrumentation >> visitSequenceNode: aSequenceNode [

	| oldStatements newStatements |

	aSequenceNode parent isBlock ifFalse: [  
		aSequenceNode addTemporaryNamed: self class tempVarSymbol.
	].

	oldStatements := aSequenceNode statements.
	aSequenceNode statements: Array empty.
	oldStatements do: [ :s | 
		newStatements := self visitNode: s.
		newStatements isCollection 
			ifTrue: [ aSequenceNode addNodes: newStatements ]
			ifFalse: [ aSequenceNode addNode: s ]
	].
]

{ #category : 'visiting' }
ScpInstrumentation >> visitSuperMethod: aSelector [

	| method ast |
	
	method := targetClass superclass lookupSelector: aSelector.
	
	ast := RBParser parseMethod: method methodClass name , '_' , method sourceCode.

	method := self visitMethodNode: ast.

	anoClass compile: method formattedCode.

	^ method selector
]
