Class {
	#name : #ScpClassSuperModification,
	#superclass : #ScpClassModification,
	#instVars : [
		'newSelector'
	],
	#category : #'Scopeo-Instrumentation'
}

{ #category : #accessing }
ScpClassSuperModification >> newSelector: aSelector [

	newSelector := aSelector
]

{ #category : #visiting }
ScpClassSuperModification >> visitMethodNode: aMethodNode [


	newSelector ifNotNil: [ aMethodNode selector: newSelector ].
	
	super visitMethodNode: aMethodNode
]
