Class {
	#name : 'ScpModifiedMethod',
	#superclass : 'CompiledMethod',
	#type : 'compiledMethod',
	#category : 'Scopeo-Method-Instrumentation-Core',
	#package : 'Scopeo-Method-Instrumentation',
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

{ #category : 'testing' }
ScpModifiedMethod >> isInstrumented [

	^ true
]
