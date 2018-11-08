## Synopsis

NextflowIO utilise le language de programmation **groovy** qui lui meme est un sous-language de **java**.
Ainsi, la simple commande `println` fonction and un workflow nextflow

## nextflow

### ./workflow.nf

```groovy
  1   String getSalutation() {
  2   	return "Hello";
  3   	}
  4   
  5   println( getSalutation() + " world!")
```


## Execute

```
../bin/nextflow run workflow.nf
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [nasty_hopper] - revision: 186ffc1576
Hello world!
```


## Files

```
```


