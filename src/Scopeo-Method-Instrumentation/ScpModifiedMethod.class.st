Class {
	#name : 'ScpModifiedMethod',
	#superclass : 'CompiledMethod',
	#type : 'compiledMethod',
	#category : 'Scopeo-Method-Instrumentation',
	#package : 'Scopeo-Method-Instrumentation'
}

{ #category : 'instance creation' }
ScpModifiedMethod class >> fromCompiledMethod: aMethod [

	self adoptInstance: aMethod.
	^ aMethod
]

{ #category : 'accessing' }
ScpModifiedMethod >> ast [

	^ self propertyAt: #ast
]

{ #category : 'parameters' }
ScpModifiedMethod >> ast: anAst [

	^ self propertyAt: #ast put: anAst
]

{ #category : 'accessing' }
ScpModifiedMethod >> instrumentation [

	^ self propertyAt: #instrumentation
]

{ #category : 'parameters' }
ScpModifiedMethod >> instrumentation: anInstrumentation [

	self propertyAt: #instrumentation put: anInstrumentation
]

{ #category : 'testing' }
ScpModifiedMethod >> isInstrumented [

	^ true
]

{ #category : 'accessing' }
ScpModifiedMethod >> original [

	^ self propertyAt: #original 
]

{ #category : 'accessing' }
ScpModifiedMethod >> original: aMethod [

	^ self propertyAt: #original put: aMethod
]

{ #category : 'accessing' }
ScpModifiedMethod >> sourceCode [

	^ self propertyAt: #sourceCode
]

{ #category : 'parameters' }
ScpModifiedMethod >> sourceCode: aSourceCode [

	self propertyAt: #sourceCode put: aSourceCode
]
