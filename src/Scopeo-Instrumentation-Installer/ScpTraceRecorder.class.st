"
I allow the generation of execution traces for any Pharo program since Pharo 10.  

To use the class `ScpTraceRecorder`, one must select a **trace source**, i.e. a list of methods for which to generate the traces. 
To facilitate methods selection, we provide the `ScpTraceSourceSelectionBuilder`.
In the following example the selection builder selects all methods of the package where the class `ScpExampleObjectA` is located.
```Pharo
	| traceSource |
	
	traceSource := ScpTraceSourceSelectionBuilder new
		matchPackages: (OTMatcher name: 
			ScpExampleObjectA package name
		);
		build.
```

Now, one must define a handler which will capture each trace:
- **Method calls**: which are received from a method external to the trace source.
- **Messages**: that are sent by any method included in the trace source.
- **Assignments**: performed inside any method included in the trace source.
- **Returns**: from any method included in the trace source.

The handler must be provided to the `ScpTraceRecorder` through the `ScpTraceRecorder >>#storage:` setter. 
Note: this setter may be renamed in the future depending on this project evolution.
The following example illustrates the `ScpTraceRecorder` set up.

```Pharo
	| traceSource traceRecorder |
	
	traceRecorder := ScpTraceRecorder new.
	traceRecorder source: traceSource.
	traceRecorder storage: ScpTraceListStorage new.
```

Once the `ScpTraceRecorder` is set up, one must run it using following methods:
- `ScpTraceRecorder >> #switchOn`: to install the hooks which will generate the traces.
- `ScpTraceRecorder >> #startRecording`: to activate the handler, i.e. start catching the execution traces.	
- `ScpTraceRecorder >> #switchOff`: to de-activate the handler and remove the hooks.

```Pharo	
	| traceSource traceRecorder |
	
	traceRecorder switchOn.
	traceRecorder startRecording.
	traceRecorder switchOff
```



"
Class {
	#name : 'ScpTraceRecorder',
	#superclass : 'Object',
	#instVars : [
		'instrumentation',
		'source'
	],
	#category : 'Scopeo-Instrumentation-Installer-Model',
	#package : 'Scopeo-Instrumentation-Installer',
	#tag : 'Model'
}

{ #category : 'as yet unclassified' }
ScpTraceRecorder class >> defaultRejectedClasses [

	^ {  }
]

{ #category : 'as yet unclassified' }
ScpTraceRecorder class >> defaultRejectedPackages [

	^ { 'Kernel'. 'Collections-Sequenceable-Tests'.
	  'Collections-Atomic-Tests'. 'Collections-Unordered-Tests'.
	  'Collections-Stack'. 'Collections-Native'. 'Collections-Weak-Tests'.
	  'Collections-Arithmetic'. 'Collections-Unordered'.
	  'Collections-Atomic'. 'Collections-Tests'. 'Collections-Streams-Tests'.
	  'Collections-Strings-Tests'. 'Collections-Abstract-Traits'.
	  'Collections-Support'. 'Collections-Sequenceable'.
	  'Collections-Abstract-Tests'. 'Collections-Strings'.
	  'Collections-Arithmetic-Tests'. 'Collections-Stack-Tests'.
	  'Collections-DoubleLinkedList-Tests'.
	  'Collections-Native-Tests'. 'Collections-Abstract'.
	  'Collections-Weak'. 'Collections-Streams'. 'Collections-Support-Tests'.
	  'Collections-DoubleLinkedList'. 'Transcript-Core' }
]

{ #category : 'accessing' }
ScpTraceRecorder >> handler [

	^ instrumentation handler
]

{ #category : 'parameters' }
ScpTraceRecorder >> handler: aHandler [

	instrumentation handler: aHandler
]

{ #category : 'initialization' }
ScpTraceRecorder >> initialize [

	instrumentation := ScpInstrumentation new
]

{ #category : 'accessing' }
ScpTraceRecorder >> process [

	^ self handler process
]

{ #category : 'accessing' }
ScpTraceRecorder >> source [

	^ source
]

{ #category : 'parameters' }
ScpTraceRecorder >> source: aTraceSourceSelection [


	source := aTraceSourceSelection.
	instrumentation methodsToInstrument: source methods.
]

{ #category : 'services' }
ScpTraceRecorder >> startRecording [

	instrumentation enable
]

{ #category : 'services' }
ScpTraceRecorder >> stopRecording [

	instrumentation disable
]

{ #category : 'services' }
ScpTraceRecorder >> switchOff [

	self stopRecording.
	instrumentation uninstall
]

{ #category : 'services' }
ScpTraceRecorder >> switchOn [

	instrumentation install
]
