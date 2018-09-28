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
N E X T F L O W  ~  version 0.32.0
Launching `workflow.nf` [jovial_yalow] - revision: 8ef3122fa8
[warm up] executor > local
[e4/ff15d0] Submitted process > sayHello (saying Hello to world)
../bin/nextflow run workflow.nf  --salutation Bonjour --name Monde
N E X T F L O W  ~  version 0.32.0
Launching `workflow.nf` [tiny_kalam] - revision: 8ef3122fa8
[warm up] executor > local
[7d/6aaee8] Submitted process > sayHello (saying Bonjour to Monde)
../bin/nextflow run -config my.config workflow.nf  
N E X T F L O W  ~  version 0.32.0
Launching `workflow.nf` [cheeky_yalow] - revision: 8ef3122fa8
[warm up] executor > local
[24/9e2d32] Submitted process > sayHello (saying Hola to Muchachos)
```


## Files

```
work/e4/ff15d0f954a52aed2dc1606f25d188/world.txt
work/7d/6aaee8d2d31b54470b581f4509df68/Monde.txt
work/24/9e2d32f97b7e505022aa033a5944e8/Muchachos.txt
```


