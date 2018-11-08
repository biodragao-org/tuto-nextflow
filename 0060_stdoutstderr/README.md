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
Launching `workflow.nf` [amazing_heyrovsky] - revision: 0f1c26bafc
[warm up] executor > local
[ab/0b9a45] Submitted process > sayHello (saying Hello to world)
../bin/nextflow run workflow.nf  --salutation Bonjour --name Monde
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [gloomy_faggin] - revision: 0f1c26bafc
[warm up] executor > local
[b9/7c92cc] Submitted process > sayHello (saying Bonjour to Monde)
../bin/nextflow run -config my.config workflow.nf  
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [romantic_banach] - revision: 0f1c26bafc
[warm up] executor > local
[af/5dfc4d] Submitted process > sayHello (saying Hola to Muchachos)
```


## Files

```
work/af/5dfc4dffcf8133b62ec3125a6f48ef/message.txt
work/ab/0b9a45446d5126e075de0906e0ca22/message.txt
work/b9/7c92cccf7c52e400da2c335457812f/message.txt
```


