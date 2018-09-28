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
Launching `workflow.nf` [zen_dijkstra] - revision: 638169095b
[warm up] executor > local
[fd/3d2554] Submitted process > sayHello (saying Hello to world)
../bin/nextflow run workflow.nf  --salutation Bonjour --name Monde
N E X T F L O W  ~  version 0.32.0
Launching `workflow.nf` [cranky_joliot] - revision: 638169095b
[warm up] executor > local
[ba/3f6eb1] Submitted process > sayHello (saying Bonjour to Monde)
../bin/nextflow run -config my.config workflow.nf  
N E X T F L O W  ~  version 0.32.0
Launching `workflow.nf` [shrivelled_ride] - revision: 638169095b
[warm up] executor > local
[0b/bd33d5] Submitted process > sayHello (saying Hola to Muchachos)
```


## Files

```
work/fd/3d2554a96b8f480f9ace71582507c9/message.txt
work/ba/3f6eb1c6d2d0bc06c75ca3c1f84d71/message.txt
work/0b/bd33d5b45ffb47e5b965e80ac4a67a/message.txt
```


