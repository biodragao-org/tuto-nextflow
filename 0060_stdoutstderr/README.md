## Synopsis

Ce workflow illustre la redirection des flux `stdout` et `stderr` qui vont respectivement se trouver dans les fichiers `.command.out` et `.command.err`.



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
  9   	script:
 10   	
 11   	"""
 12   	echo '${params.salutation} ${params.name}!' > message.txt
 13   	echo "\${PWD}" 
 14   	echo "\${HOME}" 1>&2 
 15   	"""
 16   }
```


## Execute

```
../bin/nextflow run workflow.nf 
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [chaotic_heyrovsky] - revision: 0f1c26bafc
[warm up] executor > local
[fa/b3a716] Submitted process > sayHello (saying Hello to world)
../bin/nextflow run workflow.nf  --salutation Bonjour --name Monde
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [angry_gutenberg] - revision: 0f1c26bafc
[warm up] executor > local
[94/ca8591] Submitted process > sayHello (saying Bonjour to Monde)
../bin/nextflow run -config my.config workflow.nf  
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [astonishing_hoover] - revision: 0f1c26bafc
[warm up] executor > local
[29/5459ad] Submitted process > sayHello (saying Hola to Muchachos)
```


## Files

```
work/29/5459ad8d51bf3e516c9e002804d7f9/message.txt
work/fa/b3a716c5c638f7671ec5ff0a733066/message.txt
work/94/ca8591e1589124f0d42a218acf06c0/message.txt
```


