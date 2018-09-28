## nextflow

### ./workflow.nf

```groovy
acn_file_channel = Channel.fromPath( "${params.acns}")

process sortAcns {
	tag "sorting ${acnFile}"
	input:
		file acnFile from acn_file_channel
	output:
		set acnFile, file("${acnFile}.sorted.txt") into (acn_sorted1,acn_sorted2)
	script:
	
	"""
	sort '${acnFile}' > "${acnFile}.sorted.txt"
	"""
}

process commonAcns {
	tag "comm ${sorted1.getName()} and ${sorted2.getName()}"
	input:
		set acn1,sorted1,acn2,sorted2 from acn_sorted1.
                                          combine(acn_sorted2).
                                          filter{ROW->ROW[1].getName().compareTo(ROW[3].getName())<0}
	output:
		set acn1,acn2,file("comm.txt")
	script:
	"""
	comm -12 "${sorted1}" "${sorted2}" > comm.txt
	"""
}
```


## Execute

```
../bin/nextflow run -resume -with-trace trace.tsv -with-report report.html -with-timeline timeline.html -with-dag flowchart.png workflow.nf --acns '../data/list*.acns.txt'
N E X T F L O W  ~  version 0.32.0
Launching `workflow.nf` [determined_becquerel] - revision: 41d209f8fc
[warm up] executor > local
[1b/a0b2e1] Submitted process > sortAcns (sorting list3.acns.txt)
[5f/2e1a9c] Submitted process > sortAcns (sorting list1.acns.txt)
[a5/69e3c0] Submitted process > sortAcns (sorting list2.acns.txt)
[ae/0a7064] Submitted process > sortAcns (sorting list4.acns.txt)
ERROR ~ Error executing process > 'commonAcns (comm list1.acns.txt.sorted.txt and list4.acns.txt.sorted.txt)'

Caused by:
  java.nio.file.ProviderMismatchException


 -- Check '.nextflow.log' file for details
WARN: Killing pending tasks (1)
Makefile:4: recipe for target 'all' failed
make[1]: *** [all] Error 1
```


## Files

```
work/ae/0a706405727cf7cf5c1b85229aaf35/list4.acns.txt
work/ae/0a706405727cf7cf5c1b85229aaf35/list4.acns.txt.sorted.txt
work/a5/69e3c097a0e885bf49906dc3b26d06/list2.acns.txt
work/a5/69e3c097a0e885bf49906dc3b26d06/list2.acns.txt.sorted.txt
work/5f/2e1a9c53db6610d6035eeb9d6dae00/list1.acns.txt
work/5f/2e1a9c53db6610d6035eeb9d6dae00/list1.acns.txt.sorted.txt
work/1b/a0b2e1ce35cf6c209c3955883b27cb/list3.acns.txt
work/1b/a0b2e1ce35cf6c209c3955883b27cb/list3.acns.txt.sorted.txt
```



## Workflow

![Workflow](flowchart.png)


## Trace

```
task_id	hash	native_id	name	status	exit	submit	duration	realtime	%cpu	rss	vmem	rchar	wchar
1	5f/2e1a9c	11575	sortAcns (sorting list1.acns.txt)	COMPLETED	0	2018-09-28 13:20:52.347	492ms	42ms	0.0%	0	0	0	0
4	ae/0a7064	11589	sortAcns (sorting list4.acns.txt)	COMPLETED	0	2018-09-28 13:20:52.391	489ms	30ms	0.0%	0	0	0	0
2	a5/69e3c0	11585	sortAcns (sorting list2.acns.txt)	COMPLETED	0	2018-09-28 13:20:52.371	524ms	49ms	0.0%	0	0	0	0
3	1b/a0b2e1	11573	sortAcns (sorting list3.acns.txt)	ABORTED	-	2018-09-28 13:20:52.317	-	-	-	-	-	-	-
```

