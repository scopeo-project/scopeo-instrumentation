Class {
	#name : 'ScpAssignmentContinueReification',
	#superclass : 'ScpContinueReification',
	#category : 'Scopeo-Method-Instrumentation-Indirections',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Indirections'
}

{ #category : 'private - reification' }
ScpAssignmentContinueReification >> generateForNode: anASTProgramNode [

	^ RBBlockNode 
		arguments: { (RBVariableNode named: #v) }
   	   	body: (RBSequenceNode statements: {
			RBAssignmentNode 
				variable: anASTProgramNode variable
				value: (RBVariableNode named: #v) 
		})
]
