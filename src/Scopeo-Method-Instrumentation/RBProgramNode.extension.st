Extension { #name : 'RBProgramNode' }

{ #category : '*Scopeo-Method-Instrumentation' }
RBProgramNode >> indirectionSourceNode [

	^ self propertyAt: #indirectionSourceNode ifAbsent: [ ^ self ]
]

{ #category : '*Scopeo-Method-Instrumentation' }
RBProgramNode >> indirectionSourceNode: aNode [

	^ self propertyAt: #indirectionSourceNode put: aNode
]

{ #category : '*Scopeo-Method-Instrumentation' }
RBProgramNode >> isIndirectionNode [

	^ self indirectionSourceNode ~~ self
]
