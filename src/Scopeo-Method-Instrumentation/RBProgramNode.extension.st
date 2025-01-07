Extension { #name : 'RBProgramNode' }

{ #category : '*Scopeo-Method-Instrumentation' }
RBProgramNode >> instrumentedNode [

	^ self propertyAt: #instrumentedNode ifAbsent: [ ^ self ]
]

{ #category : '*Scopeo-Method-Instrumentation' }
RBProgramNode >> instrumentedNode: aNode [

	^ self propertyAt: #instrumentedNode put: aNode
]

{ #category : '*Scopeo-Method-Instrumentation' }
RBProgramNode >> isInstrumentationNode [

	^ self instrumentedNode ~~ self
]
