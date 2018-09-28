## nextflow

### ./workflow.nf

```groovy
acn_file_channel = Channel.fromPath( "${params.acns}")

process sortAcns {
	tag "sorting ${acnFile}"
	input:
		file acnFile from acn_file_channel
	output:
		set acnFile, file("${acnFile}.sorted.txt")
	script:
	
	"""
	sort '${acnFile}' > "${acnFile}.sorted.txt"
	"""
}
```


## Execute

```
../bin/nextflow run -with-trace trace.tsv -with-report report.html -with-timeline timeline.html -with-dag flowchart.png workflow.nf --acns '../data/list*.acns.txt'
N E X T F L O W  ~  version 0.32.0
Launching `workflow.nf` [lethal_brattain] - revision: efdcb56eb1
[warm up] executor > local
[77/df90f3] Submitted process > sortAcns (sorting list2.acns.txt)
[62/efc0a5] Submitted process > sortAcns (sorting list3.acns.txt)
[c9/a6b603] Submitted process > sortAcns (sorting list4.acns.txt)
[38/77dae1] Submitted process > sortAcns (sorting list1.acns.txt)
```


## Files

```
work/c9/a6b6039c599956d0d7c51b45c8e37e/list4.acns.txt
work/c9/a6b6039c599956d0d7c51b45c8e37e/list4.acns.txt.sorted.txt
work/38/77dae1e6a97e24eaeb5eda19712c27/list1.acns.txt
work/38/77dae1e6a97e24eaeb5eda19712c27/list1.acns.txt.sorted.txt
work/62/efc0a56192c779c3a403c9a4115829/list3.acns.txt
work/62/efc0a56192c779c3a403c9a4115829/list3.acns.txt.sorted.txt
work/77/df90f335ff1bd68689af2244b8369d/list2.acns.txt
work/77/df90f335ff1bd68689af2244b8369d/list2.acns.txt.sorted.txt
```



## Workflow

![Workflow](flowchart.png)


## Trace

```
task_id	hash	native_id	name	status	exit	submit	duration	realtime	%cpu	rss	vmem	rchar	wchar
3	77/df90f3	31852	sortAcns (sorting list2.acns.txt)	COMPLETED	0	2018-09-28 13:14:31.793	439ms	43ms	0.0%	0	0	0	0
2	62/efc0a5	31856	sortAcns (sorting list3.acns.txt)	COMPLETED	0	2018-09-28 13:14:31.825	473ms	27ms	0.0%	0	0	0	0
4	c9/a6b603	31861	sortAcns (sorting list4.acns.txt)	COMPLETED	0	2018-09-28 13:14:31.847	456ms	38ms	0.0%	0	0	0	0
1	38/77dae1	31867	sortAcns (sorting list1.acns.txt)	COMPLETED	0	2018-09-28 13:14:31.859	474ms	42ms	0.0%	0	0	0	0
```

