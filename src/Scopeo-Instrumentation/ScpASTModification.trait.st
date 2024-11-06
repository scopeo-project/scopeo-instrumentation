Trait {
	#name : #ScpASTModification,
	#category : #'Scopeo-Instrumentation'
}

{ #category : #applying }
ScpASTModification >> applyOn: aMethodNode [
	"
	Modifies the AST of a method to change its behavior.
	"
	self subclassResponsibility
]
