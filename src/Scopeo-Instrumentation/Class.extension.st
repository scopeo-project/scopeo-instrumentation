Extension { #name : #Class }

{ #category : #'*Scopeo-Instrumentation' }
Class >> instrument: anInstrumentationHandler [

	[^ ScpClassInstrumentation applyOn: self usingHandler: anInstrumentationHandler ] on: Error 
		do: [ :e | 
			Smalltalk logStdOutDuring: [ :logger |
				logger	 nextPutAll: e; cr 
			]
		]
]
