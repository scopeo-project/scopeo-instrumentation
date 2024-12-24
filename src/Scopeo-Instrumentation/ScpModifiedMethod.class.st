Class {
	#name : 'ScpModifiedMethod',
	#superclass : 'CompiledMethod',
	#type : 'compiledMethod',
	#category : 'Scopeo-Instrumentation-GenericMethodModification',
	#package : 'Scopeo-Instrumentation',
	#tag : 'GenericMethodModification'
}

{ #category : 'instance creation' }
ScpModifiedMethod class >> fromCompiledMethod: aMethod [

	self adoptInstance: aMethod.
	^ aMethod
]

{ #category : 'accessing' }
ScpModifiedMethod >> ast [

	^ self modification ast
]

{ #category : 'modification' }
ScpModifiedMethod >> isModifiedMethod [

	^ true
]

{ #category : 'modification' }
ScpModifiedMethod >> modification [

	^ self propertyAt: #modification
]

{ #category : 'modification' }
ScpModifiedMethod >> modification: aModification [

	self propertyAt: #modification put: aModification
]

{ #category : 'accessing' }
ScpModifiedMethod >> sourceCode [ 

	^ self modification method sourceCode
]
