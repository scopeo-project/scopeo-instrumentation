Class {
	#name : 'ScpInstrumentationNodeFinder',
	#superclass : 'RBProgramNodeVisitor',
	#instVars : [
		'indirection',
		'currentMethod',
		'nodeIdentifierSuffix',
		'nodeIdentifierIndex',
		'node',
		'seekedNodeId',
		'identifier',
		'seekedIdentifier'
	],
	#category : 'Scopeo-Instrumentation',
	#package : 'Scopeo-Instrumentation'
}

{ #category : 'accessing' }
ScpInstrumentationNodeFinder class >> findNode: aNodeId [

	| parts method |
	parts := aNodeId splitOn: '-'.
	method := self compiler evaluate: parts first.
	^ self new find: aNodeId in: method.
]

{ #category : 'private' }
ScpInstrumentationNodeFinder >> check: aNode [

	identifier := identifier + 1.
	identifier = seekedIdentifier ifFalse: [ ^ self ].
	node := aNode
]

{ #category : 'accessing' }
ScpInstrumentationNodeFinder >> find: anIdentifier in: aMethod [
	
	identifier := 0.
	seekedIdentifier := anIdentifier.
	
	self visit: aMethod ast copy.
	
	^ node
]

{ #category : 'visiting' }
ScpInstrumentationNodeFinder >> visitAssignmentNode: anAssignmentNode [

	anAssignmentNode variable isInstanceVariable ifFalse: [ ^ anAssignmentNode ].
	self check: anAssignmentNode.

	self visitNode: anAssignmentNode variable.
	self visitNode: anAssignmentNode value
]

{ #category : 'visiting' }
ScpInstrumentationNodeFinder >> visitMessageNode: aMessageNode [

	aMessageNode receiver isBlock ifFalse: [ 
			self check: aMessageNode
	].

	self visitNode: aMessageNode receiver.
	self visitNode: aMessageNode selectorNode.
	aMessageNode arguments do: [ :each | self visitNode: each ]
	

	
]

{ #category : 'visiting' }
ScpInstrumentationNodeFinder >> visitMethodNode: aMethodNode [

	"self checkNode: aMethodNode."

	self visitArgumentNodes: aMethodNode arguments.
	self visitPragmaNodes: aMethodNode pragmas.
	self visitNode: aMethodNode body
]

{ #category : 'visiting' }
ScpInstrumentationNodeFinder >> visitReturnNode: aReturnNode [
	
	self check: aReturnNode.
		
	self visitNode: aReturnNode value
]
