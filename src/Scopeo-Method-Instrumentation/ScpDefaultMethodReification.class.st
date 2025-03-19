Class {
	#name : 'ScpDefaultMethodReification',
	#superclass : 'ScpDefaultReification',
	#category : 'Scopeo-Method-Instrumentation-Indirections',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Indirections'
}

{ #category : 'private - reification' }
ScpDefaultMethodReification >> generateForNode: anASTProgramNode [

	^ RBBlockNode body: (RBSequenceNode statements: { 
		(RBMessageNode
			receiver: RBVariableNode selfNode
			selector: #withArgs:executeMethod:
			arguments: {
				RBArrayNode statements: anASTProgramNode arguments.
				RBLiteralValueNode value: (self instrumenter hasIndirectionForBody 
					ifTrue: [ self instrumenter instrument: anASTProgramNode compiledMethod ]
					ifFalse: [ anASTProgramNode compiledMethod ])
			}) 
	})
]
