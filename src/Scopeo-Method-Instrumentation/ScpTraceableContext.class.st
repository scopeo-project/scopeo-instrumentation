Class {
	#name : 'ScpTraceableContext',
	#superclass : 'ScpContext',
	#instVars : [
		'execution'
	],
	#category : 'Scopeo-Method-Instrumentation-Instrumentation',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Instrumentation'
}

{ #category : 'as yet unclassified' }
ScpTraceableContext >> evaluateInstanceAssignment: aVariableNode old: anOldValue new: aNewValue [

	execution assignment: (ScpAssignmentTrace new
		node: aVariableNode;
		object: receiver;
		oldValue: anOldValue;
		newValue: aNewValue;
		yourself). 
]

{ #category : 'visiting' }
ScpTraceableContext >> evaluateMessage: aMessageNode on: aReceiver withArgs: aArguments [

	execution message: (ScpMessageTrace new
		node: aMessageNode;
		object: (self parent ifNotNil: [ :p | p receiver ]);
		receiver: aReceiver;
		arguments: aArguments;
		yourself).
		
	^ super evaluateMessage: aMessageNode on: aReceiver withArgs: aArguments

]

{ #category : 'visiting' }
ScpTraceableContext >> evaluateMethod: aCompiledMethod on: aReceiver withArgs: aArguments [
	
	| result |

	execution method:	(ScpMethodUntrackedTrace new
   		node: aCompiledMethod ast;
   		object: receiver;
   		arguments: aArguments;
		yourself).

	result := super evaluateMethod: aCompiledMethod on: aReceiver withArgs: aArguments.
	
	execution pop.

	^ result
]

{ #category : 'visiting' }
ScpTraceableContext >> evaluateMethodNode: aMethodNode on: aReceiver withArgs: aArguments [
	
	| result |

	execution method:	(ScpMethodTrace new
   		node: aMethodNode;
   		object: receiver;
   		arguments: aArguments;
		yourself).

	result := super evaluateMethodNode: aMethodNode on: aReceiver withArgs: aArguments.
	
	execution pop.

	^ result
]

{ #category : 'accessing' }
ScpTraceableContext >> execution [

	^ execution
]

{ #category : 'accessing' }
ScpTraceableContext >> execution: aScpExecutionRecord [ 
	execution := aScpExecutionRecord
]

{ #category : 'initialization' }
ScpTraceableContext >> initialize [

	super initialize.

	execution := ScpExecutionRecordTree new
]

{ #category : 'visiting' }
ScpTraceableContext >> visitMethodOrBlockNode: aMethodOrBlockNode [

	^ (super visitMethodOrBlockNode: aMethodOrBlockNode)
		execution: execution;
		yourself
]
