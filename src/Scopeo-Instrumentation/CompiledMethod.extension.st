Extension { #name : 'CompiledMethod' }

{ #category : '*Scopeo-Instrumentation' }
CompiledMethod >> applyModification: anASTModification [

	^ self applyModification: anASTModification andInstallIn: self methodClass
]

{ #category : '*Scopeo-Instrumentation' }
CompiledMethod >> applyModification: anASTModification andIfAbsentInstallIn: aClass [

	(aClass includesSelector: self selector) ifTrue: [ ^ aClass >> self selector ].

	^ self applyModification: anASTModification andInstallIn: aClass
]

{ #category : '*Scopeo-Instrumentation' }
CompiledMethod >> applyModification: anASTModification andInstallIn: aClass [

	| ast newMethod |

	self isOriginalMethod ifFalse: [ ^ self ].
	
	ast := self parseTree.
	anASTModification applyOn: ast.
	
	newMethod := aClass compiler 
		source: ast formattedCode;
		compile.
	newMethod propertyAt: #original put: self.
		
	aClass addSelector: newMethod selector withMethod: newMethod. 
	
	^ newMethod
]

{ #category : '*Scopeo-Instrumentation' }
CompiledMethod >> executeOriginalMethodOn: aReceiver withArguments: anArguments [

	^ MirrorPrimitives 
		withReceiver: aReceiver 
		andArguments: anArguments
		execute: self originalMethod
]

{ #category : '*Scopeo-Instrumentation' }
CompiledMethod >> isOriginalMethod [

	^ self originalMethod == self
]

{ #category : '*Scopeo-Instrumentation' }
CompiledMethod >> originalMethod [

	^ self propertyAt: #original ifAbsent: [ ^ self ]
]

{ #category : '*Scopeo-Instrumentation' }
CompiledMethod >> revertModification [

	self isOriginalMethod ifTrue: [ ^ self ].

	self methodClass == self originalMethod methodClass 
		ifTrue: [ 
			self methodClass addSelector: self selector withMethod: self originalMethod.	
		]
		ifFalse: [
			self methodClass removeSelector: self selector
		].
	
	
]
