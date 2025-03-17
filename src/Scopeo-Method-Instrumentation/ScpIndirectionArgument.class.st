Class {
	#name : 'ScpIndirectionArgument',
	#superclass : 'Object',
	#instVars : [
		'selector',
		'indirection',
		'arguments',
		'argument'
	],
	#category : 'Scopeo-Method-Instrumentation-Indirections',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Indirections'
}

{ #category : 'accessing' }
ScpIndirectionArgument >> argument: aBlockGeneratingArgumentAST [

	argument := aBlockGeneratingArgumentAST 

	
]

{ #category : 'accessing' }
ScpIndirectionArgument >> generateForNode: anASTProgramNode [

	^ RBMessageNode
		receiver: (indirection generateOperationForNode: anASTProgramNode)
  		selector: selector
    	arguments: { argument cull: anASTProgramNode cull: indirection instrumenter } 
]

{ #category : 'accessing' }
ScpIndirectionArgument >> indirection: anIndirection [

	indirection := anIndirection
]

{ #category : 'accessing' }
ScpIndirectionArgument >> selector: aSelector [

	selector := aSelector
]
