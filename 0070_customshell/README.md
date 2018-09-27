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
#!/usr/bin/env python
x =  "${params.salutation}"
y =  "${params.name}" 
f = open("message.txt", "w") 
f.write( "%s - %s !" % (x,y) )
f.close()
"""
}
```


## Execute

```
../bin/nextflow run workflow.nf 
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [silly_colden] - revision: db56321d98
[warm up] executor > local
[70/960d0e] Submitted process > sayHello (saying Hello to world)
```


## Files

```
work/f0/bbf1f1125f1e5cf9e403fdbee31b99/message.txt
work/3d/3101100d705b5355dec0083b148ea2/message.txt
work/56/bb53aa084dc6beaada153cb7c945d6/message.txt
work/fe/001eaf7552a5e035a2d948b24274f3/message.txt
work/70/960d0e3f3272a8b1b486b8595f8942/message.txt
work/7c/70ff83920626c1ae7e9055fd43fe9b/message.txt
```


