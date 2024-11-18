Class {
	#name : #ScpMethodModification,
	#superclass : #AbstractMethodModification,
	#instVars : [
		'nodeForHandler',
		'configuration'
	],
	#category : #'Scopeo-Instrumentation-ScopeoMethodModification'
}

{ #category : #accessing }
ScpMethodModification >> configuration [

	^ configuration
]

{ #category : #accessing }
ScpMethodModification >> configuration: aConfiguration [

	configuration := aConfiguration
]

{ #category : #modifying }
ScpMethodModification >> modificationBeforeAssignment: anAssignmentNode [

	anAssignmentNode variable isInstanceVariable ifFalse: [ ^ nil ].

	^ { (RBMessageNode
		   receiver: configuration nodeForHandler
		   selector: #assigment:object:value:
		   arguments: {
				   (RBLiteralValueNode value: anAssignmentNode variable name).
				   (RBVariableNode named: #self).
				   anAssignmentNode value }) }
]

{ #category : #modifying }
ScpMethodModification >> modificationBeforeMethod: aMethodNode [

	| statements |
	
	statements := OrderedCollection new.

	configuration hasMetaLevelGardClause ifTrue: [ 
		statements add: (configuration nodeForMetaLevelGardClause: aMethodNode).
		statements add: (RBMessageNode
			 receiver: configuration nodeForHandler
			 selector: #disable).
	].

	statements add: (RBMessageNode
			 receiver: configuration nodeForHandler
			 selector:
				 (ScpInstrumentationHandler >> #message:sender:receiver:arguments:)
					 selector
			 arguments: {
					 (RBLiteralValueNode value: aMethodNode selector).
					 configuration nodeForSender.
					 RBVariableNode selfNode.
					 (RBArrayNode statements: aMethodNode arguments) }).
					
	^ statements
]

{ #category : #modifying }
ScpMethodModification >> modificationBeforeReturn: aReturnNode [

	| statements |
	statements := OrderedCollection new.

	statements add: (RBMessageNode
			 receiver: configuration nodeForHandler
			 selector: #return:
			 arguments: { aReturnNode value }).

	configuration hasMetaLevelGardClause ifTrue: [
		statements add: (RBMessageNode
				 receiver: configuration nodeForHandler
				 selector: #enable) 
	].

	^ statements
]

{ #category : #modifying }
ScpMethodModification >> modificationInsteadMessage: aMessageNode [
	"
	If the receiver is not an block, rewrite it.
	When the receiver is the super variable, rewrite the parent method.
	Otherwise rewrite the receiver to propagate the instrumentation.
	"

	aMessageNode receiver isBlock ifTrue: [ ^ { aMessageNode } ].

	aMessageNode isSuperSend ifTrue: [ ^ self modificationInsteadSuperMessage: aMessageNode ].	
		
	aMessageNode receiver: (
		RBMessageNode
		  receiver: aMessageNode receiver 
		  selector: #instrument:
		  arguments: { configuration nodeForHandler }
	)
]

{ #category : #modifying }
ScpMethodModification >> modificationInsteadSuperMessage: aMessageNode [
	"
	Retrieve the method that is going to be executed when using the variable super (the super method).
	Change the name of the super method to identify it using its original class name.
	And rewrite the super method the same way as the currently rewritten method.
	Reuses the ScpMethodRewriter>>#rewrite: method to ensure the process is recursive.
	Restore the currently rewritten method once the super method has been rewritten. 
	"
	| method alias superMethod |	
	
	method := aMessageNode methodNode compiledMethod.
	superMethod := method methodClass superclass lookupSelector: aMessageNode selector.
	
	alias := (superMethod methodClass name copyReplaceAll: String space with: $_ asString) , $_ asString , superMethod selector.
	(configuration installationClass includesSelector: alias) ifFalse: [
		superMethod 
			applyModification: (self class new 
					configuration: (configuration copy 
						newSelector: alias; 
						yourself);
					yourself) 
			andInstallIn: configuration installationClass
	]. 
		
	^ alias
]
