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
../bin/nextflow run -resume -with-trace trace.tsv -with-report report.html -with-timeline timeline.html -with-dag flowchart.png workflow.nf 
N E X T F L O W  ~  version 0.32.0
Launching `workflow.nf` [furious_hopper] - revision: db56321d98
[warm up] executor > local
[15/fcbb75] Cached process > sayHello (saying Hello to world)
```


## Files

```
work/15/fcbb75e39f791b2d60bc834fbe1a09/message.txt
```



## Workflow

![Workflow](flowchart.png)


## Trace

```
task_id	hash	native_id	name	status	exit	submit	duration	realtime	%cpu	rss	vmem	rchar	wchar
1	15/fcbb75	9711	sayHello (saying Hello to world)	CACHED	0	2018-09-28 13:20:23.284	325ms	107ms	0.0%	6.3 MB	26.9 MB	0	0
```

