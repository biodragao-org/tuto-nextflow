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
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [sharp_volta] - revision: 8ef3122fa8
[warm up] executor > local
[42/50f2d3] Submitted process > sayHello (saying Hello to world)
../bin/nextflow run workflow.nf  --salutation Bonjour --name Monde
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [condescending_jepsen] - revision: 8ef3122fa8
[warm up] executor > local
[85/87f7cd] Submitted process > sayHello (saying Bonjour to Monde)
../bin/nextflow run -config my.config workflow.nf  
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [gigantic_gutenberg] - revision: 8ef3122fa8
[warm up] executor > local
[62/8953ab] Submitted process > sayHello (saying Hola to Muchachos)
```


## Files

```
work/73/c3fc08120df55641649084ebd17f5b/message.txt
work/85/87f7cdefab4080be13911de5392b9d/Monde.txt
work/45/213ee27e68c55eb608ab16ddf144c7/message.txt
work/cb/f35e55b30d5b74e4424dc6b06dc253/Monde.txt
work/15/95e5e53ba0fda4c8518ad2eaa7b15e/Muchachos.txt
work/07/6b9a416bd8b3c3601a15b131b595d7/Monde.txt
work/62/8953abf7d56523fb3e606e3c0ba4ad/Muchachos.txt
work/b4/f1a0ad8f3e8eee699763901e4c9c6f/Muchachos.txt
work/75/c45b9862a274082b0ceb3e51a3b66c/world.txt
work/af/e0838ad492169edf39543b7c9d8ca7/message.txt
work/83/a296da3a7ad428b860054076967bf5/world.txt
work/42/50f2d37f455c1fe60e81ef46762350/world.txt
```


