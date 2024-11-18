Class {
	#name : #ScpModificationConfiguration,
	#superclass : #Object,
	#instVars : [
		'nodeForHandler',
		'installationClass',
		'selector'
	],
	#category : #'Scopeo-Instrumentation-ScopeoMethodModification'
}

{ #category : #testing }
ScpModificationConfiguration class >> isAbstract [

	^ self == ScpModificationConfiguration
]

{ #category : #parameters }
ScpModificationConfiguration >> handlerName: aSymbol [

	nodeForHandler := RBVariableNode named: aSymbol
]

{ #category : #accessing }
ScpModificationConfiguration >> hasMetaLevelGardClause [

	^ true
]

{ #category : #accessing }
ScpModificationConfiguration >> installationClass [

	^ installationClass
]

{ #category : #parameters }
ScpModificationConfiguration >> installationClass: anObject [

	installationClass := anObject
]

{ #category : #'instance creation' }
ScpModificationConfiguration >> newSelector [

	^ selector
]

{ #category : #parameters }
ScpModificationConfiguration >> newSelector: aSelector [

	selector := aSelector asSymbol
]

{ #category : #accessing }
ScpModificationConfiguration >> nodeForHandler [

	^ nodeForHandler
]

{ #category : #accessing }
ScpModificationConfiguration >> nodeForMetaLevelGardClause: aMethodNode [

	^ self subclassResponsibility
]

{ #category : #accessing }
ScpModificationConfiguration >> nodeForSender [

	^ self subclassResponsibility
]
