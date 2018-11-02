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
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [spontaneous_jennings] - revision: db56321d98
[warm up] executor > local
[e6/335796] Submitted process > sayHello (saying Hello to world)
```


## Files

```
work/e6/3357967e7f7b16cec6c5fe2f2725bf/message.txt
```



## Workflow

![Workflow](flowchart.png)


## Trace

```
task_id	hash	native_id	name	status	exit	submit	duration	realtime	%cpu	rss	vmem	rchar	wchar
1	e6/335796	30031	sayHello (saying Hello to world)	COMPLETED	0	2018-11-02 16:09:13.353	5.8s	866ms	3.8%	4.1 MB	7.5 MB	241.9 KB	0
```

