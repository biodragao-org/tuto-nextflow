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
Launching `workflow.nf` [condescending_wing] - revision: fa4daadc32
[warm up] executor > local
[da/08b811] Submitted process > sayHello (saying Hello to world)
../bin/nextflow run workflow.nf  --salutation Bonjour --name Monde
N E X T F L O W  ~  version 0.32.0
Launching `workflow.nf` [condescending_lalande] - revision: fa4daadc32
[warm up] executor > local
[47/a58d7e] Submitted process > sayHello (saying Bonjour to Monde)
../bin/nextflow run -config my.config workflow.nf  
N E X T F L O W  ~  version 0.32.0
Launching `workflow.nf` [distraught_jennings] - revision: fa4daadc32
[warm up] executor > local
[d8/c942f7] Submitted process > sayHello (saying Hola to Muchachos)
```


## Files

```
work/da/08b811a0804b2b2620c3823e495850/message.txt
work/47/a58d7ec599994884bf24178b23a7bf/message.txt
work/d8/c942f7f05b277985a05c517b768b4f/message.txt
```


