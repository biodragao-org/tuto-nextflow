## nextflow

### ./workflow.nf

```groovy
#!./nextflow

params.salutation  = "Hello"
params.name  = "world"

process sayHello {
	tag "saying ${params.salutation} to ${params.name}"
	
	output:
		file("message.txt")
	script:
	
	"""
	echo '${params.salutation} ${params.name}!' > message.txt
	echo "\${PWD}" 
	echo "\${HOME}" 1>&2 
	"""
}
```


## Execute

```
../bin/nextflow run workflow.nf 
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [deadly_bhaskara] - revision: 638169095b
[warm up] executor > local
[0a/6ea08c] Submitted process > sayHello (saying Hello to world)
../bin/nextflow run workflow.nf  --salutation Bonjour --name Monde
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [furious_montalcini] - revision: 638169095b
[warm up] executor > local
[a0/3b12fc] Submitted process > sayHello (saying Bonjour to Monde)
../bin/nextflow run -config my.config workflow.nf  
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [nice_mcnulty] - revision: 638169095b
[warm up] executor > local
[9c/627edf] Submitted process > sayHello (saying Hola to Muchachos)
```


## Files

```
work/0a/6ea08c031e38af3bea73b46b7862ca/message.txt
work/9c/627edf66692782553632c951467bb5/message.txt
work/a0/3b12fc7812cfb9d59550dc94d99e3e/message.txt
```


