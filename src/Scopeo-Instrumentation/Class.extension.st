Extension { #name : #Class }

{ #category : #'*Scopeo-Instrumentation' }
Class >> instrument: aHandler [

	^ ScpClassInstrumentation instance 
		target: self; 
		handler: aHandler;
		install 
]

{ #category : #'*Scopeo-Instrumentation' }
Class >> uninstrument [

	^ ScpInstrumentationRegistry instance
		  at: self
		  ifPresent: [ :i | i uninstall ]
]
