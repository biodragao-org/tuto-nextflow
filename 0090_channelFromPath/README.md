## nextflow

### ./workflow.nf

```groovy
acn_file_channel = Channel.fromPath( "${params.acns}")

process sortAcns {
	tag "sorting ${acnFile}"
	input:
		file acnFile from acn_file_channel
	output:
		file("${acnFile}.sorted.txt")
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
Launching `workflow.nf` [infallible_chandrasekhar] - revision: 5846808ae4
[warm up] executor > local
[1e/a57678] Submitted process > sortAcns (sorting list1.acns.txt)
[61/07b59f] Submitted process > sortAcns (sorting list2.acns.txt)
[e7/54a076] Submitted process > sortAcns (sorting list4.acns.txt)
[d9/6d86f6] Submitted process > sortAcns (sorting list3.acns.txt)
```


## Files

```
work/61/07b59f900120861d9229e144c0bc7d/list2.acns.txt
work/61/07b59f900120861d9229e144c0bc7d/list2.acns.txt.sorted.txt
work/d9/6d86f64efde038ac903a07c32f85aa/list3.acns.txt
work/d9/6d86f64efde038ac903a07c32f85aa/list3.acns.txt.sorted.txt
work/e7/54a0762378d6bcc914cc53e35e4ff9/list4.acns.txt
work/e7/54a0762378d6bcc914cc53e35e4ff9/list4.acns.txt.sorted.txt
work/1e/a57678d0a8d3cc1a2d78f4a6cb90dd/list1.acns.txt
work/1e/a57678d0a8d3cc1a2d78f4a6cb90dd/list1.acns.txt.sorted.txt
```



## Workflow

![Workflow](flowchart.png)


## Trace

```
task_id	hash	native_id	name	status	exit	submit	duration	realtime	%cpu	rss	vmem	rchar	wchar
2	61/07b59f	10122	sortAcns (sorting list2.acns.txt)	COMPLETED	0	2018-09-28 13:20:35.493	457ms	62ms	0.0%	0	0	0	0
1	1e/a57678	10118	sortAcns (sorting list1.acns.txt)	COMPLETED	0	2018-09-28 13:20:35.462	538ms	39ms	0.0%	0	0	0	0
4	e7/54a076	10127	sortAcns (sorting list4.acns.txt)	COMPLETED	0	2018-09-28 13:20:35.506	499ms	56ms	0.0%	0	0	0	0
3	d9/6d86f6	10131	sortAcns (sorting list3.acns.txt)	COMPLETED	0	2018-09-28 13:20:35.520	495ms	33ms	0.0%	0	0	0	0
```

