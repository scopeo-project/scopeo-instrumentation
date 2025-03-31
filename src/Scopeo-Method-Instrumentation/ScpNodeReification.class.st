Class {
	#name : 'ScpNodeReification',
	#superclass : 'ScpIndirectionReification',
	#category : 'Scopeo-Method-Instrumentation-Indirections',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Indirections'
}

{ #category : 'private - reification' }
ScpNodeReification >> generateForNode: anASTProgramNode [

	| node |

	node:= anASTProgramNode.
	
	anASTProgramNode isIndirectionNode ifTrue: [ 
		node := anASTProgramNode indirectionSourceNode 
	].
	
	anASTProgramNode isTransformedFromCascade ifTrue: [ 
		node := anASTProgramNode cascadeSourceNode 
	].

	^ RBLiteralValueNode value: node
]
