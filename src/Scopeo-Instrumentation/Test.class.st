Class {
	#name : #Test,
	#superclass : #Object,
	#category : #'Scopeo-Instrumentation-GenericMethodModification'
}

{ #category : #'as yet unclassified' }
Test >> applyModification: anASTModification [

	^ self applyModification: anASTModification andInstallIn: self methodClass
]

{ #category : #'as yet unclassified' }
Test >> applyModification: anASTModification andIfAbsentInstallIn: aClass [

	(aClass includesSelector: self selector) ifTrue: [ ^ aClass >> self selector ].

	^ self applyModification: anASTModification andInstallIn: aClass
]

{ #category : #'as yet unclassified' }
Test >> applyModification: anASTModification andInstallIn: aClass [

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

{ #category : #'as yet unclassified' }
Test >> isOriginalMethod [

	^ self originalMethod == self
]

{ #category : #'as yet unclassified' }
Test >> originalMethod [

	^ self propertyAt: #original ifAbsent: [ ^ self ]
]

{ #category : #'as yet unclassified' }
Test >> revertModification [

	self isOriginalMethod ifTrue: [ ^ self ].

	self methodClass == self originalMethod methodClass 
		ifTrue: [ 
			self methodClass addSelector: self selector withMethod: self originalMethod.	
		]
		ifFalse: [
			self methodClass removeSelector: self selector
		].
	
	
]
