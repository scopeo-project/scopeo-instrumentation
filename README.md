# Scopeo instrumentation

![Unit tests badge](https://img.shields.io/github/actions/workflow/status/scopeo-project/scopeo-instrumentation/tests.yml?label=Unit%20tests&branch=main)

A library to install instrumentation on Pharo smalltalk methods.

## How to install?

Open a playground and execute the following baseline:
```st
Metacello new
  githubUser: 'scopeo-project' project: 'scopeo-instrumentation' 
  commitish: 'main' path: 'src';
  baseline: 'ScopeoInstrumentation';
  load
```

## How to use?

### Create an instrumentation

To create the instrumentation, instantiate the `ScpMethodInstrumentation` class.  

To define the behavioral indirection to install in a given method use one of `ScpIndirection` subclasses:
- `ScpMethodIndirection`: transfer the control of method execution. 
- `ScpAssigmentIndirection`: transfer the control of variable assignments.
- `ScpMessageIndirection`: transfer the control of messages sending.

All of these classes expect following parameters:
- `handler:` the object which is going to catch the control of the original execution.
- `selector:` the selector of the *hook method* implemented by the `handler` to control the execution. 
- `arguments:` the arguments expected by the later *hook method*. 
  Please refer to the methods beginning with `generate` of the indirection classes to know which arguments are valid for your indirection. 

**Note:** since an indirection transfers the original behavior to the object of your choice, it is the responsibility of the latter object to perform the original behavior or not. I.e if an indirection is installed to trace all message sends, the handler code must log **and** perform the message send to ensure the execution is still correct. 
To do so, use the argument `operation`, this will provide the handler with a block containing the operation to execute.

#### Example
```st
| instrumentation |

instrumentation := ScpMethodInstrumentation new.

instrumentation addIndirection: (
  ScpMessageIndirection new
    handler: [ :operation :selector :receiver | 
      selector crTrace. 
      receiver crTrace.
      operation value
    ];
    selector: #value:value:value:;
    arguments: #( operation selector receiver );
    yourself
)
```

### Install an instrumentation

#### Install

It is possible to instrument an anonymous method using the message `applyOn: aMethod`:

```st
instrumented := instrumentation applyOn: aMethod
```

If the method is attached to a class, its instrumentation version can be installed using the message `installOn: aMethod`:.

```st
instrumented := instrumentation installOn: aMethod
```

One instrumentation can be installed on several methods.  
In this case, each non-anonymous methods is going to be attached to the instrumentation.  

#### Uninstall

To uninstall the instrumentation, use the `uninstall` message.  
This message will affect each method on which the instrumentation was installed.

```st
instrumentation uninstall
```

#### Update

The instrumentation can be updated, for example to add a new indirection (removal not supported yet).

```st
instrumentation addIndirection: (
  ScpAssignmentIndirection new
    handler: [ :operation :variable :newValue | 
      variable crTrace. 
      newValue crTrace.
      operation value 
    ];
    selector: #value:value:value:;
    arguments: #( operation variable newValue );
    yourself
)
```

To apply this new indirection to all the methods previously instrumented use the `reinstall` message.

```st
instrumentation reinstall
```

## Troubleshoot

### Known issues

- The methods are recompiled when instrumented, therefore the debugger looses track of the executed bytecode and cannot highlight the currently executed node.

### Possible issues

- An instrumented method always returns the source code of its original method, in some cases it might not be the expected behavior. For example, in the inspector of such method, the source code, AST and bytecode don't match.
- When the source code of an instrumented method is being edited, the new source code is automatically updated (only for non-anonymous methods). During development, I sometimes had troubles with that, the method was re-instrumented while I previously had uninstalled the instrumentation. To troubleshoot such issues, de-activate the method updater using like so: `ScpMethodUpdater stop`.

