Extension { #name : 'RBProgramNode' }

{ #category : '*Scopeo-Method-Instrumentation' }
RBProgramNode >> cascadeSourceNode [

	^ self propertyAt: #fromCascade
]

{ #category : '*Scopeo-Method-Instrumentation' }
RBProgramNode >> indirection [

	^ self propertyAt: #indirection
]

{ #category : '*Scopeo-Method-Instrumentation' }
RBProgramNode >> indirection: anIndirection [

	self propertyAt: #indirection put: anIndirection
]

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

{ #category : '*Scopeo-Method-Instrumentation' }
RBProgramNode >> isTransformedFromCascade [

	^ self hasProperty: #fromCascade
]

{ #category : '*Scopeo-Method-Instrumentation' }
RBProgramNode >> transformedFromCascade: aMessage [

	self propertyAt: #fromCascade put: aMessage 
]
