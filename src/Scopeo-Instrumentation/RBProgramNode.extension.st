Extension { #name : 'RBProgramNode' }

{ #category : '*Scopeo-Instrumentation' }
RBProgramNode >> indirectionSourceNode [

	^ self propertyAt: #indirectionSourceNode ifAbsent: [ ^ self ]
]

{ #category : '*Scopeo-Instrumentation' }
RBProgramNode >> indirectionSourceNode: aNode [

	^ self propertyAt: #indirectionSourceNode put: aNode
]

{ #category : '*Scopeo-Instrumentation' }
RBProgramNode >> isIndirectionNode [

	^ self indirectionSourceNode ~~ self
]
