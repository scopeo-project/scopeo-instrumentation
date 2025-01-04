Class {
	#name : 'ScpAssignmentInstrumentation',
	#superclass : 'ScpNodeInstrumentation',
	#category : 'Scopeo-Method-Instrumentation-Instrumentations',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Instrumentations'
}

{ #category : 'private - services' }
ScpAssignmentInstrumentation >> generateFor: anAssignmentNode usingModifier: aModifier [

	| node cascade |
	node := RBMessageNode new.
	node receiver: handlerASTNode.
	node selector: #handle:.

	cascade := RBMessageNode
		           receiver:
		           (RBVariableNode named: ScpAssignmentOperation name)
		           selector: #new.

	node arguments: { (RBCascadeNode messages: {
				 (RBMessageNode
					  receiver: cascade
					  selector: #object:
					  arguments: { RBVariableNode selfNode }).
				 (RBMessageNode
					  receiver: cascade
					  selector: #variable:
					  arguments:
					  { (RBLiteralValueNode value: anAssignmentNode variable name) }).
				 (RBMessageNode
					  receiver: cascade
					  selector: #newValue:
					  arguments: { (aModifier visitNode: anAssignmentNode value) }).
				 (RBMessageNode receiver: cascade selector: #yourself) }) }.

	node instrumentedNode: anAssignmentNode.

	^ node
]

{ #category : 'private - services' }
ScpAssignmentInstrumentation >> registerIn: anInstrumentation [

	anInstrumentation registerAssignmentInstrumentation: self
]
