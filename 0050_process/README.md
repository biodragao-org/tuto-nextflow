## Synopsis
Un exemple de workflow avec un seul process. 

On precise le fichier de sortie dans `output`

`tag`permet de donner un titre dans le déroulement du workflow

## nextflow

### ./workflow.nf

```groovy
params.salutation  = "Hello"
params.name  = "world"

process sayHello {
	tag "saying ${params.salutation} to ${params.name}"
	
	output:
		file("message.txt")

	script:	
	"""
	echo '${params.salutation} ${params.name}!' > message.txt
	"""
}
```


## Execute

```
../bin/nextflow run workflow.nf 
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [evil_church] - revision: b3e694b129
[warm up] executor > local
[2b/226971] Submitted process > sayHello (saying Hello to world)
../bin/nextflow run workflow.nf  --salutation Bonjour --name Monde
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [hopeful_laplace] - revision: b3e694b129
[warm up] executor > local
[16/53a9e5] Submitted process > sayHello (saying Bonjour to Monde)
../bin/nextflow run -config my.config workflow.nf  
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [high_kalam] - revision: b3e694b129
[warm up] executor > local
[80/50d367] Submitted process > sayHello (saying Hola to Muchachos)
```


## Files

```
work/16/53a9e51d8e43695b0e1a3530199251/message.txt
work/2b/226971ca6b376a8830750ba7e88d3d/message.txt
work/80/50d3670c1b349afbef1a8030abe091/message.txt
```


