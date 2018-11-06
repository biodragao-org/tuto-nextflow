## Synopsis
Dans ce workflow, l'une des variables va servir a construire le fichier de sortie.

```
	output:
		file("${params.name}.txt")
```

on retrouve les fichiers avec les différents paramètres:


```
$ find work/ -name "*.txt"
work/e8/f975daa6461a31a0b203908e68f999/Muchachos.txt
work/ad/bce2a252ce3a5c51d46a278b91d173/world.txt
work/87/b16983cf2e48e7d5c015e6ca23712c/Monde.txt
```

## nextflow

### ./workflow.nf

```groovy
params.salutation  = "Hello"
params.name  = "world"

process sayHello {
	tag "saying ${params.salutation} to ${params.name}"
	
	output:
		file("${params.name}.txt")
	script:
	
	"""
	echo '${params.salutation} ${params.name}!' > ${params.name}.txt
	"""
}
```


## Execute

```
../bin/nextflow run workflow.nf 
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [festering_ritchie] - revision: 782d453180
[warm up] executor > local
[3f/8497f1] Submitted process > sayHello (saying Hello to world)
../bin/nextflow run workflow.nf  --salutation Bonjour --name Monde
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [thirsty_wiles] - revision: 782d453180
[warm up] executor > local
[d8/b11432] Submitted process > sayHello (saying Bonjour to Monde)
../bin/nextflow run -config my.config workflow.nf  
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [deadly_curie] - revision: 782d453180
[warm up] executor > local
[3b/655803] Submitted process > sayHello (saying Hola to Muchachos)
```


## Files

```
work/d8/b1143291c4c0007a5263ea4f8b6a2a/Monde.txt
work/3b/6558038c9ba0df5cd09bca98256421/Muchachos.txt
work/3f/8497f1f588e4c77c31d79f5979d313/world.txt
```


