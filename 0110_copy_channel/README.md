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
../bin/nextflow run -with-trace trace.tsv -with-report report.html -with-timeline timeline.html -with-dag flowchart.png workflow.nf --acns '../data/list*.acns.txt'
N E X T F L O W  ~  version 0.32.0
Launching `workflow.nf` [friendly_shockley] - revision: 699d554f84
[warm up] executor > local
[0f/1f8102] Submitted process > sortAcns (sorting list3.acns.txt)
[03/19725c] Submitted process > sortAcns (sorting list4.acns.txt)
[1b/af181b] Submitted process > sortAcns (sorting list2.acns.txt)
[f0/6fe768] Submitted process > sortAcns (sorting list1.acns.txt)
CHANNEL 1 : [list3.acns.txt, /comptes/lindenbaum-p/src/tuto-nextflow/0110_copy_channel/work/0f/1f810270c81b815011681af678fd06/list3.acns.txt.sorted.txt]
CHANNEL 2 : [list3.acns.txt, /comptes/lindenbaum-p/src/tuto-nextflow/0110_copy_channel/work/0f/1f810270c81b815011681af678fd06/list3.acns.txt.sorted.txt]
CHANNEL 1 : [list4.acns.txt, /comptes/lindenbaum-p/src/tuto-nextflow/0110_copy_channel/work/03/19725cfbb451aa44034e37b6166789/list4.acns.txt.sorted.txt]
CHANNEL 2 : [list4.acns.txt, /comptes/lindenbaum-p/src/tuto-nextflow/0110_copy_channel/work/03/19725cfbb451aa44034e37b6166789/list4.acns.txt.sorted.txt]
CHANNEL 1 : [list1.acns.txt, /comptes/lindenbaum-p/src/tuto-nextflow/0110_copy_channel/work/f0/6fe76863fe08b3ecc52b862bcb27a7/list1.acns.txt.sorted.txt]
CHANNEL 2 : [list1.acns.txt, /comptes/lindenbaum-p/src/tuto-nextflow/0110_copy_channel/work/f0/6fe76863fe08b3ecc52b862bcb27a7/list1.acns.txt.sorted.txt]
CHANNEL 1 : [list2.acns.txt, /comptes/lindenbaum-p/src/tuto-nextflow/0110_copy_channel/work/1b/af181b8d46a13dc53d76ab0c34314a/list2.acns.txt.sorted.txt]
CHANNEL 2 : [list2.acns.txt, /comptes/lindenbaum-p/src/tuto-nextflow/0110_copy_channel/work/1b/af181b8d46a13dc53d76ab0c34314a/list2.acns.txt.sorted.txt]
```


## Files

```
work/03/19725cfbb451aa44034e37b6166789/list4.acns.txt
work/03/19725cfbb451aa44034e37b6166789/list4.acns.txt.sorted.txt
work/0f/1f810270c81b815011681af678fd06/list3.acns.txt
work/0f/1f810270c81b815011681af678fd06/list3.acns.txt.sorted.txt
work/f0/6fe76863fe08b3ecc52b862bcb27a7/list1.acns.txt
work/f0/6fe76863fe08b3ecc52b862bcb27a7/list1.acns.txt.sorted.txt
work/1b/af181b8d46a13dc53d76ab0c34314a/list2.acns.txt
work/1b/af181b8d46a13dc53d76ab0c34314a/list2.acns.txt.sorted.txt
```



## Workflow

![Workflow](flowchart.png)


## Trace

```
task_id	hash	native_id	name	status	exit	submit	duration	realtime	%cpu	rss	vmem	rchar	wchar
1	0f/1f8102	32221	sortAcns (sorting list3.acns.txt)	COMPLETED	0	2018-09-28 13:14:36.170	523ms	66ms	0.0%	0	0	0	0
2	03/19725c	32226	sortAcns (sorting list4.acns.txt)	COMPLETED	0	2018-09-28 13:14:36.219	575ms	60ms	0.0%	0	0	0	0
3	f0/6fe768	32235	sortAcns (sorting list1.acns.txt)	COMPLETED	0	2018-09-28 13:14:36.251	553ms	54ms	0.0%	0	0	0	0
4	1b/af181b	32229	sortAcns (sorting list2.acns.txt)	COMPLETED	0	2018-09-28 13:14:36.233	671ms	65ms	0.0%	0	0	0	0
```

