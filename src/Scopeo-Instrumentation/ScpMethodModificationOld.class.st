Class {
	#name : #ScpMethodModificationOld,
	#superclass : #RBProgramNodeVisitor,
	#traits : 'MethodModification',
	#classTraits : 'MethodModification classTrait',
	#instVars : [
		'installationClass'
	],
	#category : #'Scopeo-Instrumentation'
}

{ #category : #applying }
ScpMethodModificationOld >> applyOn: aMethodNode [

	self visitMethodNode: aMethodNode 
]

{ #category : #accessing }
ScpMethodModificationOld >> installationClass: aClass [

	installationClass := aClass
]

{ #category : #'private - constants' }
ScpMethodModificationOld >> nodeForInstrumentationHandler [

	^ RBVariableNode named: self class handlerSymbol
]

{ #category : #'private - constants' }
ScpMethodModificationOld >> nodeForRewritingTempVariable [

	^ RBVariableNode named: #_tmp
]

{ #category : #'as yet unclassified' }
ScpMethodModificationOld >> nodeForSender [

	 ^ self subclassResponsibility
]

{ #category : #visiting }
ScpMethodModificationOld >> visitAssignmentNode: anAssignmentNode [
	"
	Visit the value of the assignement and rewrite the assigment if it modifies an instance variable, rewrite it in the following form:	
	Original:
	```
	instVar := aValue.
	```
	Rewritten:
	```
	_tmp := aValue.
	hook assignment: instVar value: _tmp. 
	instVar := _tmp
	```
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
			RBVariableNode selfNode.
			self nodeForRewritingTempVariable 
		}).
	statements add: (RBAssignmentNode variable: anAssignmentNode variable value: self nodeForRewritingTempVariable).

	^ statements
]

{ #category : #visiting }
ScpMethodModificationOld >> visitMessageNode: aMessageNode [
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
			selector: (self visitMessageToSuperNode: aMessageNode);
			yourself
	].	
	
	aMessageNode receiver isSelfVariable ifTrue: [ 
		aMessageNode receiver: (self visitVariableNode: RBVariableNode selfNode)
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
ScpMethodModificationOld >> visitMessageToSuperNode: aMessageNode [
	"
	Retrieve the method that is going to be executed when using the variable super (the super method).
	Change the name of the super method to identify it using its original class name.
	And rewrite the super method the same way as the currently rewritten method.
	Reuses the ScpMethodRewriter>>#rewrite: method to ensure the process is recursive.
	Restore the currently rewritten method once the super method has been rewritten. 
	"
	| method alias superMethod |	
	
	method := aMessageNode methodNode compiledMethod.
	superMethod := method methodClass superclass lookupSelector: aMessageNode selector.
	
	alias := (superMethod methodClass name copyReplaceAll:  ' ' with:  '_') , '_' , superMethod selector.
	(installationClass includesSelector: alias) ifFalse: [
		superMethod 
			applyModification: (ScpClassSuperModification new 
					newSelector: alias; 
					yourself) 
			andInstallIn: installationClass
	]. 
		
	^ alias
]

{ #category : #visiting }
ScpMethodModificationOld >> visitMethodNode: aMethodNode [

	aMethodNode body addSelfReturn.
	self visitNode: aMethodNode body.

	aMethodNode body addNodeFirst: (RBMessageNode
			 receiver: self nodeForInstrumentationHandler
			 selector:
				 (ScpInstrumentationHandler >> #message:sender:receiver:arguments:)
					 selector
			 arguments: {
					 (RBLiteralValueNode value: aMethodNode selector).
					 self nodeForSender.
					 RBVariableNode selfNode.
					 (RBArrayNode statements: aMethodNode arguments) 
			}).

	aMethodNode body addNodeLast: (RBMessageNode
			 receiver: self nodeForInstrumentationHandler
			 selector: #enable)
]

{ #category : #visiting }
ScpMethodModificationOld >> visitReturnNode: aReturnNode [
	"
	Rewrite a return node if it returns the variable self and replace it by a reference to the proxy of the instrumentation.
	Also adds a call to the instrumentation handler of Scopeo.
	
	Original:
	```
	^ self
	```
	Rewritten:
	```
	_tmp := _proxy.
	hook return: _tmp. 
	^ _tmp
	```
	"
	| statements |
	self visitNode: aReturnNode value.
	
	(aReturnNode value isVariable) ifTrue: [ 
		aReturnNode value: (self visitVariableNode: aReturnNode value)
	].

	statements := OrderedCollection new.
	statements add: (RBAssignmentNode 
		variable: self nodeForRewritingTempVariable
		value: aReturnNode value
	).
	
	aReturnNode value: self nodeForRewritingTempVariable.

	statements add: (RBMessageNode
		  receiver: self nodeForInstrumentationHandler 
		  selector: (ScpInstrumentationHandler >> #return:) selector
		  arguments: { aReturnNode value }).
		
	statements add: aReturnNode.
	
	^ statements 
]

{ #category : #visiting }
ScpMethodModificationOld >> visitSequenceNode: aSequenceNode [
	"
	Rewrites a sequence node by visiting children nodes and replacing each of them by the result of their visit.
	These results can either be collections of statements or child nodes themselves.
	
	If the sequence node is not the body of a block, add a temporary variable to enable assigment rewriting. 
	"
	| oldStatements newStatements |

	aSequenceNode parent isBlock ifFalse: [  
		aSequenceNode addTemporaryNamed: self nodeForRewritingTempVariable name.
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
ScpMethodModificationOld >> visitVariableNode: aVariableNode [

	^ aVariableNode
	
]
