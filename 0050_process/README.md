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
N E X T F L O W  ~  version 0.32.0
Launching `workflow.nf` [agitated_waddington] - revision: fa4daadc32
[warm up] executor > local
[12/667296] Submitted process > sayHello (saying Hello to world)
../bin/nextflow run workflow.nf  --salutation Bonjour --name Monde
N E X T F L O W  ~  version 0.32.0
Launching `workflow.nf` [hungry_torricelli] - revision: fa4daadc32
[warm up] executor > local
[6d/cf4e98] Submitted process > sayHello (saying Bonjour to Monde)
../bin/nextflow run -config my.config workflow.nf  
N E X T F L O W  ~  version 0.32.0
Launching `workflow.nf` [wise_brown] - revision: fa4daadc32
[warm up] executor > local
[e1/f43ca1] Submitted process > sayHello (saying Hola to Muchachos)
```


## Files

```
work/12/66729602e7e4efb793c667047c0ee3/message.txt
work/6d/cf4e98282f201a79a80635ce15c944/message.txt
work/e1/f43ca1632b3406e1ff887c1d3bd690/message.txt
```


