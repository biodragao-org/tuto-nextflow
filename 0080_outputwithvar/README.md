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
  1   params.salutation  = "Hello"
  2   params.name  = "world"
  3   
  4   process sayHello {
  5   	tag "saying ${params.salutation} to ${params.name}"
  6   	
  7   	output:
  8   		file("${params.name}.txt")
  9   	script:
 10   	
 11   	"""
 12   	echo '${params.salutation} ${params.name}!' > ${params.name}.txt
 13   	"""
 14   }
```


## Execute

```
../bin/nextflow run workflow.nf 
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [insane_lichterman] - revision: 782d453180
[warm up] executor > local
[aa/ea1791] Submitted process > sayHello (saying Hello to world)
../bin/nextflow run workflow.nf  --salutation Bonjour --name Monde
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [backstabbing_hoover] - revision: 782d453180
[warm up] executor > local
[03/06c02d] Submitted process > sayHello (saying Bonjour to Monde)
../bin/nextflow run -config my.config workflow.nf  
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [awesome_nightingale] - revision: 782d453180
[warm up] executor > local
[79/f77b05] Submitted process > sayHello (saying Hola to Muchachos)
```


## Files

```
work/aa/ea17916d7dfb049e5fcad5aff393e5/world.txt
work/03/06c02d70b7de8330fdb3a224e0ff51/Monde.txt
work/79/f77b052d09581eadadda0a06bb98b9/Muchachos.txt
```


