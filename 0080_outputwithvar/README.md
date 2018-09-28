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
Launching `workflow.nf` [awesome_bassi] - revision: 8ef3122fa8
[warm up] executor > local
[6a/5f0ad2] Submitted process > sayHello (saying Hello to world)
../bin/nextflow run workflow.nf  --salutation Bonjour --name Monde
N E X T F L O W  ~  version 0.32.0
Launching `workflow.nf` [determined_volhard] - revision: 8ef3122fa8
[warm up] executor > local
[f8/e54271] Submitted process > sayHello (saying Bonjour to Monde)
../bin/nextflow run -config my.config workflow.nf  
N E X T F L O W  ~  version 0.32.0
Launching `workflow.nf` [goofy_mirzakhani] - revision: 8ef3122fa8
[warm up] executor > local
[e3/47c5e1] Submitted process > sayHello (saying Hola to Muchachos)
```


## Files

```
work/6a/5f0ad2aa54275254b9e26172d47e27/world.txt
work/f8/e54271a619d054413234cafa04e6f8/Monde.txt
work/e3/47c5e17c3871243175cbd903ef7f15/Muchachos.txt
```


