Class {
	#name : 'ScpMethodInstrumentationInstaller',
	#superclass : 'Object',
	#instVars : [
		'instrumentation',
		'originalMethod',
		'modifier',
		'methodHandler',
		'handler'
	],
	#category : 'Scopeo-Method-Instrumentation-Core',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Core'
}

{ #category : 'compiling' }
ScpMethodInstrumentationInstaller >> compile [

	| ast modifiedMethod |

	ast := modifier visitMethod: originalMethod.
	
	modifiedMethod := originalMethod 
		methodClass compiler 
		compile: ast source.
	
	ScpModifiedMethod adoptInstance: modifiedMethod.
	modifiedMethod ast: ast.
	modifiedMethod sourceCode: originalMethod sourceCode.
	modifiedMethod instrumentation: self.
	
	^ modifiedMethod
]

{ #category : 'initialization' }
ScpMethodInstrumentationInstaller >> initialize [

	modifier := ScpMethodModifier new.
	methodHandler := ScpDefaultHandler new
]

{ #category : 'services' }
ScpMethodInstrumentationInstaller >> install [
	
	originalMethod methodClass
		addAndClassifySelector: originalMethod selector
		withMethod: (ScpMethodInstrumented new
			handler: methodHandler;
			method: self compile;
 			yourself)
		inProtocol: originalMethod protocol
		
]

{ #category : 'accessing' }
ScpMethodInstrumentationInstaller >> method [

	^ originalMethod
]

{ #category : 'parameters' }
ScpMethodInstrumentationInstaller >> method: aMethod [

	originalMethod := aMethod
]

{ #category : 'parameters' }
ScpMethodInstrumentationInstaller >> register: anInstrumentation [

	anInstrumentation registerIn: self
]

{ #category : 'private' }
ScpMethodInstrumentationInstaller >> registerAssignmentInstrumentation: anAssigment [

	modifier registerAssignmentInstrumentation: anAssigment 
]

{ #category : 'private' }
ScpMethodInstrumentationInstaller >> registerMessageInstrumentation: aMessage [

	modifier registerMessageInstrumentation: aMessage 
]

{ #category : 'private' }
ScpMethodInstrumentationInstaller >> registerMethodInstrumentation: aMethod [

	methodHandler := aMethod handler
]

{ #category : 'services' }
ScpMethodInstrumentationInstaller >> uninstall [

	originalMethod methodClass
		addAndClassifySelector: originalMethod selector
		withMethod: originalMethod
		inProtocol: originalMethod protocol
		
]
