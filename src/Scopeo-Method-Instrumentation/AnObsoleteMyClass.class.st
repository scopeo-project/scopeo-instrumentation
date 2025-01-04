Class {
	#name : 'AnObsoleteMyClass',
	#superclass : 'Object',
	#category : 'Scopeo-Method-Instrumentation-Handlers',
	#package : 'Scopeo-Method-Instrumentation',
	#tag : 'Handlers'
}

{ #category : 'as yet unclassified' }
AnObsoleteMyClass class >> myClassMethod [

	^ super myClassMethod
]

{ #category : 'as yet unclassified' }
AnObsoleteMyClass >> myMethod [

	'coucou' crTrace
]
