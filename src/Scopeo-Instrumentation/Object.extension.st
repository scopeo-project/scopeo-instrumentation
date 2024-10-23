Extension { #name : 'Object' }

{ #category : '*Scopeo-Instrumentation' }
Object >> instrument [

	^ ScpObjectInstrumentation applyOn: self

]
