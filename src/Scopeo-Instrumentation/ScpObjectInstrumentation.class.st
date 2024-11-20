Class {
	#name : 'ScpObjectInstrumentation',
	#superclass : 'ScpInstrumentation',
	#instVars : [
		'proxyVariableName',
		'proxy'
	],
	#category : 'Scopeo-Instrumentation-ScopeoMethodInstrumentation',
	#package : 'Scopeo-Instrumentation',
	#tag : 'ScopeoMethodInstrumentation'
}

{ #category : 'initialization' }
ScpObjectInstrumentation >> initialize [

	proxyVariableName := #proxy
]

{ #category : 'services' }
ScpObjectInstrumentation >> install [

	self target class newAnonymousSubclass adoptInstance: self target.

	self installHandlerVariableOn: self target class.

	self installProxy.
	
	self handler enable.
	
	ScpInstrumentationRegistry instance at: self target put: self.
	
	^ self proxy
	
]

{ #category : 'private' }
ScpObjectInstrumentation >> installProxy [

	proxy := ScpObjectProxy basicNew.

	MirrorPrimitives
		fixedFieldOf: proxy
		at: (ScpObjectProxy slotNamed: #object) index
		put: proxy.

	MirrorPrimitives
		fixedFieldOf: proxy
		at: (ScpObjectProxy slotNamed: #handler) index
		put: self handler.
	
	MirrorPrimitives
		fixedFieldOf: proxy
		at: (ScpObjectProxy slotNamed: #modification) index
		put: self modification.
				
	self swapProxyAndTarget.

]

{ #category : 'private' }
ScpObjectInstrumentation >> installProxyVariable [

	(self target class hasClassVarNamed: self proxyVariableName) ifTrue: [ ^ self ].
	self target class addClassVarNamed: self proxyVariableName.	
	self target class classVarNamed: self proxyVariableName put: self proxy
]

{ #category : 'private' }
ScpObjectInstrumentation >> modification [

	^ ScpMethodModification new
		  configuration: (ScpInstanceSideMethodModification new
				   handlerName: handlerVariableName;
				   installationClass: target class;
				   yourself);
		  yourself
]

{ #category : 'private' }
ScpObjectInstrumentation >> proxy [

	^ proxy
]

{ #category : 'private' }
ScpObjectInstrumentation >> proxyVariableName [

	^ proxyVariableName
]

{ #category : 'private' }
ScpObjectInstrumentation >> swapProxyAndTarget [

	| temp |
	
	temp := target.
	target := proxy.
	proxy := temp.
	
	proxy become: target
]

{ #category : 'services' }
ScpObjectInstrumentation >> uninstall [

	handler disable.

	target class superclass adoptInstance: target.
	
	self swapProxyAndTarget.
	
	ScpInstrumentationRegistry instance removeKey: target.
	
	^ target
]
