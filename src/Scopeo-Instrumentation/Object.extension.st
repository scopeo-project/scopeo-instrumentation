Extension { #name : 'Object' }

{ #category : '*Scopeo-Instrumentation' }
Object >> instrument: aHandler [

	^ ScpObjectInstrumentation new
		target: self;
		handler: aHandler;
		install
]
