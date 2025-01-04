Class {
	#name : 'ScpMethodInstrumentationInstaller',
	#superclass : 'Object',
	#instVars : [
		'instrumentation',
		'modifiedMethod',
		'originalMethod',
		'modifier',
		'methodHandler',
		'handler'
	],
	#category : 'Scopeo-Method-Instrumentation-Core',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Core'
}

{ #category : 'initialization' }
ScpMethodInstrumentationInstaller >> initialize [

	modifier := ScpMethodModifier new.
	methodHandler := ScpDefaultHandler new
]

{ #category : 'services' }
ScpMethodInstrumentationInstaller >> install [

	| ast |

	ast := modifier visitMethod: originalMethod.

	modifiedMethod := originalMethod 
		methodClass compiler 
		compile: ast source.

	ScpModifiedMethod adoptInstance: modifiedMethod.
	
	modifiedMethod ast: ast.
	
	originalMethod methodClass
		addAndClassifySelector: originalMethod selector
		withMethod: (ScpMethodInstrumented new
			handler: methodHandler;
			method: modifiedMethod;
 		   instrumentation: self;
			yourself
		)
		inProtocol: originalMethod protocol
		
]

{ #category : 'accessing' }
ScpMethodInstrumentationInstaller >> method [

	^ originalMethod
]

{ #category : 'parameters' }
ScpMethodInstrumentationInstaller >> method: aMethod [

	originalMethod := aMethod.
	modifiedMethod := aMethod
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
