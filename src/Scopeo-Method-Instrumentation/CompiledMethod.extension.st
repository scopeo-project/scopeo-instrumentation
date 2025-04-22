Extension { #name : 'CompiledMethod' }

{ #category : '*Scopeo-Method-Instrumentation' }
CompiledMethod >> attachNode: aNode toBlock: aBlock [

	self instrumentedBlocksBindings at: aBlock compiledBlock put: aNode.

	^ aBlock
]

{ #category : '*Scopeo-Method-Instrumentation' }
CompiledMethod >> instrumentedBlocksBindings [

	^ self propertyAt: #instrumentedBlocksBindings ifAbsentPut: [ 
		WeakKeyDictionary new	
	]
]

{ #category : '*Scopeo-Method-Instrumentation' }
CompiledMethod >> isInstrumented [

	^ false
]

{ #category : '*Scopeo-Method-Instrumentation' }
CompiledMethod >> original [


	^ self
]

{ #category : '*Scopeo-Method-Instrumentation' }
CompiledMethod >> sourceNodeForBlock: aCompiledBlock [

	^ self instrumentedBlocksBindings at: aCompiledBlock ifAbsent: [ nil ]
]
