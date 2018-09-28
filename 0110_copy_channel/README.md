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

// https://www.nextflow.io/docs/latest/operator.html#view

acn_sorted1.view{F->"CHANNEL 1 : "+F}

acn_sorted2.view{F->"CHANNEL 2 : "+F}
```


## Execute

```
../bin/nextflow run -resume -with-trace trace.tsv -with-report report.html -with-timeline timeline.html -with-dag flowchart.png workflow.nf --acns '../data/list*.acns.txt'
N E X T F L O W  ~  version 0.32.0
Launching `workflow.nf` [angry_hawking] - revision: 699d554f84
[warm up] executor > local
[03/19725c] Cached process > sortAcns (sorting list4.acns.txt)
[0f/1f8102] Cached process > sortAcns (sorting list3.acns.txt)
[f0/6fe768] Cached process > sortAcns (sorting list1.acns.txt)
[1b/af181b] Cached process > sortAcns (sorting list2.acns.txt)
CHANNEL 1 : [list2.acns.txt, /comptes/lindenbaum-p/src/tuto-nextflow/0110_copy_channel/work/1b/af181b8d46a13dc53d76ab0c34314a/list2.acns.txt.sorted.txt]
CHANNEL 1 : [list3.acns.txt, /comptes/lindenbaum-p/src/tuto-nextflow/0110_copy_channel/work/0f/1f810270c81b815011681af678fd06/list3.acns.txt.sorted.txt]
CHANNEL 1 : [list4.acns.txt, /comptes/lindenbaum-p/src/tuto-nextflow/0110_copy_channel/work/03/19725cfbb451aa44034e37b6166789/list4.acns.txt.sorted.txt]
CHANNEL 1 : [list1.acns.txt, /comptes/lindenbaum-p/src/tuto-nextflow/0110_copy_channel/work/f0/6fe76863fe08b3ecc52b862bcb27a7/list1.acns.txt.sorted.txt]
CHANNEL 2 : [list2.acns.txt, /comptes/lindenbaum-p/src/tuto-nextflow/0110_copy_channel/work/1b/af181b8d46a13dc53d76ab0c34314a/list2.acns.txt.sorted.txt]
CHANNEL 2 : [list3.acns.txt, /comptes/lindenbaum-p/src/tuto-nextflow/0110_copy_channel/work/0f/1f810270c81b815011681af678fd06/list3.acns.txt.sorted.txt]
CHANNEL 2 : [list4.acns.txt, /comptes/lindenbaum-p/src/tuto-nextflow/0110_copy_channel/work/03/19725cfbb451aa44034e37b6166789/list4.acns.txt.sorted.txt]
CHANNEL 2 : [list1.acns.txt, /comptes/lindenbaum-p/src/tuto-nextflow/0110_copy_channel/work/f0/6fe76863fe08b3ecc52b862bcb27a7/list1.acns.txt.sorted.txt]
```


## Files

```
work/f0/6fe76863fe08b3ecc52b862bcb27a7/list1.acns.txt
work/f0/6fe76863fe08b3ecc52b862bcb27a7/list1.acns.txt.sorted.txt
work/1b/af181b8d46a13dc53d76ab0c34314a/list2.acns.txt
work/1b/af181b8d46a13dc53d76ab0c34314a/list2.acns.txt.sorted.txt
work/0f/1f810270c81b815011681af678fd06/list3.acns.txt
work/0f/1f810270c81b815011681af678fd06/list3.acns.txt.sorted.txt
work/03/19725cfbb451aa44034e37b6166789/list4.acns.txt
work/03/19725cfbb451aa44034e37b6166789/list4.acns.txt.sorted.txt
```



## Workflow

![Workflow](flowchart.png)


## Trace

```
task_id	hash	native_id	name	status	exit	submit	duration	realtime	%cpu	rss	vmem	rchar	wchar
1	f0/6fe768	10848	sortAcns (sorting list1.acns.txt)	CACHED	0	2018-09-28 13:20:43.759	514ms	61ms	0.0%	0	0	0	0
2	1b/af181b	10829	sortAcns (sorting list2.acns.txt)	CACHED	0	2018-09-28 13:20:43.683	529ms	47ms	0.0%	0	0	0	0
3	0f/1f8102	10834	sortAcns (sorting list3.acns.txt)	CACHED	0	2018-09-28 13:20:43.721	535ms	57ms	0.0%	0	0	0	0
4	03/19725c	10840	sortAcns (sorting list4.acns.txt)	CACHED	0	2018-09-28 13:20:43.734	534ms	67ms	0.0%	0	0	0	0
```

