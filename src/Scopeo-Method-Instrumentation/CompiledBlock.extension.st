Extension { #name : 'CompiledBlock' }

{ #category : '*Scopeo-Method-Instrumentation' }
CompiledBlock >> isInstrumented [

	^ self method isInstrumented 
]

{ #category : '*Scopeo-Method-Instrumentation' }
CompiledBlock >> sourceNodeInOuter [

	self outerCode isInstrumented ifFalse: [ 
		^ self outerCode sourceNodeForPC: self pcInOuter	
	].

	^ self outerCode method original sourceNodeForBlock: self
	
]
