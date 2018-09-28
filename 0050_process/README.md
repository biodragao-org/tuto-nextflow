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
Launching `workflow.nf` [berserk_magritte] - revision: fa4daadc32
[warm up] executor > local
[59/ff4df8] Submitted process > sayHello (saying Hello to world)
../bin/nextflow run workflow.nf  --salutation Bonjour --name Monde
N E X T F L O W  ~  version 0.32.0
Launching `workflow.nf` [disturbed_mccarthy] - revision: fa4daadc32
[warm up] executor > local
[20/25f96a] Submitted process > sayHello (saying Bonjour to Monde)
../bin/nextflow run -config my.config workflow.nf  
N E X T F L O W  ~  version 0.32.0
Launching `workflow.nf` [naughty_feynman] - revision: fa4daadc32
[warm up] executor > local
[6e/1d6abc] Submitted process > sayHello (saying Hola to Muchachos)
```


## Files

```
work/12/66729602e7e4efb793c667047c0ee3/message.txt
work/6d/cf4e98282f201a79a80635ce15c944/message.txt
work/e1/f43ca1632b3406e1ff887c1d3bd690/message.txt
work/59/ff4df895f5a63ad67004aabbe5a1dc/message.txt
work/20/25f96a604729ffc6766f2bcefbae9c/message.txt
work/6e/1d6abc0bd43fa1aea3063ff5731e89/message.txt
```


