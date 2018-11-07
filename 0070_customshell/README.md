## Synopsis

Bien que `bash` soit le shell par défaut. On peut utiliser n'importe quel language, ici `python`.

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
 11   """
 12   #!/usr/bin/env python
 13   x =  "${params.salutation}"
 14   y =  "${params.name}" 
 15   f = open("message.txt", "w") 
 16   f.write( "%s - %s !" % (x,y) )
 17   f.close()
 18   """
 19   }
```


## Execute

```
../bin/nextflow run -resume -with-trace trace.tsv -with-report report.html -with-timeline timeline.html -with-dag flowchart.png workflow.nf 
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [voluminous_turing] - revision: e73cf71896
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
1	e6/335796	15194	sayHello (saying Hello to world)	COMPLETED	0	2018-11-07 10:10:04.696	5.9s	856ms	5.0%	4 MB	7.5 MB	241.9 KB	0
```

