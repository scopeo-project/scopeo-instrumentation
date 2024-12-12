Extension { #name : 'RBProgramNode' }

{ #category : '*Scopeo-Instrumentation' }
RBProgramNode >> beScopeoNodeFor: aNode [

	self propertyAt: #sourceNode put: aNode.
	self propertyAt: #sourceNodePosition put: (aNode start to: aNode stop)
]

{ #category : '*Scopeo-Instrumentation' }
RBProgramNode >> findSourceNode [
	^ self
]

{ #category : '*Scopeo-Instrumentation' }
RBProgramNode >> findSourceNodePosition [

	^ self start to: self stop
]

{ #category : '*Scopeo-Instrumentation' }
RBProgramNode >> isScopeoNode [

	^ self propertyAt: #sourceNodePosition 
		ifPresent: [ ^ true ] 
		ifAbsent: [ ^ false ] 
]

{ #category : '*Scopeo-Instrumentation' }
RBProgramNode >> sourceNode [

	^ self propertyAt: #sourceNode ifAbsent: [ ^ self findSourceNode ]
]

{ #category : '*Scopeo-Instrumentation' }
RBProgramNode >> sourceNodePosition [

	^ self propertyAt: #sourceNodePosition ifAbsent: [ ^ self findSourceNodePosition ]
]
