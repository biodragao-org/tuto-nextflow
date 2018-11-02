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
	"""
}
```


## Execute

```
../bin/nextflow run workflow.nf 
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [agitated_sanger] - revision: fa4daadc32
[warm up] executor > local
[eb/9f1f25] Submitted process > sayHello (saying Hello to world)
../bin/nextflow run workflow.nf  --salutation Bonjour --name Monde
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [shrivelled_picasso] - revision: fa4daadc32
[warm up] executor > local
[c9/38db70] Submitted process > sayHello (saying Bonjour to Monde)
../bin/nextflow run -config my.config workflow.nf  
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [intergalactic_coulomb] - revision: fa4daadc32
[warm up] executor > local
[18/17a89a] Submitted process > sayHello (saying Hola to Muchachos)
```


## Files

```
work/18/17a89a6bd5b0b4bd8c2474d5640fed/message.txt
work/c9/38db7052c5cae6c5cf116b1e562d46/message.txt
work/eb/9f1f254076bd6d0de95703a1cd4abf/message.txt
```


