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
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [evil_pauling] - revision: 638169095b
[warm up] executor > local
[ee/ba3351] Submitted process > sayHello (saying Hello to world)
../bin/nextflow run workflow.nf  --salutation Bonjour --name Monde
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [berserk_minsky] - revision: 638169095b
[warm up] executor > local
[10/98814c] Submitted process > sayHello (saying Bonjour to Monde)
../bin/nextflow run -config my.config workflow.nf  
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [sick_bassi] - revision: 638169095b
[warm up] executor > local
[b6/50eb27] Submitted process > sayHello (saying Hola to Muchachos)
```


## Files

```
work/b6/50eb27b04b9be9100599bb4c40e242/message.txt
work/f2/40e4e63e3608f7664a3399ab924824/message.txt
work/ee/ba33515b6cdc4cd727b3160a41a588/message.txt
work/10/98814cbd367edf9bbb380f076f1cea/message.txt
work/1d/199d83068708d1e7fc694833efb41b/message.txt
work/a4/31ad4ff1b045bc0716c0d751c2aeb3/message.txt
work/4f/126a79348d1692210334429044137d/message.txt
work/a7/9f0febb620c815688c9a9ccd585933/message.txt
work/1a/97c461710cd56566a6c3280005fadd/message.txt
work/26/cb8e5454645910d0fd71d5c511520e/message.txt
work/94/3767731ada16a2cc603736988c2e37/message.txt
work/cf/a8f5cffb7bf52b0f19636b2eb48e15/message.txt
```


