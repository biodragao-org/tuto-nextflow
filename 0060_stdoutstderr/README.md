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
Launching `workflow.nf` [modest_faggin] - revision: 638169095b
[warm up] executor > local
[20/8261a5] Submitted process > sayHello (saying Hello to world)
../bin/nextflow run workflow.nf  --salutation Bonjour --name Monde
N E X T F L O W  ~  version 0.32.0
Launching `workflow.nf` [gloomy_descartes] - revision: 638169095b
[warm up] executor > local
[aa/bd0bed] Submitted process > sayHello (saying Bonjour to Monde)
../bin/nextflow run -config my.config workflow.nf  
N E X T F L O W  ~  version 0.32.0
Launching `workflow.nf` [high_golick] - revision: 638169095b
[warm up] executor > local
[e2/447749] Submitted process > sayHello (saying Hola to Muchachos)
```


## Files

```
work/20/8261a5cdc4f15c58b05c0b2a55d13b/message.txt
work/aa/bd0bedf672a977df02723eed0a3918/message.txt
work/e2/447749b7efb9ea2f0477ac36920df6/message.txt
```


