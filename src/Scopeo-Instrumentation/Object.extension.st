Extension { #name : #Object }

{ #category : #'*Scopeo-Instrumentation' }
Object >> instrument: anInstrumentationHandler [

	| object proxy rewritingClass instrumentation |
	
	object := self.
	proxy := ScpObjectProxy new.
	
	rewritingClass := self class newAnonymousSubclass.
	rewritingClass adoptInstance:object.
	
	rewritingClass addClassVarNamed: ScpInstrumentationMethodRewriter handlerSymbol.	
	rewritingClass addClassVarNamed: ScpInstrumentationMethodRewriter proxySymbol.	
	rewritingClass classVarNamed: ScpInstrumentationMethodRewriter handlerSymbol put: anInstrumentationHandler. 
	
	instrumentation := ScpInstrumentation new 
		object: self;
		handler: anInstrumentationHandler;
		rewritingClass: rewritingClass;
		yourself.
	
	MirrorPrimitives
		fixedFieldOf: proxy
		at: (proxy class slotNamed: #instrumentation) index
		put: instrumentation.
		
	object become: proxy.
	
	rewritingClass classVarNamed: ScpInstrumentationMethodRewriter proxySymbol put: object.
	
	instrumentation enable
	
]
