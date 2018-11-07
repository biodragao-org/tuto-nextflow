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
Launching `workflow.nf` [ridiculous_cray] - revision: b3e694b129
[warm up] executor > local
[af/38e81b] Submitted process > sayHello (saying Hello to world)
../bin/nextflow run workflow.nf  --salutation Bonjour --name Monde
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [friendly_miescher] - revision: b3e694b129
[warm up] executor > local
[07/b91b14] Submitted process > sayHello (saying Bonjour to Monde)
../bin/nextflow run -config my.config workflow.nf  
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [pedantic_albattani] - revision: b3e694b129
[warm up] executor > local
[26/1c5916] Submitted process > sayHello (saying Hola to Muchachos)
```


## Files

```
work/af/38e81b7186a90bcb59833c8686c299/message.txt
work/07/b91b14135b6cef71b523a1a2cc5582/message.txt
work/26/1c5916482ee0ab0f40ef983b4d4e5b/message.txt
```


