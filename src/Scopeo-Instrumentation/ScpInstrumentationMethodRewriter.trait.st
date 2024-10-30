Trait {
	#name : #ScpInstrumentationMethodRewriter,
	#instVars : [
		'method',
		'rewritingClass'
	],
	#category : #'Scopeo-Instrumentation'
}

{ #category : #'private - constants' }
ScpInstrumentationMethodRewriter classSide >> handlerSymbol [

	^ #_handler
]

{ #category : #'private - constants' }
ScpInstrumentationMethodRewriter classSide >> proxySymbol [

	^ #_proxy
]

{ #category : #'private - constants' }
ScpInstrumentationMethodRewriter >> nodeForInstrumentationHandler [

	^ RBVariableNode named: self class handlerSymbol
]

{ #category : #'private - constants' }
ScpInstrumentationMethodRewriter >> nodeForRewritingTempVariable [

	^ RBVariableNode named: #_tmp
]

{ #category : #'private - constants' }
ScpInstrumentationMethodRewriter >> nodeForRewrittenSelfVariable [

	^ RBVariableNode named: self class proxySymbol
]

{ #category : #services }
ScpInstrumentationMethodRewriter >> rewrite: aMethod [

	method := aMethod copy.
	self visitMethodNode: method.
	rewritingClass compile: method formattedCode
]

{ #category : #parameters }
ScpInstrumentationMethodRewriter >> rewritingClass: aClass [

	rewritingClass := aClass.
	
]

{ #category : #visiting }
ScpInstrumentationMethodRewriter >> visitAssignmentNode: anAssignmentNode [
	"
	Visit the value of the assignement and rewrite the assigment if it modifies an instance variable, rewrite it in the following form:	
	Original:

	instVar := aValue.
	
	Rewritten:

	_tmp := aValue.
	hook assignment: instVar value: _tmp. 
	instVar := _tmp	
	"
	| statements |

	self visitNode: anAssignmentNode value.
	
	anAssignmentNode variable isInstanceVariable ifFalse: [ ^ self ].
	statements := OrderedCollection new.

	statements add: (RBAssignmentNode variable: self nodeForRewritingTempVariable value: anAssignmentNode value).
	statements add: (RBMessageNode
		receiver: self nodeForInstrumentationHandler
		selector: (ScpInstrumentationHandler >> #assignment:object:value:) selector
		arguments: {
			(RBLiteralValueNode value: anAssignmentNode variable name).
			self nodeForRewrittenSelfVariable.
			self nodeForRewritingTempVariable 
		}).
	statements add: (RBAssignmentNode variable: anAssignmentNode variable value: self nodeForRewritingTempVariable).

	^ statements
]

{ #category : #visiting }
ScpInstrumentationMethodRewriter >> visitMessageNode: aMessageNode [
	"
	Visit the arguments and the receiver of a message.
	If the receiver is not an block, rewrite it.
	When the receiver is the super variable, rewrite the parent method.
	Otherwise rewrite the receiver to propagate the instrumentation.
	"
	aMessageNode arguments do: [ :each | self visitNode: each ].
	self visitNode: aMessageNode receiver.

	aMessageNode receiver isBlock ifTrue: [ ^ self ].

	aMessageNode isSuperSend ifTrue: [ 
		^ aMessageNode 
			receiver: RBVariableNode selfNode;
			selector: (self visitSuperMethod: aMessageNode selector);
			yourself
	].
	
	aMessageNode receiver isSelfVariable ifTrue: [ 
		^ aMessageNode 
				receiver: self nodeForRewrittenSelfVariable; 
				yourself
	].
	
	aMessageNode receiver: (
		RBMessageNode
		  receiver: aMessageNode receiver 
		  selector: #instrument:
		  arguments: { 
				RBVariableNode named: self class handlerSymbol 
		  }
	)
	
	
	
]

{ #category : #visiting }
ScpInstrumentationMethodRewriter >> visitMethodNode: aMethodNode [

	method body addSelfReturn.
	self visitNode: method body.
]

{ #category : #visiting }
ScpInstrumentationMethodRewriter >> visitReturnNode: aReturnNode [
	"
	Rewrite a return node if it returns the variable self and replace it by a reference to the proxy of the instrumentation.
	"
	self visitNode: aReturnNode value.
	
	aReturnNode value isVariable ifTrue: [ ^ self ]. 
	aReturnNode value name = #self ifTrue: [ ^ self ].
	aReturnNode value: self nodeForRewrittenSelfVariable
]

{ #category : #visiting }
ScpInstrumentationMethodRewriter >> visitSequenceNode: aSequenceNode [
	"
	Rewrites a sequence node by visiting children nodes and replacing each of them by the result of their visit.
	These results can either be collections of statements or child nodes themselves.
	
	If the sequence node is not the body of a block, add a temporary variable to enable assigment rewriting. 
	"
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

{ #category : #visiting }
ScpInstrumentationMethodRewriter >> visitSuperMethod: aSelector [
	"
	Retrieve the method that is going to be executed when using the variable super (the super method).
	Change the name of the super method to identify it using its original class name.
	And rewrite the super method the same way as the currently rewritten method.
	Reuses the ScpMethodRewriter>>#rewrite: method to ensure the process is recursive.
	Restore the currently rewritten method once the super method has been rewritten. 
	"
	| rewrittenMethod superMethod |	

	superMethod := method methodClass superclass lookupSelector: aSelector.
	superMethod selector: superMethod methodClass name , '_' , superMethod selector.
	
	rewrittenMethod	:= method.
	
	self rewrite: superMethod.
	
	method := rewrittenMethod.
	
	^ superMethod selector
]
