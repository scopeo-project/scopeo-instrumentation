Class {
	#name : 'ScpHandlerRegistry',
	#superclass : 'Object',
	#classInstVars : [
		'handlers'
	],
	#category : 'Scopeo-Instrumentation-Handlers',
	#package : 'Scopeo-Instrumentation',
	#tag : 'Handlers'
}

{ #category : 'services' }
ScpHandlerRegistry class >> get: aHandlerHash [

	^ self handlers at: aHandlerHash
]

{ #category : 'accessing' }
ScpHandlerRegistry class >> handlers [

	^ handlers ifNil: [ handlers := WeakValueDictionary new ]
]

{ #category : 'parameters' }
ScpHandlerRegistry class >> register: aHandler [

	^ self handlers at: aHandler hash ifAbsentPut: [ aHandler ]
]

{ #category : 'see class side' }
ScpHandlerRegistry >> seeClassSide [
]
