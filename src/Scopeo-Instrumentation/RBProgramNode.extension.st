Extension { #name : 'RBProgramNode' }

{ #category : '*Scopeo-Instrumentation' }
RBProgramNode >> instrumentedNode [

	^ self propertyAt: #instrumentedNode ifAbsent: [ ^ self ]
]

{ #category : '*Scopeo-Instrumentation' }
RBProgramNode >> instrumentedNode: aNode [

	^ self propertyAt: #instrumentedNode put: aNode
]

{ #category : '*Scopeo-Instrumentation' }
RBProgramNode >> isInstrumentationNode [

	^ self instrumentedNode ~~ self
]
