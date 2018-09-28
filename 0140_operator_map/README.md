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
N E X T F L O W  ~  version 0.32.0
Launching `workflow.nf` [tiny_leakey] - revision: 50561d3246
[warm up] executor > local
[b8/ff16d0] Cached process > sortAcns (sorting list2.acns.txt)
[0d/093bae] Cached process > sortAcns (sorting list4.acns.txt)
[c8/d3234f] Cached process > sortAcns (sorting list1.acns.txt)
[98/27f3fb] Cached process > sortAcns (sorting list3.acns.txt)
[57/11957e] Cached process > commonAcns (comm list2.acns.txt vs list3.acns.txt)
[e5/5f8eda] Cached process > commonAcns (comm list3.acns.txt vs list4.acns.txt)
[f5/c6ea50] Cached process > commonAcns (comm list1.acns.txt vs list3.acns.txt)
[e3/4ebec2] Cached process > commonAcns (comm list1.acns.txt vs list4.acns.txt)
[bc/974983] Cached process > commonAcns (comm list1.acns.txt vs list2.acns.txt)
[de/d26749] Cached process > commonAcns (comm list2.acns.txt vs list4.acns.txt)
```


## Files

```
work/b8/ff16d088dc0bdbe6823657651d07c4/list2.acns.txt
work/b8/ff16d088dc0bdbe6823657651d07c4/list2.acns.txt.sorted.txt
work/c8/d3234f6099a5dbf1f52dc715f9170c/list1.acns.txt
work/c8/d3234f6099a5dbf1f52dc715f9170c/list1.acns.txt.sorted.txt
work/98/27f3fb2173b2daeae99c4ba2d80950/list3.acns.txt
work/98/27f3fb2173b2daeae99c4ba2d80950/list3.acns.txt.sorted.txt
work/0d/093baeffd643bed7ed4eb96e786b40/list4.acns.txt
work/0d/093baeffd643bed7ed4eb96e786b40/list4.acns.txt.sorted.txt
work/e3/4ebec28880b9a9ebecff7ab7d3073f/comm.txt
work/f5/c6ea5085be524f0a5b23749dbb5fc9/comm.txt
work/e5/5f8eda71136eadee2ac76d8694758d/comm.txt
work/de/d26749222a793efcb5548a8aadb93e/comm.txt
work/bc/97498306dbcaf49dd8f0505107cb91/comm.txt
work/57/11957e7fff064fb5447848eddfb98b/comm.txt
```



## Workflow

![Workflow](flowchart.png)


## Trace

```
task_id	hash	native_id	name	status	exit	submit	duration	realtime	%cpu	rss	vmem	rchar	wchar
1	c8/d3234f	11984	sortAcns (sorting list1.acns.txt)	CACHED	0	2018-09-28 13:20:56.817	474ms	36ms	0.0%	0	0	0	0
4	0d/093bae	11983	sortAcns (sorting list4.acns.txt)	CACHED	0	2018-09-28 13:20:56.797	438ms	49ms	0.0%	0	0	0	0
2	98/27f3fb	11967	sortAcns (sorting list3.acns.txt)	CACHED	0	2018-09-28 13:20:56.740	595ms	57ms	0.0%	0	0	0	0
3	b8/ff16d0	11971	sortAcns (sorting list2.acns.txt)	CACHED	0	2018-09-28 13:20:56.774	567ms	55ms	0.0%	0	0	0	0
9	57/11957e	12549	commonAcns (comm list2.acns.txt vs list3.acns.txt)	CACHED	0	2018-09-28 13:20:57.806	342ms	26ms	0.0%	0	0	0	0
7	e5/5f8eda	12273	commonAcns (comm list3.acns.txt vs list4.acns.txt)	CACHED	0	2018-09-28 13:20:57.382	397ms	53ms	0.0%	0	0	0	0
6	f5/c6ea50	12271	commonAcns (comm list1.acns.txt vs list3.acns.txt)	CACHED	0	2018-09-28 13:20:57.371	393ms	62ms	0.0%	0	0	0	0
10	de/d26749	12547	commonAcns (comm list2.acns.txt vs list4.acns.txt)	CACHED	0	2018-09-28 13:20:57.783	333ms	21ms	0.0%	0	0	0	0
5	e3/4ebec2	12264	commonAcns (comm list1.acns.txt vs list4.acns.txt)	CACHED	0	2018-09-28 13:20:57.316	599ms	65ms	0.0%	0	0	0	0
8	bc/974983	12285	commonAcns (comm list1.acns.txt vs list2.acns.txt)	CACHED	0	2018-09-28 13:20:57.405	410ms	41ms	0.0%	0	0	0	0
```

