Class {
	#name : #ScpInstrumentationRBVisitor,
	#superclass : #RBProgramNodeVisitor,
	#instVars : [
		'indirection',
		'currentMethod'
	],
	#category : #'Scopeo-Instrumentation'
}

{ #category : #testing }
ScpInstrumentationRBVisitor class >> isAbstract [

	^ self == RBProgramNodeVisitor
]

{ #category : #accessing }
ScpInstrumentationRBVisitor >> indirectionIdentifier: anIdentifier [

	indirection := RBMessageNode
		               receiver: (RBMessageNode
				                receiver:
				                (RBVariableNode named: #ScpInstrumentationRegistry)
				                selector: #instance)
		               selector: #at:
		               arguments:
		               { (RBLiteralValueNode value: anIdentifier) }
]

{ #category : #API }
ScpInstrumentationRBVisitor >> visit: aRBMessageNode [
	^ aRBMessageNode acceptVisitor: self
]

{ #category : #visiting }
ScpInstrumentationRBVisitor >> visitArrayNode: anArrayNode [

	^ anArrayNode 
		statements: (anArrayNode children collect: [ :each | self visitNode: each ]);
		yourself
]

{ #category : #visiting }
ScpInstrumentationRBVisitor >> visitAssignmentNode: anAssignmentNode [

	anAssignmentNode
		variable: (self visitNode: anAssignmentNode variable);
		value: (self visitNode: anAssignmentNode value).

	anAssignmentNode variable isInstanceVariable ifFalse: [
		^ anAssignmentNode ].

	^ RBMessageNode
		  receiver: indirection
		  selector: #assignment:variable:object:value:
		  arguments: {
				  (RBBlockNode body:
					   (RBSequenceNode statements: { anAssignmentNode })).
					anAssignmentNode value.
				  (RBLiteralValueNode value: anAssignmentNode variable name).
				  (RBVariableNode named: #self)
				   }
]

{ #category : #visiting }
ScpInstrumentationRBVisitor >> visitBlockNode: aBlockNode [

	^ aBlockNode arguments:( self visitArgumentNodes: aBlockNode arguments);
		body: (self visitNode: aBlockNode body);
		yourself
]

{ #category : #visiting }
ScpInstrumentationRBVisitor >> visitCascadeNode: aCascadeNode [

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

{ #category : #visiting }
ScpInstrumentationRBVisitor >> visitEnglobingErrorNode: anEnglobingErrorNode [

	^ anEnglobingErrorNode
		  contents: (anEnglobingErrorNode contents collect: [ :each | self visitNode: each ]);
		  yourself
]

{ #category : #visiting }
ScpInstrumentationRBVisitor >> visitLiteralArrayNode: aRBLiteralArrayNode [

	^ aRBLiteralArrayNode 
		contents: (aRBLiteralArrayNode contents collect: [ :each | self visitNode: each ]);
		yourself
]

{ #category : #visiting }
ScpInstrumentationRBVisitor >> visitLiteralNode: aLiteralNode [

	^ aLiteralNode
]

{ #category : #visiting }
ScpInstrumentationRBVisitor >> visitMessageNode: aMessageNode [

	| receiver |
	receiver := aMessageNode receiver.

	aMessageNode
		receiver: (self visitNode: aMessageNode receiver copy);
		selector: (self visitNode: aMessageNode selectorNode);
		arguments:
			(aMessageNode arguments collect: [ :each | self visitNode: each ]).

	receiver isBlock ifTrue: [ ^ aMessageNode ].
	receiver isSuperVariable ifTrue: [
		^ RBMessageNode
			  receiver: indirection
			  selector: #superMessage:from:with:in:
			  arguments: {
					  (RBLiteralValueNode value: aMessageNode selector).
					  RBVariableNode selfNode.
					  (RBArrayNode statements: aMessageNode arguments).
					  (RBVariableNode named: currentMethod methodClass asString) } ].

	^ RBMessageNode
		  receiver: indirection
		  selector: #message:from:to:with:
		  arguments: {
				  (RBLiteralValueNode value: aMessageNode selector).
				  RBVariableNode selfNode.
				  aMessageNode receiver.
				  (RBArrayNode statements: aMessageNode arguments) }
]

{ #category : #visiting }
ScpInstrumentationRBVisitor >> visitMethodNode: aMethodNode [

	| sender |
	
	currentMethod := aMethodNode compilationContext compiledMethod.
	
	aMethodNode arguments:
		(self visitArgumentNodes: aMethodNode arguments).
	aMethodNode pragmas:
		(aMethodNode pragmas collect: [ :each | self visitNode: each ]).
	aMethodNode body: (self visitNode: aMethodNode body).

	sender := RBMessageNode
		          receiver: (RBMessageNode
				           receiver: (RBVariableNode named: #thisContext)
				           selector: #sender)
		          selector: #receiver.

	aMethodNode body addNodeFirst: (RBMessageNode
			 receiver: indirection
			 selector: #method:from:to:with:
			 arguments: {
					 (RBLiteralValueNode value: aMethodNode selector).
					 sender.
					 RBVariableNode selfNode.
					 (RBArrayNode statements: aMethodNode arguments) }).

	aMethodNode lastIsReturn ifFalse: [
		aMethodNode body addNodeLast: (RBReturnNode value: (RBMessageNode
					  receiver: indirection
					  selector: #methodReturn:to:
					  arguments: {
							  RBVariableNode selfNode.
							  sender })) ].

	^ aMethodNode
]

{ #category : #visiting }
ScpInstrumentationRBVisitor >> visitParseErrorNode: anErrorNode [

	^ anErrorNode
]

{ #category : #visiting }
ScpInstrumentationRBVisitor >> visitPatternBlockNode: aRBPatternBlockNode [

	^ aRBPatternBlockNode
		arguments: (self visitArgumentNodes: aRBPatternBlockNode arguments);
		body: (self visitNode: aRBPatternBlockNode body);
		yourself
]

{ #category : #visiting }
ScpInstrumentationRBVisitor >> visitPatternWrapperBlockNode: aRBPatternWrapperBlockNode [

	^ aRBPatternWrapperBlockNode
		  wrappedNode: (self visitNode: aRBPatternWrapperBlockNode wrappedNode);
		  arguments: (self visitArgumentNodes: aRBPatternWrapperBlockNode arguments);
		  body: (self visitNode: aRBPatternWrapperBlockNode body);
		  yourself
]

{ #category : #visiting }
ScpInstrumentationRBVisitor >> visitPragmaNode: aPragmaNode [

	^ aPragmaNode 
		arguments: (aPragmaNode arguments do: [ :each | self visitNode: each ]);
		yourself
]

{ #category : #visiting }
ScpInstrumentationRBVisitor >> visitReturnNode: aReturnNode [

	^ aReturnNode value: (RBMessageNode
			   receiver: indirection
			   selector: #methodReturn:to:
			   arguments: { (self visitNode: aReturnNode value) . (RBMessageNode
						  receiver: (RBMessageNode
								   receiver: (RBVariableNode thisContextNode)
								   selector: #sender)
						  selector: #receiver) })
]

{ #category : #visiting }
ScpInstrumentationRBVisitor >> visitSelectorNode: aSelectorNode [

	^ aSelectorNode
]

{ #category : #visiting }
ScpInstrumentationRBVisitor >> visitSequenceNode: aSequenceNode [

	^ aSequenceNode
		  temporaries: (self visitTemporaryNodes: aSequenceNode temporaries);
		  statements: (aSequenceNode statements collect: [ :each | self visitNode: each ]);
		  yourself
]
