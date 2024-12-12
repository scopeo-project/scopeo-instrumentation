Extension { #name : 'RBArrayNode' }

{ #category : '*Scopeo-Instrumentation' }
RBArrayNode >> findSourceNode [
	^self statements first sourceNode
]

{ #category : '*Scopeo-Instrumentation' }
RBArrayNode >> findSourceNodePosition [
	^self statements first sourceNodePosition
]
