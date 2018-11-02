## nextflow

### ./workflow.nf

```groovy
#!./nextflow

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
Launching `workflow.nf` [mighty_koch] - revision: 8ef3122fa8
[warm up] executor > local
[c4/80dca3] Submitted process > sayHello (saying Hello to world)
../bin/nextflow run workflow.nf  --salutation Bonjour --name Monde
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [extravagant_lumiere] - revision: 8ef3122fa8
[warm up] executor > local
[7c/a5c098] Submitted process > sayHello (saying Bonjour to Monde)
../bin/nextflow run -config my.config workflow.nf  
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [irreverent_church] - revision: 8ef3122fa8
[warm up] executor > local
[ea/8de3d2] Submitted process > sayHello (saying Hola to Muchachos)
```


## Files

```
work/7c/a5c098f77992d1ae2ccfe2493a3c18/Monde.txt
work/c4/80dca3a1ac185a8fa37d78ea8fb0c5/world.txt
work/ea/8de3d2932e340e98984928d0417431/Muchachos.txt
```


