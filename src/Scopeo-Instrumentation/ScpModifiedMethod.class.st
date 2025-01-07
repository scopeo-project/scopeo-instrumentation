Class {
	#name : 'ScpModifiedMethod',
	#superclass : 'CompiledMethod',
	#type : 'compiledMethod',
	#category : 'Scopeo-Instrumentation-Core',
	#package : 'Scopeo-Instrumentation',
	#tag : 'Core'
}

{ #category : 'accessing' }
ScpModifiedMethod >> ast [

	^ self propertyAt: #ast
]

{ #category : 'accessing' }
ScpModifiedMethod >> ast: anAst [

	^ self propertyAt: #ast put: anAst
]

{ #category : 'accessing' }
ScpModifiedMethod >> instrumentation [

	^ self propertyAt: #instrumentation
]

{ #category : 'accessing' }
ScpModifiedMethod >> instrumentation: anInstrumentation [

	self propertyAt: #instrumentation put: anInstrumentation
]

{ #category : 'testing' }
ScpModifiedMethod >> isInstrumented [

	^ true
]

{ #category : 'accessing' }
ScpModifiedMethod >> sourceCode [

	^ self propertyAt: #sourceCode
]

{ #category : 'accessing' }
ScpModifiedMethod >> sourceCode: aSourceCode [

	self propertyAt: #sourceCode put: aSourceCode
]
