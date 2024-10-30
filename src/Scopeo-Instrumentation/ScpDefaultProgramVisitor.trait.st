Trait {
	#name : 'ScpDefaultProgramVisitor',
	#category : 'Scopeo-Instrumentation',
	#package : 'Scopeo-Instrumentation'
}

{ #category : 'API' }
ScpDefaultProgramVisitor >> visit: aRBMessageNode [

	^ aRBMessageNode acceptVisitor: self
]

{ #category : 'visiting' }
ScpDefaultProgramVisitor >> visitAnnotationMarkNode: aRBAnnotationValueNode [
]

{ #category : 'visiting' }
ScpDefaultProgramVisitor >> visitArgumentNode: anArgumentNode [
	"Sent *each time* an argument node is found"

	^ self visitVariableNode: anArgumentNode
]

{ #category : 'visiting' }
ScpDefaultProgramVisitor >> visitArgumentNodes: aNodeCollection [
	"Sent *once* when visiting method and block nodes"

	^ aNodeCollection do: [ :each | self visitArgumentNode: each ]
]

{ #category : 'visiting - variables' }
ScpDefaultProgramVisitor >> visitArgumentVariableNode: anArgumentNode [

	^ self visitLocalVariableNode: anArgumentNode
]

{ #category : 'visiting' }
ScpDefaultProgramVisitor >> visitArrayNode: anArrayNode [

	anArrayNode children do: [ :each | self visitNode: each ]
]

{ #category : 'visiting' }
ScpDefaultProgramVisitor >> visitAssignmentNode: anAssignmentNode [

	self visitNode: anAssignmentNode variable.
	self visitNode: anAssignmentNode value
]

{ #category : 'visiting' }
ScpDefaultProgramVisitor >> visitBlockNode: aBlockNode [

	self visitArgumentNodes: aBlockNode arguments.
	self visitNode: aBlockNode body
]

{ #category : 'visiting' }
ScpDefaultProgramVisitor >> visitCascadeNode: aCascadeNode [

	aCascadeNode messages do: [ :each | self visitNode: each ]
]

{ #category : 'visiting - variables' }
ScpDefaultProgramVisitor >> visitClassVariableNode: aNode [

	^ self visitLiteralVariableNode: aNode
]

{ #category : 'visiting' }
ScpDefaultProgramVisitor >> visitCommentNode: aRBComment [
	"Note: currenlty, comment nodes are not automatically visited by `RBProgramNodeVisitor`.
	This method can still be reached by custom visitors and direct visit on a comment node."
]

{ #category : 'visiting' }
ScpDefaultProgramVisitor >> visitEnglobingErrorNode: anEnglobingErrorNode [

	anEnglobingErrorNode contents do: [ :each | self visitNode: each ]
]

{ #category : 'visiting' }
ScpDefaultProgramVisitor >> visitGlobalNode: aSelfNode [

	^ self visitVariableNode: aSelfNode
]

{ #category : 'visiting - variables' }
ScpDefaultProgramVisitor >> visitGlobalVariableNode: aNode [

	^ self visitLiteralVariableNode: aNode
]

{ #category : 'visiting' }
ScpDefaultProgramVisitor >> visitInstanceVariableNode: aSelfNode [

	^ self visitVariableNode: aSelfNode
]

{ #category : 'visiting' }
ScpDefaultProgramVisitor >> visitLiteralArrayNode: aRBLiteralArrayNode [

	aRBLiteralArrayNode contents do: [ :each | self visitNode: each ]
]

{ #category : 'visiting' }
ScpDefaultProgramVisitor >> visitLiteralNode: aLiteralNode [
]

{ #category : 'visiting' }
ScpDefaultProgramVisitor >> visitLiteralValueNode: aRBLiteralValueNode [
	"Redirect the message by default to #visitLiteralNode: for retrocompatibility (pharo 8)"

	^ self visitLiteralNode: aRBLiteralValueNode
]

{ #category : 'visiting - variables' }
ScpDefaultProgramVisitor >> visitLiteralVariableNode: aNode [
	"to be backward compatible, we visit for Gloabls here (there used to be no difference)"

	^ self visitGlobalNode: aNode
]

{ #category : 'visiting' }
ScpDefaultProgramVisitor >> visitLocalVariableNode: aNode [
	"call visitTemporaryNode: for backward compatibility"
	
	^ self visitTemporaryNode: aNode
]

{ #category : 'visiting' }
ScpDefaultProgramVisitor >> visitMessageNode: aMessageNode [

	(aMessageNode isCascaded not or: [ aMessageNode isFirstCascaded ]) ifTrue: [ 
		self visitNode: aMessageNode receiver 
	].

	self visitNode: aMessageNode selectorNode.

	aMessageNode arguments do: [ :each | self visitNode: each ]
]

{ #category : 'visiting' }
ScpDefaultProgramVisitor >> visitMethodNode: aMethodNode [

	self visitArgumentNodes: aMethodNode arguments.
	self visitPragmaNodes: aMethodNode pragmas.
	self visitNode: aMethodNode body
]

{ #category : 'visiting' }
ScpDefaultProgramVisitor >> visitNode: aNode [

	^ aNode acceptVisitor: self
]

{ #category : 'visiting' }
ScpDefaultProgramVisitor >> visitParseErrorNode: anErrorNode [
]

{ #category : 'visiting' }
ScpDefaultProgramVisitor >> visitPatternBlockNode: aRBPatternBlockNode [

	self visitArgumentNodes: aRBPatternBlockNode arguments.
	self visitNode: aRBPatternBlockNode body
]

{ #category : 'visiting' }
ScpDefaultProgramVisitor >> visitPatternWrapperBlockNode: aRBPatternWrapperBlockNode [

	self visitNode: aRBPatternWrapperBlockNode wrappedNode.
	self visitArgumentNodes: aRBPatternWrapperBlockNode arguments.
	self visitNode: aRBPatternWrapperBlockNode body
]

{ #category : 'visiting' }
ScpDefaultProgramVisitor >> visitPragmaNode: aPragmaNode [

	aPragmaNode arguments do: [ :each | self visitNode: each ]
]

{ #category : 'visiting' }
ScpDefaultProgramVisitor >> visitPragmaNodes: aNodeCollection [
	"Sent *once* when visiting a method node"
	
	^ aNodeCollection do: [ :each | self visitPragmaNode: each ].
]

{ #category : 'visiting' }
ScpDefaultProgramVisitor >> visitReturnNode: aReturnNode [

	^ self visitNode: aReturnNode value
]

{ #category : 'visiting' }
ScpDefaultProgramVisitor >> visitSelectorNode: aSelectorNode [
]

{ #category : 'visiting' }
ScpDefaultProgramVisitor >> visitSelfNode: aSelfNode [

	^ self visitVariableNode: aSelfNode
]

{ #category : 'visiting' }
ScpDefaultProgramVisitor >> visitSequenceNode: aSequenceNode [
	self visitTemporaryNodes: aSequenceNode temporaries.
	aSequenceNode statements do: [ :each | self visitNode: each ]
]

{ #category : 'visiting' }
ScpDefaultProgramVisitor >> visitSuperNode: aSuperNode [

	^ self visitVariableNode: aSuperNode
]

{ #category : 'visiting' }
ScpDefaultProgramVisitor >> visitTemporaryDeclarationNode: aTemporaryDeclarationNode [
	"| temp |
	temp is a temporary node as we can find in the body of methods, but it can't be visited the same way.
	Redirect the message on argumentNodeVisitor as a way to keep retrocompatibility"

	^ self visitArgumentNode: aTemporaryDeclarationNode
]

{ #category : 'visiting' }
ScpDefaultProgramVisitor >> visitTemporaryNode: aNode [
	"Sent *each time* a temporary node is found"

	^ self visitVariableNode: aNode
]

{ #category : 'visiting' }
ScpDefaultProgramVisitor >> visitTemporaryNodes: aNodeCollection [
	"This is triggered when defining the temporaries between the pipes"

	^ aNodeCollection do: [ :each | self visitTemporaryDeclarationNode: each ]
]

{ #category : 'visiting - variables' }
ScpDefaultProgramVisitor >> visitTemporaryVariableNode: aNode [

	^ self visitLocalVariableNode: aNode
]

{ #category : 'visiting' }
ScpDefaultProgramVisitor >> visitThisContextNode: aThisContextNode [

	^ self visitVariableNode: aThisContextNode
]

{ #category : 'visiting' }
ScpDefaultProgramVisitor >> visitVariableNode: aVariableNode [

	^ aVariableNode
]
