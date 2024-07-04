Class {
	#name : 'ScpInstrumentationHandler',
	#superclass : 'Object',
	#category : 'Scopeo-Instrumentation',
	#package : 'Scopeo-Instrumentation'
}

{ #category : 'events handling' }
ScpInstrumentationHandler >> method: aSelector sender: aSender receiver: aReceiver arguments: anArguments [
]

{ #category : 'events handling' }
ScpInstrumentationHandler >> node: aNodeId assignment: aVariable object: anObject value: aValue [
]

{ #category : 'events handling' }
ScpInstrumentationHandler >> node: aNodeId message: aSelector sender: aSender receiver: aReceiver arguments: anArguments [
]

{ #category : 'events handling' }
ScpInstrumentationHandler >> node: aNodeId return: aValue [
]

{ #category : 'events handling' }
ScpInstrumentationHandler >> node: aNodeId super: aSelector sender: aSender arguments: anArguments [
]

{ #category : 'events handling' }
ScpInstrumentationHandler >> process [

	self subclassResponsibility
]
