Class {
	#name : #BaselineOfScopeoInstrumentation,
	#superclass : #BaselineOf,
	#category : #BaselineOfScopeoInstrumentation
}

{ #category : #baselines }
BaselineOfScopeoInstrumentation >> baseline: spec [

	<baseline>
	spec for: #common do: [
		spec package: 'Scopeo-Instrumentation']
]
