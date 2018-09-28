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
../bin/nextflow run -resume -with-trace trace.tsv -with-report report.html -with-timeline timeline.html -with-dag flowchart.png workflow.nf --acns '../data/list*.acns.txt'
N E X T F L O W  ~  version 0.32.0
Launching `workflow.nf` [desperate_coulomb] - revision: efdcb56eb1
[warm up] executor > local
[62/efc0a5] Cached process > sortAcns (sorting list3.acns.txt)
[77/df90f3] Cached process > sortAcns (sorting list2.acns.txt)
[38/77dae1] Cached process > sortAcns (sorting list1.acns.txt)
[c9/a6b603] Cached process > sortAcns (sorting list4.acns.txt)
```


## Files

```
work/77/df90f335ff1bd68689af2244b8369d/list2.acns.txt
work/77/df90f335ff1bd68689af2244b8369d/list2.acns.txt.sorted.txt
work/c9/a6b6039c599956d0d7c51b45c8e37e/list4.acns.txt
work/c9/a6b6039c599956d0d7c51b45c8e37e/list4.acns.txt.sorted.txt
work/38/77dae1e6a97e24eaeb5eda19712c27/list1.acns.txt
work/38/77dae1e6a97e24eaeb5eda19712c27/list1.acns.txt.sorted.txt
work/62/efc0a56192c779c3a403c9a4115829/list3.acns.txt
work/62/efc0a56192c779c3a403c9a4115829/list3.acns.txt.sorted.txt
```



## Workflow

![Workflow](flowchart.png)


## Trace

```
task_id	hash	native_id	name	status	exit	submit	duration	realtime	%cpu	rss	vmem	rchar	wchar
3	62/efc0a5	10505	sortAcns (sorting list3.acns.txt)	CACHED	0	2018-09-28 13:20:39.666	523ms	50ms	0.0%	0	0	0	0
1	38/77dae1	10486	sortAcns (sorting list1.acns.txt)	CACHED	0	2018-09-28 13:20:39.573	490ms	23ms	0.0%	0	0	0	0
4	c9/a6b603	10489	sortAcns (sorting list4.acns.txt)	CACHED	0	2018-09-28 13:20:39.619	536ms	30ms	0.0%	0	0	0	0
2	77/df90f3	10500	sortAcns (sorting list2.acns.txt)	CACHED	0	2018-09-28 13:20:39.651	524ms	26ms	0.0%	0	0	0	0
```

