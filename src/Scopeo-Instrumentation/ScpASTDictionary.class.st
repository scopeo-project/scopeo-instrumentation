Class {
	#name : 'ScpASTDictionary',
	#superclass : 'WeakKeyDictionary',
	#classInstVars : [
		'instance'
	],
	#category : 'Scopeo-Instrumentation',
	#package : 'Scopeo-Instrumentation'
}

{ #category : 'accessing' }
ScpASTDictionary class >> instance [

	^ instance ifNil: [ instance := self new ]
]
