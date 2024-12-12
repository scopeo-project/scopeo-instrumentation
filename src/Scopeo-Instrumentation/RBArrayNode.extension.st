Extension { #name : 'RBArrayNode' }

{ #category : '*Scopeo-Instrumentation' }
RBArrayNode >> findSourceNode [
	^self statements first sourceNode
]
