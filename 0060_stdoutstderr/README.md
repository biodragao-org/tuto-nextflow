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
N E X T F L O W  ~  version 0.32.0
Launching `workflow.nf` [gloomy_lamport] - revision: 638169095b
[warm up] executor > local
[64/6213de] Submitted process > sayHello (saying Hello to world)
../bin/nextflow run workflow.nf  --salutation Bonjour --name Monde
N E X T F L O W  ~  version 0.32.0
Launching `workflow.nf` [nice_euler] - revision: 638169095b
[warm up] executor > local
[ff/784c50] Submitted process > sayHello (saying Bonjour to Monde)
../bin/nextflow run -config my.config workflow.nf  
N E X T F L O W  ~  version 0.32.0
Launching `workflow.nf` [awesome_bardeen] - revision: 638169095b
[warm up] executor > local
[6b/7626fc] Submitted process > sayHello (saying Hola to Muchachos)
```


## Files

```
work/20/8261a5cdc4f15c58b05c0b2a55d13b/message.txt
work/aa/bd0bedf672a977df02723eed0a3918/message.txt
work/e2/447749b7efb9ea2f0477ac36920df6/message.txt
work/64/6213de3f64d2f2a4377c58db30f904/message.txt
work/ff/784c504dd0af6cd6c80f6b95100672/message.txt
work/6b/7626fc43e19121cd782047d339e5fe/message.txt
```


