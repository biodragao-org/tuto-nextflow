## Synopsis
NextflowIO utilise le language de programmation **groovy** qui lui meme est un sous-language de **java**.
Ainsi, la simple commande `println` fonction and un workflow nextflow

## nextflow

### ./workflow.nf

```groovy
String getSalutation() {
	return "Hello";
	}

println( getSalutation() + " world!")
```


## Execute

```
../bin/nextflow run workflow.nf
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [peaceful_waddington] - revision: 186ffc1576
Hello world!
```


## Files

```
```


