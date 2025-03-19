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
		spec postLoadDoIt: #postload.
		spec package: 'Scopeo-Method-Instrumentation'.
		spec package: 'Scopeo-Method-Instrumentation-Tests' with: [ 
			spec requires: #( 'Scopeo-Method-Instrumentation' ) 
		]
	]
]

{ #category : 'installing' }
BaselineOfScopeoInstrumentation >> postload [

	ScpMethodUpdater start
]
