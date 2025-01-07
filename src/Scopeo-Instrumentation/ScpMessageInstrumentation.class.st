Class {
	#name : 'ScpMessageInstrumentation',
	#superclass : 'ScpNodeInstrumentation',
	#category : 'Scopeo-Instrumentation-Instrumentations',
	#package : 'Scopeo-Instrumentation',
	#tag : 'Instrumentations'
}

{ #category : 'private' }
ScpMessageInstrumentation >> generateFor: aMessageNode usingModifier: aModifier [

	| node cascade |
	node := RBMessageNode new.
	node receiver: handlerASTNode.
	node selector: #handle:.

	cascade := RBMessageNode
		           receiver:
		           (RBVariableNode named: ScpMessageOperation name)
		           selector: #new.

	node arguments: { (RBCascadeNode messages: {
				 (RBMessageNode
					  receiver: cascade
					  selector: #selector:
					  arguments: { RBLiteralValueNode value: aMessageNode selector }).
				 (RBMessageNode
					  receiver: cascade
					  selector: #sender:
					  arguments: { RBVariableNode selfNode }).
				 (RBMessageNode
					  receiver: cascade
					  selector: #receiver:
					  arguments: { (aModifier visitNode: aMessageNode receiver) }).
				 (RBMessageNode
					  receiver: cascade
					  selector: #arguments:
					  arguments: { (RBArrayNode statements:
							   (aMessageNode arguments collect: [ :each |
								    aModifier visitNode: each ])) }) }) }.


	node instrumentedNode: aMessageNode.

	^ node
]

{ #category : 'private' }
ScpMessageInstrumentation >> registerIn: anInstrumentation [

	anInstrumentation registerMessageInstrumentation: self
]
