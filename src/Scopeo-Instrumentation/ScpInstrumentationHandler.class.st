Class {
	#name : 'ScpInstrumentationHandler',
	#superclass : 'Object',
	#category : 'Scopeo-Instrumentation',
	#package : 'Scopeo-Instrumentation'
}

{ #category : 'events handling' }
ScpInstrumentationHandler >> handleAfterAssignmentOf: aValue toVariable: aVariable ofObject: anObject [
]

{ #category : 'events handling' }
ScpInstrumentationHandler >> handleAfterMessage: aSelector withArguments: anArguments sentBy: aSender receivedBy: aReceiver returned: aReturn [
]

{ #category : 'events handling' }
ScpInstrumentationHandler >> handleAfterSuperMessage: aSelector withArguments: anArguments sentBy: aSender returned: aReturn [
]

{ #category : 'events handling' }
ScpInstrumentationHandler >> handleBeforeAssignmentOf: aValue toVariable: aVariable ofObject: anObject [
]

{ #category : 'events handling' }
ScpInstrumentationHandler >> handleBeforeMessage: aSelector withArguments: anArguments sentBy: aSender receivedBy: aReceiver [
]

{ #category : 'events handling' }
ScpInstrumentationHandler >> handleBeforeMethod: aSelector executedOn: aReceiver withArguments: anArguments onCallFrom: aSender [
]

{ #category : 'events handling' }
ScpInstrumentationHandler >> handleBeforeReturn: aReturn [

	^ aReturn
]

{ #category : 'events handling' }
ScpInstrumentationHandler >> handleBeforeSuperMessage: aSelector withArguments: anArguments sentBy: aSender [
]

{ #category : 'events handling' }
ScpInstrumentationHandler >> node: aNodeId assignment: aBlock variable: aVariable object: anObject value: aValue [

	<debuggerCompleteToSender>

	| return |	
	self handleBeforeAssignmentOf: aValue toVariable: aVariable ofObject: anObject.
	return := aBlock value: aValue.
	self handleAfterAssignmentOf: aValue toVariable: aVariable ofObject: anObject.
	
	^ return
]

{ #category : 'events handling' }
ScpInstrumentationHandler >> node: aNodeId message: aSelector sender: aSender receiver: aReceiver arguments: anArguments [

	<debuggerCompleteToSender>

	| return |

	self handleBeforeMessage: aSelector withArguments: anArguments sentBy: aSender receivedBy: aReceiver.
	return := aReceiver perform: aSelector withArguments: anArguments.
	self handleAfterMessage: aSelector withArguments: anArguments sentBy: aSender receivedBy: aReceiver returned: return.
	
	^ return
]

{ #category : 'events handling' }
ScpInstrumentationHandler >> node: aNodeId return: aReturn [

	<debuggerCompleteToSender>

	self handleBeforeReturn: aReturn.

	^ aReturn
]

{ #category : 'events handling' }
ScpInstrumentationHandler >> node: aNodeId super: aSelector sender: aSender arguments: anArguments class: aClass [

	<debuggerCompleteToSender>
	
	| return |

	self handleBeforeSuperMessage: aSelector withArguments: anArguments sentBy: aSender.
	return := aSender perform: aSelector withArguments: anArguments inSuperclass: aClass superclass.
	self handleAfterSuperMessage: aSelector withArguments: anArguments sentBy: aSender returned: return.
	
	^ return
]
