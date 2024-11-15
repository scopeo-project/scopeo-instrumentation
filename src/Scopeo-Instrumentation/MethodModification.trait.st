Trait {
	#name : #MethodModification,
	#category : #'Scopeo-Instrumentation-GenericMethodModification'
}

{ #category : #applying }
MethodModification >> applyOn: aMethodNode [

	"Modifies the AST of a method"

	self subclassResponsibility
]
