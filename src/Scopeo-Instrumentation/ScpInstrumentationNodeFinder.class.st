Class {
	#name : 'ScpInstrumentationNodeFinder',
	#superclass : 'RBProgramNodeVisitor',
	#instVars : [
		'indirection',
		'currentMethod',
		'nodeIdentifierSuffix',
		'nodeIdentifierIndex',
		'node',
		'seekedNodeId'
	],
	#category : 'Scopeo-Instrumentation',
	#package : 'Scopeo-Instrumentation'
}

{ #category : 'accessing' }
ScpInstrumentationNodeFinder class >> findNode: aNodeId [

	| parts method |
	parts := aNodeId splitOn: '-'.
	method := self compiler evaluate: parts first.
	^ self new findNode: aNodeId inMethod: method.
]

{ #category : 'private' }
ScpInstrumentationNodeFinder >> checkNode: aNode [

	self nodeIdentifier = seekedNodeId ifFalse: [ ^ self ].
	node := aNode
]

{ #category : 'accessing' }
ScpInstrumentationNodeFinder >> findNode: aNodeId inMethod: aMethod [

	seekedNodeId := aNodeId.
	
	nodeIdentifierIndex := 0.
	nodeIdentifierSuffix := aMethod name , '-'.
	
	self visit: aMethod ast copy.
	
	^ node
]

{ #category : 'private' }
ScpInstrumentationNodeFinder >> nodeIdentifier [

	nodeIdentifierIndex := nodeIdentifierIndex + 1.
	^ nodeIdentifierSuffix , nodeIdentifierIndex asString
]

{ #category : 'visiting' }
ScpInstrumentationNodeFinder >> visitAssignmentNode: anAssignmentNode [

	self checkNode: anAssignmentNode.

	self visitNode: anAssignmentNode variable.
	self visitNode: anAssignmentNode value
]

{ #category : 'visiting' }
ScpInstrumentationNodeFinder >> visitMessageNode: aMessageNode [

	aMessageNode receiver isBlock ifFalse: [ 
			self checkNode: aMessageNode
	].
	
	(aMessageNode isCascaded not or: [ aMessageNode isFirstCascaded ])
		ifTrue: [ self visitNode: aMessageNode receiver ].
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
	
	self checkNode: aReturnNode.
		
	^ self visitNode: aReturnNode value
]
