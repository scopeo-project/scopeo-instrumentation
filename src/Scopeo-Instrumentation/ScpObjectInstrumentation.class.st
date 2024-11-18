Class {
	#name : #ScpObjectInstrumentation,
	#superclass : #ScpInstrumentation,
	#instVars : [
		'proxyVariableName',
		'proxy'
	],
	#category : #'Scopeo-Instrumentation-ScopeoMethodInstrumentation'
}

{ #category : #initialization }
ScpObjectInstrumentation >> initialize [

	proxyVariableName := #proxy
]

{ #category : #actions }
ScpObjectInstrumentation >> install [

	target class newAnonymousSubclass adoptInstance: target.
	
	self installHandlerVariable.

	self installProxy.
	
	self swapProxyAndTarget.
	
	handler enable.
	
	ScpInstrumentationRegistry instance at: target put: self.
	
	^ proxy
	
]

{ #category : #initialization }
ScpObjectInstrumentation >> installHandlerVariable [

	(target class hasClassVarNamed: handlerVariableName) ifTrue: [ ^ self ].
	target class addClassVarNamed: handlerVariableName.	
	target class classVarNamed: handlerVariableName put: handler
]

{ #category : #'as yet unclassified' }
ScpObjectInstrumentation >> installProxy [

	| modification |

	proxy := ScpObjectProxy basicNew.
	
	modification := ScpMethodModification new.
	modification configuration: (ScpInstanceSideMethodModification new
		handlerName: handlerVariableName ;
		installationClass: target class;
		yourself).
		
	MirrorPrimitives
		fixedFieldOf: proxy
		at: (proxy class slotNamed: #object) index
		put: proxy.

	MirrorPrimitives
		fixedFieldOf: proxy
		at: (proxy class slotNamed: #modification) index
		put: modification.
		
	MirrorPrimitives
		fixedFieldOf: proxy
		at: (proxy class slotNamed: #handler) index
		put: handler.
		
	(target class hasClassVarNamed: proxyVariableName) ifTrue: [ ^ self ].
	target class addClassVarNamed: proxyVariableName.	
	target class classVarNamed: proxyVariableName put: proxy
]

{ #category : #'as yet unclassified' }
ScpObjectInstrumentation >> swapProxyAndTarget [

	| temp |
	
	temp := target.
	target := proxy.
	proxy := temp.
	
	target become: proxy
]

{ #category : #actions }
ScpObjectInstrumentation >> uninstall [

	handler disable.

	target class superclass adoptInstance: target.
	
	self swapProxyAndTarget.
	
	ScpInstrumentationRegistry instance removeKey: target.
	
	^ target
]
