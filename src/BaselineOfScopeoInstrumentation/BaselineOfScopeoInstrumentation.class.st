Class {
	#name : 'BaselineOfScopeoInstrumentation',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfScopeoInstrumentation',
	#package : 'BaselineOfScopeoInstrumentation'
}

{ #category : 'baselines' }
BaselineOfScopeoInstrumentation >> baseline: spec [

	<baseline>
	spec for: #common do: [
		spec postLoadDoIt: #postload:package:.
		spec package: 'Scopeo-Instrumentation']
]

{ #category : 'actions' }
BaselineOfScopeoInstrumentation >> postload: loader package: packageSpec [

	CompiledMethod compile: 'ast
	"return an AST for this method. The AST is cached. see class comment of ASTCache"

	"Workaround, see https://github.com/pharo-project/pharo/issues/14871
	We force recompile to make sure the next call creates a correct BC to AST mapping"

	|ast|
	((self hasLiteral: #runtimeUndeclaredReadInContext:) or: [
		 self hasLiteral: #runtimeUndeclaredWrite:inContext: ]) ifTrue: [
		self isInstalled ifTrue: [ self recompile ] ].
	ast:=  (ASTCache at: self).
	ScpASTAnnotationVisitor instance visit: ast.

	^ ast'
]
