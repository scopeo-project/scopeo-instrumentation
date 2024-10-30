Extension { #name : #Object }

{ #category : #'*Scopeo-Instrumentation' }
Object >> instrument: anInstrumentationHandler [

	| object proxy rewritingClass temp |
	
	object := self.
	proxy := ScpObjectProxyOld new.
	
	rewritingClass := self class newAnonymousSubclass.
	
	rewritingClass adoptInstance:object.
	
	rewritingClass addClassVarNamed: self class handlerSymbol.	
	rewritingClass addClassVarNamed: self class proxySymbol.	

	rewritingClass classVarNamed: self class handlerSymbol put: anInstrumentationHandler. 
	rewritingClass classVarNamed: self class proxySymbol put: proxy.
	
	rewritingClass adoptInstance: object.
	
	temp := object. 
	object := proxy. 
	proxy := temp.

	object become: proxy.
	


	[ ^ ScpObjectInstrumentation applyOn: self usingHandler: anInstrumentationHandler. ] 
		on: Error 
		do: [ :e | 
			Smalltalk logStdOutDuring: [ :logger |
				logger	 nextPutAll: e; cr 
			]
		]

]
