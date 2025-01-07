Class {
	#name : 'ScpTraceListHandler',
	#superclass : 'ScpTraceRecorderHandler',
	#instVars : [
		'traces'
	],
	#category : 'Scopeo-Instrumentation-Installer-Trace-Model',
	#package : 'Scopeo-Instrumentation-Installer',
	#tag : 'Trace-Model'
}

{ #category : 'initialization' }
ScpTraceListHandler >> initialize [

	traces := OrderedCollection new
]

{ #category : 'events handling' }
ScpTraceListHandler >> method: aSelector sender: aSender receiver: aReceiver arguments: anArguments [

	traces add: (ScpMessageReceivedTrace new
			 selector: aSelector;
			 receiver: aReceiver;
			 sender: aSender;
			 arguments: anArguments;
			 yourself)
]

{ #category : 'events handling' }
ScpTraceListHandler >> node: aNodeId assignment: aVariable object: anObject value: aValue [

	traces add: (ScpAssignmentTrace new
			 node: aNodeId;
			 variable: aVariable;
			 object: anObject;
			 value: aValue;
			 yourself)
]

{ #category : 'events handling' }
ScpTraceListHandler >> node: aNodeId message: aSelector sender: aSender receiver: aReceiver arguments: anArguments [

	traces add: (ScpMessageSentTrace new
			 node: aNodeId;
			 selector: aSelector;
			 receiver: aReceiver;
			 sender: aSender;
			 arguments: anArguments;
			 yourself)
]

{ #category : 'events handling' }
ScpTraceListHandler >> node: aNodeId messageReturn: aValue [

	traces add: (ScpMessageReturnTrace new
			 node: aNodeId;
			 object: aValue;
			 yourself)
]

{ #category : 'events handling' }
ScpTraceListHandler >> node: aNodeId methodReturn: aValue [

	traces add: (ScpMethodReturnTrace new
			 node: aNodeId;
			 object: aValue;
			 yourself)
]

{ #category : 'events handling' }
ScpTraceListHandler >> node: aNodeId super: aSelector sender: aSender arguments: anArguments [

	traces add: (ScpMessageSentToSuperTrace new
			 node: aNodeId;
			 selector: aSelector;
			 receiver: aSender;
			 sender: aSender;
			 arguments: anArguments;
			 yourself)
]

{ #category : 'accessing' }
ScpTraceListHandler >> process [

	^ traces inspect
]

{ #category : 'accessing' }
ScpTraceListHandler >> traces [

	^ traces
]
