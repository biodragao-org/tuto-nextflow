## Synopsis

Un exemple de workflow avec un seul process. 

On precise le fichier de sortie dans `output`

`tag`permet de donner un titre dans le déroulement du workflow

## nextflow

### ./workflow.nf

```groovy
  1   params.salutation  = "Hello"
  2   params.name  = "world"
  3   
  4   process sayHello {
  5   	tag "saying ${params.salutation} to ${params.name}"
  6   	
  7   	output:
  8   		file("message.txt")
  9   
 10   	script:	
 11   	"""
 12   	echo '${params.salutation} ${params.name}!' > message.txt
 13   	"""
 14   }
```


## Execute

```
../bin/nextflow run workflow.nf 
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [sleepy_heisenberg] - revision: b3e694b129
[warm up] executor > local
[be/a552b8] Submitted process > sayHello (saying Hello to world)
../bin/nextflow run workflow.nf  --salutation Bonjour --name Monde
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [jolly_pesquet] - revision: b3e694b129
[warm up] executor > local
[96/bd993a] Submitted process > sayHello (saying Bonjour to Monde)
../bin/nextflow run -config my.config workflow.nf  
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [kickass_shaw] - revision: b3e694b129
[warm up] executor > local
[86/5310a3] Submitted process > sayHello (saying Hola to Muchachos)
```


## Files

```
work/96/bd993a9d561b6ad94f7a9e5e418e2d/message.txt
work/86/5310a324a0728b1635cbf68676092e/message.txt
work/be/a552b8fefa4ef34e51593165629a84/message.txt
```


