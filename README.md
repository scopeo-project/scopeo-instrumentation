# Scopeo instrumentation

![Unit tests badge](https://img.shields.io/github/actions/workflow/status/scopeo-project/scopeo-instrumentation/tests.yml?label=Unit%20tests)

A library to install instrumentation on Pharo smalltalk methods.

## How to install

Open a playground and execute the following baseline:
```st
Metacello new
  githubUser: 'scopeo-project' project: 'scopeo-instrumentation' commitish: 'main' path: 'src';
  baseline: 'ScopeoInstrumentation';
  load
```

