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
	tag "comm ${label}"
	input:
		set label,sorted1,sorted2 from acn_sorted1.
                                          combine(acn_sorted2).
                                          filter{ROW->ROW[0].getName().compareTo(ROW[2].getName())<0}.
					  map{ROW->[ ROW[0].getName() + " vs " + ROW[2].getName() , ROW[1] , ROW[3] ] }
	output:
		set label,file("comm.txt")
	script:
	"""
	comm -12 "${sorted1}" "${sorted2}" > comm.txt
	"""
}
```


## Execute

```
../bin/nextflow run -resume -with-trace trace.tsv -with-report report.html -with-timeline timeline.html -with-dag flowchart.png workflow.nf --acns '../data/list*.acns.txt'
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [chaotic_chandrasekhar] - revision: 50561d3246
[warm up] executor > local
[3a/5a3670] Submitted process > sortAcns (sorting list4.acns.txt)
[da/26776d] Submitted process > sortAcns (sorting list3.acns.txt)
[c8/c1e9f0] Submitted process > sortAcns (sorting list2.acns.txt)
[df/dafc28] Submitted process > sortAcns (sorting list1.acns.txt)
[97/424ad8] Submitted process > commonAcns (comm list3.acns.txt vs list4.acns.txt)
[ce/24607f] Submitted process > commonAcns (comm list2.acns.txt vs list3.acns.txt)
[93/a67216] Submitted process > commonAcns (comm list2.acns.txt vs list4.acns.txt)
[0a/52aa97] Submitted process > commonAcns (comm list1.acns.txt vs list3.acns.txt)
[d6/7de148] Submitted process > commonAcns (comm list1.acns.txt vs list2.acns.txt)
[f3/a4d31d] Submitted process > commonAcns (comm list1.acns.txt vs list4.acns.txt)
```


## Files

```
work/97/424ad8060087b11e031dbfa64f66b7/comm.txt
work/f3/a4d31d98ff7f9efcdb24ff2c05b789/comm.txt
work/93/a672161419c7bd30c654539d58af96/comm.txt
work/0a/52aa9768288a8c8aa7bfc7efb332ad/comm.txt
work/c8/c1e9f0255063f93349022edd143185/list2.acns.txt.sorted.txt
work/c8/c1e9f0255063f93349022edd143185/list2.acns.txt
work/da/26776d1d143b2fdb5e6a4fc3b69c87/list3.acns.txt
work/da/26776d1d143b2fdb5e6a4fc3b69c87/list3.acns.txt.sorted.txt
work/3a/5a36708cdd8e1b827d6b5424372d24/list4.acns.txt.sorted.txt
work/3a/5a36708cdd8e1b827d6b5424372d24/list4.acns.txt
work/df/dafc28caacc205fdfecfe2a6d02bbd/list1.acns.txt.sorted.txt
work/df/dafc28caacc205fdfecfe2a6d02bbd/list1.acns.txt
work/d6/7de1482dc893fc0f0040f5a246e56e/comm.txt
work/ce/24607fcbad04821374abb644d4174e/comm.txt
```



## Workflow

![Workflow](flowchart.png)


## Trace

```
task_id	hash	native_id	name	status	exit	submit	duration	realtime	%cpu	rss	vmem	rchar	wchar
2	3a/5a3670	993	sortAcns (sorting list4.acns.txt)	COMPLETED	0	2018-11-02 16:10:25.700	425ms	35ms	0.0%	0	0	0	0
1	da/26776d	1035	sortAcns (sorting list3.acns.txt)	COMPLETED	0	2018-11-02 16:10:25.837	412ms	41ms	0.0%	0	0	0	0
3	c8/c1e9f0	1116	sortAcns (sorting list2.acns.txt)	COMPLETED	0	2018-11-02 16:10:26.151	535ms	31ms	0.0%	0	0	0	0
4	df/dafc28	1134	sortAcns (sorting list1.acns.txt)	COMPLETED	0	2018-11-02 16:10:26.291	436ms	50ms	0.0%	0	0	0	0
5	97/424ad8	1240	commonAcns (comm list3.acns.txt vs list4.acns.txt)	COMPLETED	0	2018-11-02 16:10:26.705	340ms	42ms	0.0%	0	0	0	0
6	ce/24607f	1261	commonAcns (comm list2.acns.txt vs list3.acns.txt)	COMPLETED	0	2018-11-02 16:10:26.736	351ms	33ms	0.0%	0	0	0	0
7	93/a67216	1365	commonAcns (comm list2.acns.txt vs list4.acns.txt)	COMPLETED	0	2018-11-02 16:10:27.054	255ms	24ms	0.0%	0	0	0	0
8	0a/52aa97	1397	commonAcns (comm list1.acns.txt vs list3.acns.txt)	COMPLETED	0	2018-11-02 16:10:27.113	262ms	42ms	0.0%	0	0	0	0
10	d6/7de148	1504	commonAcns (comm list1.acns.txt vs list2.acns.txt)	COMPLETED	0	2018-11-02 16:10:27.328	327ms	37ms	0.0%	0	0	0	0
9	f3/a4d31d	1532	commonAcns (comm list1.acns.txt vs list4.acns.txt)	COMPLETED	0	2018-11-02 16:10:27.381	294ms	29ms	0.0%	0	0	0	0
```

