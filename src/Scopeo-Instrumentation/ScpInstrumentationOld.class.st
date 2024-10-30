Class {
	#name : #ScpInstrumentationOld,
	#superclass : #RBProgramNodeVisitor,
	#instVars : [
		'proxy',
		'anoClass',
		'handler',
		'inMetaLevel',
		'objectClass',
		'object',
		'lookupClass',
		'disabled'
	],
	#category : #'Scopeo-Instrumentation'
}

{ #category : #'private - constants' }
ScpInstrumentationOld class >> handlerSymbol [

	^ #_handler
]

{ #category : #testing }
ScpInstrumentationOld class >> isAbstract [

	^ self == ScpInstrumentation
]

{ #category : #'private - constants' }
ScpInstrumentationOld class >> proxySymbol [

	^ #_proxy
]

{ #category : #'private - constants' }
ScpInstrumentationOld class >> tempVarSymbol [

	^ #_tmp
]

{ #category : #'as yet unclassified' }
ScpInstrumentationOld >> astForAssignmentHook: anASTElement [

	^ RBMessageNode
		  receiver: self astForHandler
		  selector: (ScpInstrumentationHandler >> #assignment:object:value:) selector
		  arguments: {
				  (RBLiteralValueNode value: anASTElement variable name).
				  (RBVariableNode selfNode).
					self nodeForRewritingTempVariable
		  }
]

{ #category : #'as yet unclassified' }
ScpInstrumentationOld >> astForHandler [

	^ RBVariableNode named: self class handlerSymbol
]

{ #category : #'as yet unclassified' }
ScpInstrumentationOld >> astForMetaLevel [

	^ RBVariableNode named: self class metaLevelSymbol
]

{ #category : #'as yet unclassified' }
ScpInstrumentationOld >> astForMetaLevel: aMethod [

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

{ #category : #'as yet unclassified' }
ScpInstrumentationOld >> astForMethod: anASTElement [

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

{ #category : #'as yet unclassified' }
ScpInstrumentationOld >> astForMethodHook: anASTElement [

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

{ #category : #'as yet unclassified' }
ScpInstrumentationOld >> astForPropagation: anASTElementNode [

	anASTElementNode isSelfVariable ifTrue: [ ^ self nodeForRewrittenSelfVariable ].

	^ RBMessageNode
		  receiver: anASTElementNode
		  selector: #instrument:
		  arguments: { (RBVariableNode named: self class handlerSymbol) }
]

{ #category : #'as yet unclassified' }
ScpInstrumentationOld >> astForReturn: anASTElement [

	| statements |

	statements := OrderedCollection new.
	statements add: (RBAssignmentNode 
		variable: self nodeForRewritingTempVariable
		value: anASTElement value
	).
	statements add: (self astForReturnHook: anASTElement).
	statements add: anASTElement.
	
	^ statements
]

{ #category : #'as yet unclassified' }
ScpInstrumentationOld >> astForReturnHook: anASTElement [

	anASTElement value: self nodeForRewritingTempVariable.

	^ RBMessageNode
		  receiver: self astForHandler 
		  selector: (ScpInstrumentationHandler >> #return:) selector
		  arguments: { anASTElement value }
]

{ #category : #'as yet unclassified' }
ScpInstrumentationOld >> handleMessage: aMessage [

	| return |
	
	disabled ifTrue: [ 
		MirrorPrimitives
		  withReceiver: object
		  perform: aMessage selector
		  withArguments: aMessage arguments
		  inSuperclass: objectClass.
	].
	disabled := true.
	
	(objectClass lookupSelector: aMessage selector) ifNotNil: [ :method |
		self instrument: method 
	].

	handler 
		message: aMessage selector 
		sender: thisContext sender sender receiver 
		receiver: object 
		arguments: aMessage arguments.

	return := MirrorPrimitives
		  withReceiver: object
		  perform: aMessage selector
		  withArguments: aMessage arguments.
	
	handler return: return.
	disabled := false.
			
 	^ return

	
]

{ #category : #'as yet unclassified' }
ScpInstrumentationOld >> handler: anInstrumentationHandler [

	handler := anInstrumentationHandler
]

{ #category : #initialization }
ScpInstrumentationOld >> initialize [

	proxy := ScpObjectProxyOld newFor: self.
	inMetaLevel := false

	
]

{ #category : #'as yet unclassified' }
ScpInstrumentationOld >> initializeInstVar [
	
	lookupClass addClassVarNamed: self class handlerSymbol.	
	lookupClass addClassVarNamed: self class proxySymbol.	

	lookupClass classVarNamed: self class handlerSymbol put: handler. 
	lookupClass classVarNamed: self class proxySymbol put: proxy.
]

{ #category : #initialization }
ScpInstrumentationOld >> install [

	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
ScpInstrumentationOld >> instrument: aMethod [

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

{ #category : #'as yet unclassified' }
ScpInstrumentationOld >> nodeForRewritingTempVariable [

	^ RBVariableNode named: self class tempVarSymbol
]

{ #category : #'as yet unclassified' }
ScpInstrumentationOld >> nodeForRewrittenSelfVariable [

	^ RBVariableNode named: self class proxySymbol
]

{ #category : #'as yet unclassified' }
ScpInstrumentationOld >> object [

	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
ScpInstrumentationOld >> proxy [

	^ proxy
]

{ #category : #'as yet unclassified' }
ScpInstrumentationOld >> rewriteAssignment: anASTElement [
	
	| statements |

	statements := OrderedCollection new.
	statements add: (RBAssignmentNode 
		variable: self nodeForRewritingTempVariable
		value: anASTElement value
	).
	statements add: (self astForAssignmentHook: anASTElement).
	statements add: (RBAssignmentNode 
		variable: anASTElement variable 
		value: self nodeForRewritingTempVariable
	).
	
	^ statements
]

{ #category : #initialization }
ScpInstrumentationOld >> uninstall [

	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
ScpInstrumentationOld >> visitAssignmentNode: anAssignmentNode [

	self visitNode: anAssignmentNode value.
	
	anAssignmentNode variable isInstanceVariable ifFalse: [ ^ self ].
	
	^ self rewriteAssignment: anAssignmentNode
]

{ #category : #'as yet unclassified' }
ScpInstrumentationOld >> visitMessageNode: aMessageNode [

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

{ #category : #'as yet unclassified' }
ScpInstrumentationOld >> visitMethodNode: aMethodNode [

	| method |
	
	method := aMethodNode copy.
	method body addSelfReturn.
	
	self visitNode: method body.
	
	"
	self astForMethod: method.
	self astForMetaLevel: method.
	"
	
	^ method
]

{ #category : #'as yet unclassified' }
ScpInstrumentationOld >> visitReturnNode: aReturnNode [
	
	self visitNode: aReturnNode value.
	
	(aReturnNode value isVariable and: [ aReturnNode value name = #self ]) ifTrue: [
		aReturnNode value: self nodeForRewrittenSelfVariable.
	].
	
	"^ self astForReturn: aReturnNode"

	
]

{ #category : #'as yet unclassified' }
ScpInstrumentationOld >> visitSequenceNode: aSequenceNode [

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

{ #category : #'as yet unclassified' }
ScpInstrumentationOld >> visitSuperMethod: aSelector [

	| method ast |
	
	method := objectClass superclass lookupSelector: aSelector.
	
	ast := RBParser parseMethod: method methodClass name , '_' , method sourceCode.

	method := self visitMethodNode: ast.

	anoClass compile: method formattedCode.

	^ method selector
]
