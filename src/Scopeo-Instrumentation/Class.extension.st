Extension { #name : 'Class' }

{ #category : '*Scopeo-Instrumentation' }
Class >> instrument [

	^ ScpClassInstrumentation applyOn: self
]
