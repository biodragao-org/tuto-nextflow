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
		set acn1,sorted1,acn2,sorted2 from acn_sorted1.combine(acn_sorted2)
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
Launching `workflow.nf` [disturbed_heyrovsky] - revision: 58a06a28ba
[warm up] executor > local
[94/0bbf80] Cached process > sortAcns (sorting list1.acns.txt)
[77/d746a6] Cached process > sortAcns (sorting list2.acns.txt)
[f1/2e7c0d] Cached process > sortAcns (sorting list4.acns.txt)
[8f/cd8b70] Cached process > sortAcns (sorting list3.acns.txt)
ERROR ~ Error executing process > 'commonAcns (comm list2.acns.txt.sorted.txt and list2.acns.txt.sorted.txt)'

Caused by:
  java.nio.file.ProviderMismatchException


 -- Check '.nextflow.log' file for details
Makefile:4: recipe for target 'all' failed
make[1]: *** [all] Error 1
```


## Files

```
work/77/d746a6ba85a52b2bca4c6499708a53/list2.acns.txt
work/77/d746a6ba85a52b2bca4c6499708a53/list2.acns.txt.sorted.txt
work/f1/2e7c0d7b50fd16d698e3c6b8af03b4/list4.acns.txt
work/f1/2e7c0d7b50fd16d698e3c6b8af03b4/list4.acns.txt.sorted.txt
work/94/0bbf8015956679e17672231696087a/list1.acns.txt
work/94/0bbf8015956679e17672231696087a/list1.acns.txt.sorted.txt
work/8f/cd8b70f22a52f78d5b194c7059aee3/list3.acns.txt
work/8f/cd8b70f22a52f78d5b194c7059aee3/list3.acns.txt.sorted.txt
```



## Workflow

![Workflow](flowchart.png)


## Trace

```
task_id	hash	native_id	name	status	exit	submit	duration	realtime	%cpu	rss	vmem	rchar	wchar
1	94/0bbf80	11193	sortAcns (sorting list1.acns.txt)	CACHED	-	2018-09-28 13:20:48.151	-	-	-	-	-	-	-
4	8f/cd8b70	11199	sortAcns (sorting list3.acns.txt)	CACHED	-	2018-09-28 13:20:48.170	-	-	-	-	-	-	-
3	f1/2e7c0d	11182	sortAcns (sorting list4.acns.txt)	CACHED	0	2018-09-28 13:20:48.119	441ms	46ms	0.0%	0	0	0	0
2	77/d746a6	11179	sortAcns (sorting list2.acns.txt)	CACHED	-	2018-09-28 13:20:48.087	-	-	-	-	-	-	-
```

