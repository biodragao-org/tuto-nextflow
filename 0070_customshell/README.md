## Synopsis
Bien que `bash` soit le shell par défaut. On peut utiliser n'importe quel language, ici `python`.

## nextflow

### ./workflow.nf

```groovy
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
Launching `workflow.nf` [voluminous_cray] - revision: e73cf71896
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
1	e6/335796	5906	sayHello (saying Hello to world)	COMPLETED	0	2018-11-06 10:55:43.731	5.6s	519ms	5.0%	4.2 MB	7.5 MB	242.1 KB	0
```

