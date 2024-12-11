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

	| ast |
	ast := (CompiledMethod >> #ast) parseTree.
	ast body addNodeFirst: (RBMessageNode
			 receiver: (RBMessageNode
					  receiver: (RBVariableNode named: #ScpASTDictionary)
					  selector: #instance)
			 selector: #at:ifPresent:
			 arguments: {
					 (RBVariableNode named: #self).
					 (RBBlockNode
						  arguments: { (RBVariableNode named: #ast) }
						  body: (RBSequenceNode statements:
								   { (RBReturnNode value: (RBVariableNode named: #ast)) })) }).
								
	CompiledMethod compile: ast formattedCode.
]
