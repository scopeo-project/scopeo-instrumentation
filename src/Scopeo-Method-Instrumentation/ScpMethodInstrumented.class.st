Class {
	#name : 'ScpMethodInstrumented',
	#superclass : 'CompiledMethod',
	#type : 'compiledMethod',
	#category : 'Scopeo-Method-Instrumentation-Instrumentation',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Instrumentation'
}

{ #category : 'instance creation' }
ScpMethodInstrumented class >> fromCompiledMethod: aMethod [

	self adoptInstance: aMethod.
	^ aMethod
]

{ #category : 'accessing' }
ScpMethodInstrumented >> ast [

	^ self original ast
]

{ #category : 'accessing' }
ScpMethodInstrumented >> instrumentation [

	^ self propertyAt: #instrumentation
]

{ #category : 'parameters' }
ScpMethodInstrumented >> instrumentation: anInstrumentation [

	self propertyAt: #instrumentation put: anInstrumentation
]

{ #category : 'parameters' }
ScpMethodInstrumented >> instrumentedAst [

	^ self propertyAt: #instrumentedAst
]

{ #category : 'parameters' }
ScpMethodInstrumented >> instrumentedAst: anAst [

	^ self propertyAt: #instrumentedAst put: anAst
]

{ #category : 'testing' }
ScpMethodInstrumented >> isInstrumented [

	^ true
]

{ #category : 'testing' }
ScpMethodInstrumented >> isPartOfInstrumentation [

	^ true
]

{ #category : 'accessing' }
ScpMethodInstrumented >> original [

	^ self propertyAt: #original 
]

{ #category : 'accessing' }
ScpMethodInstrumented >> original: aMethod [

	^ self propertyAt: #original put: aMethod
]

{ #category : 'accessing' }
ScpMethodInstrumented >> sourceCode [

	^ self original sourceCode
]

{ #category : 'accessing' }
ScpMethodInstrumented >> symbolicBytecodes [

	^ SymbolicBytecodeBuilder decode: self original 
]
