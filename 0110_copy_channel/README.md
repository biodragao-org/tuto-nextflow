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
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [angry_carson] - revision: 699d554f84
[warm up] executor > local
[12/9ba80d] Submitted process > sortAcns (sorting list3.acns.txt)
[54/6855e9] Submitted process > sortAcns (sorting list4.acns.txt)
[3e/8de4da] Submitted process > sortAcns (sorting list2.acns.txt)
CHANNEL 1 : [list4.acns.txt, /home/lindenb/src/tuto-nextflow/0110_copy_channel/work/54/6855e9c434fdf9c6610035cf519edc/list4.acns.txt.sorted.txt]
CHANNEL 2 : [list4.acns.txt, /home/lindenb/src/tuto-nextflow/0110_copy_channel/work/54/6855e9c434fdf9c6610035cf519edc/list4.acns.txt.sorted.txt]
[e5/de0f17] Submitted process > sortAcns (sorting list1.acns.txt)
CHANNEL 1 : [list3.acns.txt, /home/lindenb/src/tuto-nextflow/0110_copy_channel/work/12/9ba80d0d51efe08d856842409f0cef/list3.acns.txt.sorted.txt]
CHANNEL 2 : [list3.acns.txt, /home/lindenb/src/tuto-nextflow/0110_copy_channel/work/12/9ba80d0d51efe08d856842409f0cef/list3.acns.txt.sorted.txt]
CHANNEL 1 : [list2.acns.txt, /home/lindenb/src/tuto-nextflow/0110_copy_channel/work/3e/8de4da9e1c9a316ea68c4c2120ba94/list2.acns.txt.sorted.txt]
CHANNEL 2 : [list2.acns.txt, /home/lindenb/src/tuto-nextflow/0110_copy_channel/work/3e/8de4da9e1c9a316ea68c4c2120ba94/list2.acns.txt.sorted.txt]
CHANNEL 1 : [list1.acns.txt, /home/lindenb/src/tuto-nextflow/0110_copy_channel/work/e5/de0f17bae27d902cec77627137d856/list1.acns.txt.sorted.txt]
CHANNEL 2 : [list1.acns.txt, /home/lindenb/src/tuto-nextflow/0110_copy_channel/work/e5/de0f17bae27d902cec77627137d856/list1.acns.txt.sorted.txt]
```


## Files

```
work/3e/8de4da9e1c9a316ea68c4c2120ba94/list2.acns.txt.sorted.txt
work/3e/8de4da9e1c9a316ea68c4c2120ba94/list2.acns.txt
work/12/9ba80d0d51efe08d856842409f0cef/list3.acns.txt
work/12/9ba80d0d51efe08d856842409f0cef/list3.acns.txt.sorted.txt
work/e5/de0f17bae27d902cec77627137d856/list1.acns.txt.sorted.txt
work/e5/de0f17bae27d902cec77627137d856/list1.acns.txt
work/54/6855e9c434fdf9c6610035cf519edc/list4.acns.txt.sorted.txt
work/54/6855e9c434fdf9c6610035cf519edc/list4.acns.txt
```



## Workflow

![Workflow](flowchart.png)


## Trace

```
task_id	hash	native_id	name	status	exit	submit	duration	realtime	%cpu	rss	vmem	rchar	wchar
2	54/6855e9	31119	sortAcns (sorting list4.acns.txt)	COMPLETED	0	2018-11-02 16:09:57.571	290ms	48ms	0.0%	0	0	0	0
1	12/9ba80d	31114	sortAcns (sorting list3.acns.txt)	COMPLETED	0	2018-11-02 16:09:57.480	613ms	66ms	0.0%	0	0	0	0
3	3e/8de4da	31240	sortAcns (sorting list2.acns.txt)	COMPLETED	0	2018-11-02 16:09:57.895	404ms	56ms	0.0%	0	0	0	0
4	e5/de0f17	31292	sortAcns (sorting list1.acns.txt)	COMPLETED	0	2018-11-02 16:09:58.098	383ms	56ms	0.0%	0	0	0	0
```

