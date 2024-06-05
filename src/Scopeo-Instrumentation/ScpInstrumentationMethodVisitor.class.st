Class {
	#name : #ScpInstrumentationMethodVisitor,
	#superclass : #RBProgramNodeVisitor,
	#instVars : [
		'indirection',
		'currentMethod',
		'nodeIdentifierSuffix',
		'nodeIdentifierIndex'
	],
	#category : 'Scopeo-Instrumentation'
}

{ #category : #'as yet unclassified' }
ScpInstrumentationMethodVisitor class >> isAbstract [

	^ self == RBProgramNodeVisitor
]

{ #category : #'as yet unclassified' }
ScpInstrumentationMethodVisitor >> indirectionIdentifier: anIdentifier [

	indirection := RBMessageNode
		               receiver: (RBMessageNode
				                receiver:
				                (RBVariableNode named: #ScpInstrumentationRegistry)
				                selector: #instance)
		               selector: #at:
		               arguments:
		               { (RBLiteralValueNode value: anIdentifier) }
]

{ #category : #private }
ScpInstrumentationMethodVisitor >> nodeIdentifier [

	nodeIdentifierIndex := nodeIdentifierIndex + 1.
	^ RBLiteralValueNode value: (nodeIdentifierSuffix , nodeIdentifierIndex asString)
]

{ #category : #'as yet unclassified' }
ScpInstrumentationMethodVisitor >> nodeIndirection [

	^ indirection
]

{ #category : #'as yet unclassified' }
ScpInstrumentationMethodVisitor >> nodeSender [

	^ RBMessageNode
		          receiver: (RBMessageNode
				           receiver: (RBVariableNode thisContextNode)
				           selector: #sender)
		          selector: #receiver
]

{ #category : #'as yet unclassified' }
ScpInstrumentationMethodVisitor >> visitArrayNode: anArrayNode [

	^ anArrayNode 
		statements: (anArrayNode children collect: [ :each | self visitNode: each ]);
		yourself
]

{ #category : #visiting }
ScpInstrumentationMethodVisitor >> visitAssignmentNode: anAssignmentNode [

	anAssignmentNode
		variable: (self visitNode: anAssignmentNode variable);
		value: (self visitNode: anAssignmentNode value).

	anAssignmentNode variable isInstanceVariable ifFalse: [
		^ anAssignmentNode ].

	^ RBMessageNode
		  receiver: self nodeIndirection
		  selector: (ScpInstrumentation >> #node:assignment:variable:object:value:) selector
		  arguments: {
					self nodeIdentifier.
				  (RBBlockNode
					   arguments: { (RBVariableNode named: #v) }
					   body: (RBSequenceNode statements: { (RBAssignmentNode
								     variable:
								     (RBVariableNode named: anAssignmentNode variable name)
								     value: (RBVariableNode named: #v)) })).
				  (RBLiteralValueNode value: anAssignmentNode variable name).
				  (RBVariableNode selfNode).
				  anAssignmentNode value }
]

{ #category : #'as yet unclassified' }
ScpInstrumentationMethodVisitor >> visitBlockNode: aBlockNode [

	^ aBlockNode arguments:( self visitArgumentNodes: aBlockNode arguments);
		body: (self visitNode: aBlockNode body);
		yourself
]

{ #category : #'as yet unclassified' }
ScpInstrumentationMethodVisitor >> visitCascadeNode: aCascadeNode [

	| receiverNode receiverNodeVariable statements |
	receiverNode := aCascadeNode receiver.
	receiverNodeVariable := RBVariableNode named: #receiver.
	statements := OrderedCollection new.
	statements add:
		(RBAssignmentNode variable: receiverNodeVariable value: receiverNode).
	statements addAll: (aCascadeNode messages collect: [ :m |
			 m receiver: receiverNodeVariable ]).
	statements := statements collect: [ :s | s acceptVisitor: self ].

	^ RBMessageNode
		  receiver: (RBBlockNode body: (RBSequenceNode
					    temporaries: { receiverNodeVariable }
					    statements: statements))
		  selector: #value
]

{ #category : #'as yet unclassified' }
ScpInstrumentationMethodVisitor >> visitEnglobingErrorNode: anEnglobingErrorNode [

	^ anEnglobingErrorNode
		  contents: (anEnglobingErrorNode contents collect: [ :each | self visitNode: each ]);
		  yourself
]

{ #category : #'as yet unclassified' }
ScpInstrumentationMethodVisitor >> visitLiteralArrayNode: aRBLiteralArrayNode [

	^ aRBLiteralArrayNode 
		contents: (aRBLiteralArrayNode contents collect: [ :each | self visitNode: each ]);
		yourself
]

{ #category : #'as yet unclassified' }
ScpInstrumentationMethodVisitor >> visitLiteralNode: aLiteralNode [

	^ aLiteralNode
]

{ #category : #visiting }
ScpInstrumentationMethodVisitor >> visitMessageNode: aMessageNode [

	| receiver |
	receiver := aMessageNode receiver.

	aMessageNode
		receiver: (self visitNode: aMessageNode receiver copy);
		selector: (self visitNode: aMessageNode selectorNode);
		arguments: (aMessageNode arguments collect: [ :each | self visitNode: each ]).

	receiver isBlock ifTrue: [ ^ aMessageNode ].
	receiver isSuperVariable ifTrue: [
		^ RBMessageNode
			  receiver: self nodeIndirection
           selector: (ScpInstrumentation >> #node:super:sender:arguments:class:) selector
			  arguments: {
						self nodeIdentifier.
					  (RBLiteralValueNode value: aMessageNode selector).
					  RBVariableNode selfNode.
					  (RBArrayNode statements: aMessageNode arguments).
					  (RBVariableNode named: currentMethod methodClass asString) } ].

	^ RBMessageNode
		  receiver: self nodeIndirection
		  selector: (ScpInstrumentation >> #node:message:sender:receiver:arguments:) selector
		  arguments: {
		   		  self nodeIdentifier.
				  (RBLiteralValueNode value: aMessageNode selector).
				  RBVariableNode selfNode.
				  aMessageNode receiver.
				  (RBArrayNode statements: aMessageNode arguments) }
]

{ #category : #'as yet unclassified' }
ScpInstrumentationMethodVisitor >> visitMethod: aMethod [

	nodeIdentifierSuffix := aMethod name , '-node'.
	nodeIdentifierIndex := 0.

	^ self visit: aMethod ast copy.
]

{ #category : #visiting }
ScpInstrumentationMethodVisitor >> visitMethodNode: aMethodNode [

	currentMethod := aMethodNode compiledMethod.

	aMethodNode arguments:
		(self visitArgumentNodes: aMethodNode arguments).
	aMethodNode pragmas:
		(aMethodNode pragmas collect: [ :each | self visitNode: each ]).
	aMethodNode body: (self visitNode: aMethodNode body).

	aMethodNode body addNodeFirst: (RBMessageNode
			 receiver: self nodeIndirection 
			 selector: (ScpInstrumentation >> #method:sender:receiver:arguments:) selector
			 arguments: {
					 (RBLiteralValueNode value: aMethodNode selector).
					 self nodeSender.
					 RBVariableNode selfNode.
					 (RBArrayNode statements: aMethodNode arguments) }).

	aMethodNode lastIsReturn ifFalse: [
		aMethodNode body addNodeLast: (RBReturnNode value: (RBMessageNode
					  receiver: self nodeIndirection
					  selector: (ScpInstrumentation >> #node:return:sender:) selector
					  arguments: {
							  self nodeIdentifier.
							  RBVariableNode selfNode.
							  self nodeSender })) ].

	^ aMethodNode
]

{ #category : #'as yet unclassified' }
ScpInstrumentationMethodVisitor >> visitParseErrorNode: anErrorNode [

	^ anErrorNode
]

{ #category : #'as yet unclassified' }
ScpInstrumentationMethodVisitor >> visitPatternBlockNode: aRBPatternBlockNode [

	^ aRBPatternBlockNode
		arguments: (self visitArgumentNodes: aRBPatternBlockNode arguments);
		body: (self visitNode: aRBPatternBlockNode body);
		yourself
]

{ #category : #'as yet unclassified' }
ScpInstrumentationMethodVisitor >> visitPatternWrapperBlockNode: aRBPatternWrapperBlockNode [

	^ aRBPatternWrapperBlockNode
		  wrappedNode: (self visitNode: aRBPatternWrapperBlockNode wrappedNode);
		  arguments: (self visitArgumentNodes: aRBPatternWrapperBlockNode arguments);
		  body: (self visitNode: aRBPatternWrapperBlockNode body);
		  yourself
]

{ #category : #'as yet unclassified' }
ScpInstrumentationMethodVisitor >> visitPragmaNode: aPragmaNode [

	^ aPragmaNode 
		arguments: (aPragmaNode arguments do: [ :each | self visitNode: each ]);
		yourself
]

{ #category : #visiting }
ScpInstrumentationMethodVisitor >> visitReturnNode: aReturnNode [

	^ aReturnNode value: (RBMessageNode
			   receiver: self nodeIndirection
			   selector: #node:return:sender:
			   arguments: { 
					self nodeIdentifier.
					(self visitNode: aReturnNode value) . 
					self nodeSender})
]

{ #category : #'as yet unclassified' }
ScpInstrumentationMethodVisitor >> visitSelectorNode: aSelectorNode [

	^ aSelectorNode
]

{ #category : #'as yet unclassified' }
ScpInstrumentationMethodVisitor >> visitSequenceNode: aSequenceNode [

	^ aSequenceNode
		  temporaries: (self visitTemporaryNodes: aSequenceNode temporaries);
		  statements: (aSequenceNode statements collect: [ :each | self visitNode: each ]);
		  yourself
]
