Extension { #name : #Object }

{ #category : #'*Scopeo-Instrumentation' }
Object >> instrument: aHandler [

	self class newAnonymousSubclass adoptInstance: self.
	
	self class addClassVarNamed: ScpClassModification handlerSymbol.
	self class classVarNamed: ScpClassModification handlerSymbol put: aHandler.

	self class addClassVarNamed: ScpClassModification proxySymbol.
	self class classVarNamed: ScpClassModification proxySymbol put: (
		ScpObjectProxy 
			newFor: self
			handler: aHandler
	).
		
	aHandler enable
	
]
