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
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [distraught_curran] - revision: fa4daadc32
[warm up] executor > local
[d2/fd133d] Submitted process > sayHello (saying Hello to world)
../bin/nextflow run workflow.nf  --salutation Bonjour --name Monde
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [lethal_visvesvaraya] - revision: fa4daadc32
[warm up] executor > local
[35/9bf65b] Submitted process > sayHello (saying Bonjour to Monde)
../bin/nextflow run -config my.config workflow.nf  
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [prickly_bassi] - revision: fa4daadc32
[warm up] executor > local
[92/a7eaa7] Submitted process > sayHello (saying Hola to Muchachos)
```


## Files

```
work/73/c3fc08120df55641649084ebd17f5b/message.txt
work/a8/60031ef27a6bef110312363f4063b7/message.txt
work/5d/34b7ea12ece8e138b76b9c5ea74051/message.txt
work/45/213ee27e68c55eb608ab16ddf144c7/message.txt
work/92/a7eaa77ee6083c763a9ef9d5da40a9/message.txt
work/4a/897aa5311d5d61c6b50eae6fbc99b5/message.txt
work/d2/fd133de8612c13962dab89c01d6cc4/message.txt
work/35/9bf65bca9e9a422a58363f4b094fdd/message.txt
work/e3/2e6d26563fbb59a8ae8fc795a541df/message.txt
work/af/e0838ad492169edf39543b7c9d8ca7/message.txt
work/8f/a942cc937ff952d11b3d81c054ddbf/message.txt
work/1e/6c17387f55248906783e7bd47e7c5e/message.txt
```


