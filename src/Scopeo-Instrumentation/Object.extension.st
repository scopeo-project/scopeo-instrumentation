Extension { #name : 'Object' }

{ #category : '*Scopeo-Instrumentation' }
Object >> instrument: anInstrumentationHandler [

	[ ^ ScpObjectInstrumentation applyOn: self usingHandler: anInstrumentationHandler. ] 
		on: Error 
		do: [ :e | 
			Smalltalk logStdOutDuring: [ :logger |
				logger	 nextPutAll: e; cr 
			]
		]

]
