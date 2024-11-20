Class {
	#name : 'ScpClassInstrumentation',
	#superclass : 'ScpInstrumentation',
	#category : 'Scopeo-Instrumentation-ScopeoMethodInstrumentation',
	#package : 'Scopeo-Instrumentation',
	#tag : 'ScopeoMethodInstrumentation'
}

{ #category : 'services' }
ScpClassInstrumentation >> install [

	| modification class selectors methods |

	self isInstalled ifTrue: [ ^ self target ].

	self installHandlerVariable.

	modification := self modification.
	class := self target class.

	selectors := IdentitySet new.
	[ class = Object class ] whileFalse: [
		methods := class methods reject: [ :m | selectors includes: m selector].
		selectors addAll: (methods collect: [ :m |
			m applyModification: modification 
			  andInstallIn: self target class.
			m selector 
		]).
		class := class superclass 
	].

	handler enable.
	
	ScpInstrumentationRegistry instance at: target put: self.
	
	^ target
]

{ #category : 'private' }
ScpClassInstrumentation >> modification [

	^ ScpMethodModification new
		  configuration: (ScpClassSideMethodModification new
				   handlerName: self handlerVariableName;
				   installationClass: self target classSide;
				   yourself);
		  yourself
]

{ #category : 'services' }
ScpClassInstrumentation >> uninstall [

	self isInstalled ifFalse: [ ^ self ].
	
	self handler disable.

	(self target classSide allMethods select: [ :m | m methodClass == self target classSide ]) do: [ :m |
		m revertModification	
	].

	self uninstallHandlerVariable.
	
	ScpInstrumentationRegistry instance removeKey: self target.
	
	^ self target
]
