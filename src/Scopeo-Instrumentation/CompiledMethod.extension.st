Extension { #name : 'CompiledMethod' }

{ #category : '*Scopeo-Instrumentation' }
CompiledMethod >> isModifiedMethod [

	^ false
]

{ #category : '*Scopeo-Instrumentation' }
CompiledMethod >> modification [

	^ ScpMethodModification new
		  method: self;
		  yourself
]
