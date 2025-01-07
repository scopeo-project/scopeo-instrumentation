Extension { #name : 'CompiledMethod' }

{ #category : '*Scopeo-Instrumentation' }
CompiledMethod >> instrumentation [

	^ ScpMethodInstrumentationInstaller new
		  method: self;
		  yourself
]

{ #category : '*Scopeo-Instrumentation' }
CompiledMethod >> isInstrumented [

	^ false
]
