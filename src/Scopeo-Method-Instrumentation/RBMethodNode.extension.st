Extension { #name : 'RBMethodNode' }

{ #category : '*Scopeo-Method-Instrumentation' }
RBMethodNode >> hasIndirectionNode [
	
	^ self allChildren anySatisfy: [ :node| node isIndirectionNode ]
]
