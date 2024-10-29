Class {
	#name : 'ScpInstrumentation',
	#superclass : 'RBProgramNodeVisitor',
	#instVars : [
		'enabled',
		'handler',
		'object',
		'objectClass',
		'lookupClass',
		'proxy'
	],
	#category : 'Scopeo-Instrumentation',
	#package : 'Scopeo-Instrumentation'
}

{ #category : 'instance creation' }
ScpInstrumentation class >> applyOn: aClass usingHandler: anInstrumentationHandler [

	self subclassResponsibility
]

{ #category : 'private - constants' }
ScpInstrumentation class >> handlerSymbol [

	^ #_handler
]

{ #category : 'testing' }
ScpInstrumentation class >> isAbstract [

	^ self == ScpInstrumentation
]

{ #category : 'private - constants' }
ScpInstrumentation class >> proxySymbol [

	^ #_proxy
]

{ #category : 'private - constants' }
ScpInstrumentation class >> tempVarSymbol [

	^ #_tmp
]

{ #category : 'private - rewriting' }
ScpInstrumentation >> astForAssignment: anASTElement [

	| statements |
	
	statements := OrderedCollection new.

	statements add: (RBAssignmentNode variable: self astForTempVariable value: anASTElement value).
	
	statements add: (RBMessageNode
		receiver: (RBVariableNode named: self class handlerSymbol)
		selector: (ScpInstrumentationHandler >> #assignment:object:value:) selector
		arguments: {
			(RBLiteralValueNode value: anASTElement variable name).
			RBVariableNode selfNode.
			self astForTempVariable 
		}).
					
	statements add: (RBAssignmentNode variable: anASTElement variable value: self astForTempVariable).

	^ statements
]

{ #category : 'private - rewriting' }
ScpInstrumentation >> astForPropagation: anASTElementNode [

	anASTElementNode isSelfVariable ifTrue: [ ^ self astForSelf ].

	^ RBMessageNode
		  receiver: anASTElementNode
		  selector: #instrument:
		  arguments: { (RBVariableNode named: self class handlerSymbol) }
]

{ #category : 'private - rewriting' }
ScpInstrumentation >> astForSelf [

	^ RBVariableNode named: self class proxySymbol
]

{ #category : 'private - rewriting' }
ScpInstrumentation >> astForTempVariable [

	^ RBVariableNode named: self class tempVarSymbol
]

{ #category : 'services' }
ScpInstrumentation >> disable [

	enabled := false.
]

{ #category : 'services' }
ScpInstrumentation >> enable [

	enabled := true.
]

{ #category : 'private - hook' }
ScpInstrumentation >> handleMessage: aMessage [

	| return |
	
	self isEnabled ifTrue: [ 
		MirrorPrimitives
		  withReceiver: object
		  perform: aMessage selector
		  withArguments: aMessage arguments
		  inSuperclass: objectClass.
	].
	self disable.
	
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
	self enable.
			
 	^ return

	
]

{ #category : 'initialization' }
ScpInstrumentation >> initialize [
	
	proxy := ScpProxy newFor: self.
	self disable

	
]

{ #category : 'initialization' }
ScpInstrumentation >> initializeLookupClass: aLookupClass [

	lookupClass := aLookupClass.
	lookupClass addClassVarNamed: self class handlerSymbol.	
	lookupClass addClassVarNamed: self class proxySymbol.	

	lookupClass classVarNamed: self class handlerSymbol put: handler. 
	lookupClass classVarNamed: self class proxySymbol put: proxy.
]

{ #category : 'initialization' }
ScpInstrumentation >> install [

	self subclassResponsibility
]

{ #category : 'private - rewriting' }
ScpInstrumentation >> instrument: aMethod [

	"Instrument the selector and compile it in the subclass, if:
	- The object has been attached to an anonymous subclass.
	- That anonymous subclass does not already contains the selector in argument."

	lookupClass ifNil: [ ^ self ].
	(lookupClass includesSelector: aMethod selector) ifTrue: [ ^ self ]. 
	(aMethod hasPragmaNamed: #noInstrumentation) ifTrue: [ ^ self ].
	[ lookupClass compile: (self visitMethodNode: aMethod ast) formattedCode ]
		onErrorDo: [ :e | 
			Smalltalk logStdOutDuring: [ :logger |
				logger	 nextPutAll: e; cr 
			] 
		]
]

{ #category : 'services' }
ScpInstrumentation >> isEnabled [

	^ enabled
]

{ #category : 'parameters' }
ScpInstrumentation >> object: anObject handler: aHandler [

	object := anObject.
	handler := aHandler
	
]

{ #category : 'initialization' }
ScpInstrumentation >> uninstall [

	self subclassResponsibility
]

{ #category : 'private - rewriting' }
ScpInstrumentation >> visitAssignmentNode: anAssignmentNode [

	self visitNode: anAssignmentNode value.
	
	anAssignmentNode variable isInstanceVariable ifFalse: [ ^ self ].
	
	^ self astForAssignment: anAssignmentNode
]

{ #category : 'private - rewriting' }
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

{ #category : 'private - rewriting' }
ScpInstrumentation >> visitMethodNode: aMethodNode [

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

{ #category : 'private - rewriting' }
ScpInstrumentation >> visitReturnNode: aReturnNode [
	
	self visitNode: aReturnNode value.
	
	aReturnNode value isVariable ifTrue: [ ^ self ]. 
	aReturnNode value name = #self ifTrue: [ ^ self ].
	aReturnNode value: self astForSelf.

	
]

{ #category : 'private - rewriting' }
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

{ #category : 'private - rewriting' }
ScpInstrumentation >> visitSuperMethod: aSelector [

	| method ast |
	
	method := objectClass superclass lookupSelector: aSelector.
	
	ast := RBParser parseMethod: method methodClass name , '_' , method sourceCode.

	method := self visitMethodNode: ast.

	lookupClass compile: method formattedCode.

	^ method selector
]
