Extension { #name : 'CompiledMethod' }

{ #category : '*Scopeo-Method-Instrumentation' }
CompiledMethod >> instrumentation [

	^ ScpMethodInstrumentationInstaller new
		  method: self;
		  yourself
]

{ #category : '*Scopeo-Method-Instrumentation' }
CompiledMethod >> isInstrumented [

	^ false
]
