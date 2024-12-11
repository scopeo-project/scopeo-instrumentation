Class {
	#name : 'ScpASTAnnotationVisitor',
	#superclass : 'RBProgramNodeVisitor',
	#instVars : [
		'currentMethod'
	],
	#classInstVars : [
		'instance'
	],
	#category : 'Scopeo-Instrumentation',
	#package : 'Scopeo-Instrumentation'
}

{ #category : 'as yet unclassified' }
ScpASTAnnotationVisitor class >> instance [

	^ instance ifNil: [ instance := self new ]
]

{ #category : 'accessing' }
ScpASTAnnotationVisitor class >> transform: aMethod [

	 ^ self new visitMethod: aMethod
]

{ #category : 'visiting' }
ScpASTAnnotationVisitor >> visitAssignmentNode: anAssignmentNode [

	ScpASTDictionary instance at: currentMethod ifPresent: [ :m |
		m
			at: anAssignmentNode
			ifPresent: [ :node | anAssignmentNode beScopeoNodeFor: node ] ].
		
	super visitAssignmentNode: anAssignmentNode 
]

{ #category : 'visiting' }
ScpASTAnnotationVisitor >> visitCascadeNode: aCascadeNode [

	ScpASTDictionary instance at: currentMethod ifPresent: [ :m |
		m
			at: aCascadeNode
			ifPresent: [ :node | aCascadeNode beScopeoNodeFor: node ] ].

	super visitCascadeNode: aCascadeNode
]

{ #category : 'visiting' }
ScpASTAnnotationVisitor >> visitMessageNode: aMessageNode [

	ScpASTDictionary instance at: currentMethod ifPresent: [ :m |
		m
			at: aMessageNode
			ifPresent: [ :node | aMessageNode beScopeoNodeFor: node ] ].

	super visitMessageNode: aMessageNode
]

{ #category : 'visiting' }
ScpASTAnnotationVisitor >> visitMethodNode: aMethodNode [

	currentMethod := aMethodNode compiledMethod propertyAt: #sourceMethod.
	super visitMethodNode: aMethodNode
]

{ #category : 'visiting' }
ScpASTAnnotationVisitor >> visitReturnNode: aReturnNode [

	ScpASTDictionary instance at: currentMethod ifPresent: [ :m |
		m
			at: aReturnNode value
			ifPresent: [ :node | aReturnNode value beScopeoNodeFor: node ] ].

	super visitReturnNode: aReturnNode
]

{ #category : 'visiting' }
ScpASTAnnotationVisitor >> visitSequenceNode: aSequenceNode [

	aSequenceNode statements do: [ :s | 
		self visitNode: s.
	].

	^ aSequenceNode
]
