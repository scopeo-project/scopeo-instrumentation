Class {
	#name : #ScpClassInstrumentation,
	#superclass : #ScpInstrumentation,
	#category : #'Scopeo-Instrumentation-ScopeoMethodInstrumentation'
}

{ #category : #actions }
ScpClassInstrumentation >> install [

	| modification currentClass selectors methods |

	self isInstalled ifTrue: [ ^ target ].
	self installHandlerVariable.
	
	modification := ScpMethodModification new.
	modification configuration: (ScpClassSideMethodModification new
		handlerName: handlerVariableName;
		installationClass: target classSide;
		yourself).

	currentClass := modification configuration installationClass.

	selectors := IdentitySet new.
	[ currentClass = Object class ] whileFalse: [
		methods := currentClass methods reject: [ :m | selectors includes: m selector].
		selectors addAll: (methods collect: [ :m |
			m applyModification: modification 
			  andInstallIn: modification configuration installationClass.
			m selector 
		]).
		currentClass := currentClass superclass 
	].

	handler enable.
	
	ScpInstrumentationRegistry instance at: target put: self.
	
	^ target
]

{ #category : #'instance creation' }
ScpClassInstrumentation >> installHandlerVariable [

	(target hasClassVarNamed: handlerVariableName) ifTrue: [ ^ self ].
	target addClassVarNamed: handlerVariableName.	
	target classVarNamed: handlerVariableName put: handler
]

{ #category : #actions }
ScpClassInstrumentation >> uninstall [

	self isInstalled ifFalse: [ ^ self ].
	
	handler disable.

	(target classSide allMethods select: [ :m | m methodClass == target classSide ]) do: [ :m |
		m revertModification	
	].

	self uninstallHandlerVariable.
	
	ScpInstrumentationRegistry instance removeKey: target.
	
	^ target
]

{ #category : #actions }
ScpClassInstrumentation >> uninstallHandlerVariable [

	(target hasClassVarNamed: handlerVariableName) ifFalse: [ ^ self ].
	target removeClassVarNamed: handlerVariableName

]
