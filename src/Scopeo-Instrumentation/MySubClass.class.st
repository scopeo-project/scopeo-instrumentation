Class {
	#name : #MySubClass,
	#superclass : #MyClass,
	#classVars : [
		'handler2195456'
	],
	#category : #'Scopeo-Instrumentation-Tests'
}

{ #category : #'as yet unclassified' }
MySubClass class >> MyClassClassmyClassMethod [

	| tmp1 |
	handler2195456 isEnabled ifFalse: [
		self class >> #MyClassClassmyClassMethod
			executeOriginalMethodOn: self
			withArguments: {  } ].
	handler2195456
		disable;
		message: #MyClassClassmyClassMethod
		sender: thisContext sender receiver
		receiver: self
		arguments: {  }.
	tmp1 := self MySuperClassClassmyClassMethod.
	handler2195456
		return: tmp1;
		enable.
	^ tmp1
]

{ #category : #'as yet unclassified' }
MySubClass class >> MySuperClassClassmyClassMethod [

	| tmp1 |
	handler2195456 isEnabled ifFalse: [
		self class >> #MySuperClassClassmyClassMethod
			executeOriginalMethodOn: self
			withArguments: {  } ].
	handler2195456
		disable;
		message: #MySuperClassClassmyClassMethod
		sender: thisContext sender receiver
		receiver: self
		arguments: {  };
		return: self;
		enable
]

{ #category : #'as yet unclassified' }
MySubClass class >> myClassMethod [

	| tmp1 |
	handler2195456 isEnabled ifFalse: [
		self class >> #myClassMethod
			executeOriginalMethodOn: self
			withArguments: {  } ].
	handler2195456
		disable;
		message: #myClassMethod
		sender: thisContext sender receiver
		receiver: self
		arguments: {  }.
	tmp1 := self MyClassClassmyClassMethod.
	handler2195456
		return: tmp1;
		enable.
	^ tmp1
]

{ #category : #'as yet unclassified' }
MySubClass >> myClassMethod [

	^ super myClassMethod
]
