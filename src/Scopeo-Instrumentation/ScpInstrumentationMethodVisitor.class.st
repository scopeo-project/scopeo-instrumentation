Class {
	#name : 'ScpInstrumentationMethodVisitor',
	#superclass : 'RBProgramNodeVisitor',
	#instVars : [
		'indirection',
		'currentMethod',
		'nodeIdentifierSuffix',
		'nodeIdentifierIndex'
	],
	#category : 'Scopeo-Instrumentation',
	#package : 'Scopeo-Instrumentation'
}

{ #category : 'as yet unclassified' }
ScpInstrumentationMethodVisitor class >> isAbstract [

	^ self == RBProgramNodeVisitor
]

{ #category : 'private' }
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

{ #category : 'private' }
ScpInstrumentationMethodVisitor >> nodeIdentifier [

	nodeIdentifierIndex := nodeIdentifierIndex + 1.
	^ RBLiteralValueNode value: nodeIdentifierIndex
]

{ #category : 'private' }
ScpInstrumentationMethodVisitor >> nodeIndirection [

	^ indirection
]

{ #category : 'private' }
ScpInstrumentationMethodVisitor >> nodeSender [

	^ RBMessageNode
		          receiver: (RBMessageNode
				           receiver: (RBVariableNode thisContextNode)
				           selector: #sender)
		          selector: #receiver
]

{ #category : 'visiting' }
ScpInstrumentationMethodVisitor >> visitArrayNode: anArrayNode [

	^ anArrayNode 
		statements: (anArrayNode children collect: [ :each | self visitNode: each ]);
		yourself
]

{ #category : 'visiting' }
ScpInstrumentationMethodVisitor >> visitAssignmentNode: anAssignmentNode [

	anAssignmentNode variable isInstanceVariable ifFalse: [ ^ anAssignmentNode ].

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
				  (self visitNode: anAssignmentNode value) }
]

{ #category : 'visiting' }
ScpInstrumentationMethodVisitor >> visitBlockNode: aBlockNode [

	^ aBlockNode arguments:( self visitArgumentNodes: aBlockNode arguments);
		body: (self visitNode: aBlockNode body);
		yourself
]

{ #category : 'visiting' }
ScpInstrumentationMethodVisitor >> visitCascadeNode: aCascadeNode [

	| receiverNode receiverNodeVariable statements |

	receiverNode := aCascadeNode receiver.
	receiverNodeVariable := RBVariableNode named: #receiver.

	statements := OrderedCollection new.
	statements add: ((RBAssignmentNode variable: receiverNodeVariable value: receiverNode) acceptVisitor: self).
	
	statements addAll: (aCascadeNode messages collect: [ :m | m receiver: receiverNodeVariable ]).
	statements := statements collect: [ :s | s acceptVisitor: self ].

	^ RBMessageNode
		  receiver: (RBBlockNode body: (RBSequenceNode
					    temporaries: { receiverNodeVariable }
					    statements: statements))
		  selector: #value
]

{ #category : 'visiting' }
ScpInstrumentationMethodVisitor >> visitEnglobingErrorNode: anEnglobingErrorNode [

	^ anEnglobingErrorNode
		  contents: (anEnglobingErrorNode contents collect: [ :each | self visitNode: each ]);
		  yourself
]

{ #category : 'visiting' }
ScpInstrumentationMethodVisitor >> visitLiteralArrayNode: aRBLiteralArrayNode [

	^ aRBLiteralArrayNode 
		contents: (aRBLiteralArrayNode contents collect: [ :each | self visitNode: each ]);
		yourself
]

{ #category : 'visiting' }
ScpInstrumentationMethodVisitor >> visitLiteralNode: aLiteralNode [

	^ aLiteralNode
]

{ #category : 'visiting' }
ScpInstrumentationMethodVisitor >> visitMessageNode: aMessageNode [

	aMessageNode receiver isSuperVariable ifTrue: [
		^ self visitSuperMessage: aMessageNode
	].
	aMessageNode receiver isBlock ifTrue: [ 
		^ aMessageNode
			receiver: (self visitNode: aMessageNode receiver copy);
			selector: (self visitNode: aMessageNode selectorNode);
			arguments: (aMessageNode arguments collect: [ :each | self visitNode: each ]).
	].
	^ RBMessageNode
		  receiver: self nodeIndirection
		  selector: (ScpInstrumentation >> #node:message:sender:receiver:arguments:) selector
		  arguments: {
		   		  self nodeIdentifier.
				  (RBLiteralValueNode value: aMessageNode selector).
				  RBVariableNode selfNode.
				  self visitNode: aMessageNode receiver.
				  (RBArrayNode statements: (aMessageNode arguments collect: [ :each | self visitNode: each ])) }
]

{ #category : 'visiting' }
ScpInstrumentationMethodVisitor >> visitMethod: aMethod [

	nodeIdentifierIndex := 0.

	^ self visit: aMethod ast copy.
]

{ #category : 'visiting' }
ScpInstrumentationMethodVisitor >> visitMethodNode: aMethodNode [

	currentMethod := aMethodNode compiledMethod.

	aMethodNode arguments: (self visitArgumentNodes: aMethodNode arguments).
	aMethodNode pragmas: (aMethodNode pragmas collect: [ :each | self visitNode: each ]).
	aMethodNode body: (self visitNode: aMethodNode body).

	aMethodNode body addNodeFirst: (RBMessageNode
		receiver: self nodeIndirection 
		selector: (ScpInstrumentation >> #method:sender:receiver:arguments:) selector
		arguments: {
			(RBLiteralValueNode value: aMethodNode selector).
			self nodeSender.
			RBVariableNode selfNode.
			(RBArrayNode statements: aMethodNode arguments) 
		}).

	aMethodNode lastIsReturn ifFalse: [
		aMethodNode body addNodeLast: (RBReturnNode value: (RBMessageNode
			receiver: self nodeIndirection
			selector: (ScpInstrumentation >> #node:return:sender:) selector
			arguments: {
				self nodeIdentifier.
				RBVariableNode selfNode.
				self nodeSender 
			})
	)].

	^ aMethodNode
]

{ #category : 'visiting' }
ScpInstrumentationMethodVisitor >> visitParseErrorNode: anErrorNode [

	^ anErrorNode
]

{ #category : 'visiting' }
ScpInstrumentationMethodVisitor >> visitPatternBlockNode: aRBPatternBlockNode [

	^ aRBPatternBlockNode
		arguments: (self visitArgumentNodes: aRBPatternBlockNode arguments);
		body: (self visitNode: aRBPatternBlockNode body);
		yourself
]

{ #category : 'visiting' }
ScpInstrumentationMethodVisitor >> visitPatternWrapperBlockNode: aRBPatternWrapperBlockNode [

	^ aRBPatternWrapperBlockNode
		  wrappedNode: (self visitNode: aRBPatternWrapperBlockNode wrappedNode);
		  arguments: (self visitArgumentNodes: aRBPatternWrapperBlockNode arguments);
		  body: (self visitNode: aRBPatternWrapperBlockNode body);
		  yourself
]

{ #category : 'visiting' }
ScpInstrumentationMethodVisitor >> visitPragmaNode: aPragmaNode [

	^ aPragmaNode 
		arguments: (aPragmaNode arguments do: [ :each | self visitNode: each ]);
		yourself
]

{ #category : 'visiting' }
ScpInstrumentationMethodVisitor >> visitReturnNode: aReturnNode [

	^ aReturnNode value: (RBMessageNode
			   receiver: self nodeIndirection
			   selector: #node:return:sender:
			   arguments: { 
					self nodeIdentifier.
					(self visitNode: aReturnNode value) . 
					self nodeSender})
]

{ #category : 'visiting' }
ScpInstrumentationMethodVisitor >> visitSelectorNode: aSelectorNode [

	^ aSelectorNode
]

{ #category : 'visiting' }
ScpInstrumentationMethodVisitor >> visitSequenceNode: aSequenceNode [

	^ aSequenceNode
		  temporaries: (self visitTemporaryNodes: aSequenceNode temporaries);
		  statements: (aSequenceNode statements collect: [ :each | self visitNode: each ]);
		  yourself
]

{ #category : 'visiting' }
ScpInstrumentationMethodVisitor >> visitSuperMessage: aMessageNode [

	^ RBMessageNode
			  receiver: self nodeIndirection
           selector: (ScpInstrumentation >> #node:super:sender:arguments:class:) selector
			  arguments: {
						self nodeIdentifier.
					  (RBLiteralValueNode value: aMessageNode selector).
					  RBVariableNode selfNode.
					  (RBArrayNode statements: (aMessageNode arguments collect: [ :each | self visitNode: each ])).
					  (RBVariableNode named: currentMethod methodClass asString) 
			  }
]
