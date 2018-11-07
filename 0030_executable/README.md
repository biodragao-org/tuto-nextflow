## Synopsis

Un workflow nextflow peut être utilisé en tant qu'executable en utilisant un shebang `#!`.

## nextflow

### ./workflow.nf

```groovy
  1   #!/usr/bin/env ../bin/nextflow
  2   
  3   println("Hello world!")
  4   
```


## Execute

```
./workflow.nf
N E X T F L O W  ~  version 0.31.1
Launching `./workflow.nf` [adoring_easley] - revision: 93f5d79f16
Hello world!
```


## Files

```
```


