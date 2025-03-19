Class {
	#name : 'ScpDefaultAssignmentReification',
	#superclass : 'ScpDefaultReification',
	#category : 'Scopeo-Method-Instrumentation-Indirections',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Indirections'
}

{ #category : 'private - reification' }
ScpDefaultAssignmentReification >> generateForNode: anASTProgramNode [

	^ RBBlockNode body: (
		RBSequenceNode statements: { 
			RBAssignmentNode
				variable: anASTProgramNode variable
				value: (self instrumenter visitNode: anASTProgramNode value) 
		}
	)
]
