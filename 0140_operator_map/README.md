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
../bin/nextflow run -with-trace trace.tsv -with-report report.html -with-timeline timeline.html -with-dag flowchart.png workflow.nf --acns '../data/list*.acns.txt'
N E X T F L O W  ~  version 0.32.0
Launching `workflow.nf` [ridiculous_swirles] - revision: 50561d3246
[warm up] executor > local
[98/27f3fb] Submitted process > sortAcns (sorting list3.acns.txt)
[b8/ff16d0] Submitted process > sortAcns (sorting list2.acns.txt)
[0d/093bae] Submitted process > sortAcns (sorting list4.acns.txt)
[c8/d3234f] Submitted process > sortAcns (sorting list1.acns.txt)
[83/03d6e8] Submitted process > commonAcns (comm list1.acns.txt vs list4.acns.txt)
[16/b0dfb4] Submitted process > commonAcns (comm list1.acns.txt vs list3.acns.txt)
[fd/5d71ae] Submitted process > commonAcns (comm list3.acns.txt vs list4.acns.txt)
[4c/d062b4] Submitted process > commonAcns (comm list2.acns.txt vs list3.acns.txt)
[85/e01ddd] Submitted process > commonAcns (comm list2.acns.txt vs list4.acns.txt)
[59/02a009] Submitted process > commonAcns (comm list1.acns.txt vs list2.acns.txt)
```


## Files

```
work/c8/d3234f6099a5dbf1f52dc715f9170c/list1.acns.txt
work/c8/d3234f6099a5dbf1f52dc715f9170c/list1.acns.txt.sorted.txt
work/0d/093baeffd643bed7ed4eb96e786b40/list4.acns.txt
work/0d/093baeffd643bed7ed4eb96e786b40/list4.acns.txt.sorted.txt
work/b8/ff16d088dc0bdbe6823657651d07c4/list2.acns.txt
work/b8/ff16d088dc0bdbe6823657651d07c4/list2.acns.txt.sorted.txt
work/98/27f3fb2173b2daeae99c4ba2d80950/list3.acns.txt
work/98/27f3fb2173b2daeae99c4ba2d80950/list3.acns.txt.sorted.txt
work/83/03d6e8da821eaf33b69c3cb4ca417c/comm.txt
work/16/b0dfb40b32698eac0042ef290d9e28/comm.txt
work/fd/5d71aed45796c683bdf335fe3fcc7b/comm.txt
work/4c/d062b4bfab6d013a23567479a7f1ff/comm.txt
work/85/e01ddd13d0ea194c9cfba7be11ed91/comm.txt
work/59/02a00995d1f45fbc7a89328e8068d9/comm.txt
```



## Workflow

![Workflow](flowchart.png)


## Trace

```
task_id	hash	native_id	name	status	exit	submit	duration	realtime	%cpu	rss	vmem	rchar	wchar
4	0d/093bae	975	sortAcns (sorting list4.acns.txt)	COMPLETED	0	2018-09-28 13:14:49.572	772ms	36ms	0.0%	0	0	0	0
1	c8/d3234f	977	sortAcns (sorting list1.acns.txt)	COMPLETED	0	2018-09-28 13:14:49.591	893ms	115ms	0.0%	0	0	0	0
3	98/27f3fb	969	sortAcns (sorting list3.acns.txt)	COMPLETED	0	2018-09-28 13:14:49.527	966ms	72ms	0.0%	0	0	0	0
2	b8/ff16d0	971	sortAcns (sorting list2.acns.txt)	COMPLETED	0	2018-09-28 13:14:49.560	940ms	68ms	0.0%	0	0	0	0
7	16/b0dfb4	1337	commonAcns (comm list1.acns.txt vs list3.acns.txt)	COMPLETED	0	2018-09-28 13:14:50.536	464ms	38ms	0.0%	0	0	0	0
9	4c/d062b4	1347	commonAcns (comm list2.acns.txt vs list3.acns.txt)	COMPLETED	0	2018-09-28 13:14:50.562	472ms	51ms	0.0%	0	0	0	0
5	83/03d6e8	1335	commonAcns (comm list1.acns.txt vs list4.acns.txt)	COMPLETED	0	2018-09-28 13:14:50.527	582ms	45ms	0.0%	0	0	0	0
6	fd/5d71ae	1344	commonAcns (comm list3.acns.txt vs list4.acns.txt)	COMPLETED	0	2018-09-28 13:14:50.546	611ms	56ms	0.0%	0	0	0	0
10	59/02a009	1761	commonAcns (comm list1.acns.txt vs list2.acns.txt)	COMPLETED	0	2018-09-28 13:14:51.053	338ms	17ms	0.0%	0	0	0	0
8	85/e01ddd	1758	commonAcns (comm list2.acns.txt vs list4.acns.txt)	COMPLETED	0	2018-09-28 13:14:51.017	474ms	22ms	0.0%	0	0	0	0
```

