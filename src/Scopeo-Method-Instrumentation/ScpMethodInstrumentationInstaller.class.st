Class {
	#name : 'ScpMethodInstrumentationInstaller',
	#superclass : 'Object',
	#instVars : [
		'instrumentation',
		'modifier',
		'methodHandler',
		'handler',
		'methodOriginal',
		'methodModified'
	],
	#category : 'Scopeo-Method-Instrumentation-Core',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Core'
}

{ #category : 'services' }
ScpMethodInstrumentationInstaller >> compile [

	| ast |

	ast := modifier visitMethod: methodOriginal.
	
	methodModified := methodOriginal 
		methodClass compiler 
		compile: ast source.
	
	ScpModifiedMethod adoptInstance: methodModified.
	methodModified ast: ast.
	methodModified sourceCode: methodOriginal sourceCode.
	methodModified instrumentation: self.
	
	^ methodModified
]

{ #category : 'initialization' }
ScpMethodInstrumentationInstaller >> initialize [

	modifier := ScpMethodModifier new.
	methodHandler := ScpDefaultHandler new
]

{ #category : 'services' }
ScpMethodInstrumentationInstaller >> install [
	
	self compile.
	
	methodOriginal methodClass ifNotNil: [ :class | 
		class addAndClassifySelector: methodOriginal selector
			withMethod: (ScpMethodInstrumented new
				handler: methodHandler;
				method: methodModified;
 				yourself)
			inProtocol: methodOriginal protocol.
	].
	
	^ methodModified
		
]

{ #category : 'parameters' }
ScpMethodInstrumentationInstaller >> method: aMethod [

	methodOriginal := aMethod
]

{ #category : 'accessing' }
ScpMethodInstrumentationInstaller >> methodModified [

	^ methodModified
]

{ #category : 'accessing' }
ScpMethodInstrumentationInstaller >> methodOriginal [

	^ methodOriginal 
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

	methodOriginal methodClass ifNotNil: [ :class |
		class
			addAndClassifySelector: methodOriginal selector
			withMethod: methodOriginal
			inProtocol: methodOriginal protocol
	]

	
		
]
