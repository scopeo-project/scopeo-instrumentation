Class {
	#name : 'ScpNodeReification',
	#superclass : 'ScpIndirectionReification',
	#category : 'Scopeo-Method-Instrumentation-Indirections',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Indirections'
}

{ #category : 'private - reification' }
ScpNodeReification >> generateForNode: anASTProgramNode [

	^ RBLiteralValueNode value: (anASTProgramNode isIndirectionNode 
		ifTrue: [ anASTProgramNode indirectionSourceNode ]
		ifFalse: [ anASTProgramNode ])
]
