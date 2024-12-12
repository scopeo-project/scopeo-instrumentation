Extension { #name : 'RBProgramNode' }

{ #category : '*Scopeo-Instrumentation' }
RBProgramNode >> beScopeoNodeFor: aNode [

	self propertyAt: #sourceNode put: aNode
]

{ #category : '*Scopeo-Instrumentation' }
RBProgramNode >> findSourceNode [

	^ self
]

{ #category : '*Scopeo-Instrumentation' }
RBProgramNode >> isScopeoNode [

	^ self sourceNode ~~ self
]

{ #category : '*Scopeo-Instrumentation' }
RBProgramNode >> sourceNode [

	^ self propertyAt: #sourceNode ifAbsent: [ ^ self findSourceNode]
]
