Extension { #name : #Class }

{ #category : #'*Scopeo-Instrumentation' }
Class >> instrument: aHandler [

	| modification currentClass currentMethods instrumentedSelectors |
	
	(self hasClassVarNamed: ScpMetaclassModification handlerSymbol) ifTrue: [ ^ self ].
	self addClassVarNamed: ScpMetaclassModification handlerSymbol.	
	self classVarNamed: ScpMetaclassModification handlerSymbol put: aHandler.
	
	modification := ScpMetaclassModification new
		installationClass: self classSide;
		yourself.

	currentClass := self classSide.
	instrumentedSelectors := OrderedCollection new.
	[ currentClass = Object class ] whileFalse: [ 
		currentMethods := currentClass allMethods select: [ :m | m methodClass = currentClass ].
		currentMethods := currentMethods reject: [ :m | instrumentedSelectors includes: m selector ].
		currentMethods do: [ :m | 
				m applyModification: modification andInstallIn: self classSide.
				instrumentedSelectors add: m selector.
		].
		currentClass := currentClass superclass.
	].
	
	aHandler enable.
]

{ #category : #'*Scopeo-Instrumentation' }
Class >> uninstrument [

	(self hasClassVarNamed: ScpMetaclassModification handlerSymbol) ifFalse: [ ^ self ].
	
	(self classVarNamed: ScpMetaclassModification handlerSymbol) disable.

	(self classSide allMethods select: [ :m | m methodClass == self classSide ]) do: [ :m |
		m revertModification	
	].
	self removeClassVarNamed: ScpMetaclassModification handlerSymbol
]
