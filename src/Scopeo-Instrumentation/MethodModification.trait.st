Trait {
	#name : 'MethodModification',
	#category : 'Scopeo-Instrumentation-GenericMethodModification',
	#package : 'Scopeo-Instrumentation',
	#tag : 'GenericMethodModification'
}

{ #category : 'applying' }
MethodModification >> applyOn: aMethodNode [

	"Modifies the AST of a method"

	self subclassResponsibility
]
