Class {
	#name : 'ScpMethodReification',
	#superclass : 'ScpIndirectionReification',
	#category : 'Scopeo-Method-Instrumentation-Indirections',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Indirections'
}

{ #category : 'private - reification' }
ScpMethodReification >> generateForNode: anASTProgramNode [

	^ RBLiteralValueNode value: (
		self instrumenter hasIndirectionForBody 
			ifTrue: [ self instrumenter instrument: anASTProgramNode compiledMethod ]
			ifFalse: [ anASTProgramNode compiledMethod ]
	)
]
