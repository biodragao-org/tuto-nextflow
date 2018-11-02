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
		set acn1,sorted1,acn2,sorted2 from acn_sorted1.
                                          combine(acn_sorted2).
                                          filter{ROW->ROW[1].getName().compareTo(ROW[3].getName())<0}
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
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [stupefied_gautier] - revision: 41d209f8fc
[warm up] executor > local
[5d/0c6d2a] Submitted process > sortAcns (sorting list3.acns.txt)
[f9/f8f00f] Submitted process > sortAcns (sorting list4.acns.txt)
[b1/f2ef87] Submitted process > sortAcns (sorting list2.acns.txt)
[ee/26ed46] Submitted process > sortAcns (sorting list1.acns.txt)
[0e/374c95] Submitted process > commonAcns (comm list3.acns.txt.sorted.txt and list4.acns.txt.sorted.txt)
[eb/a45348] Submitted process > commonAcns (comm list2.acns.txt.sorted.txt and list3.acns.txt.sorted.txt)
[3f/fbe7cb] Submitted process > commonAcns (comm list2.acns.txt.sorted.txt and list4.acns.txt.sorted.txt)
[16/93a72d] Submitted process > commonAcns (comm list1.acns.txt.sorted.txt and list4.acns.txt.sorted.txt)
[52/5e4835] Submitted process > commonAcns (comm list1.acns.txt.sorted.txt and list2.acns.txt.sorted.txt)
[e4/8f8fe2] Submitted process > commonAcns (comm list1.acns.txt.sorted.txt and list3.acns.txt.sorted.txt)
```


## Files

```
work/f9/f8f00fd0419f8692f1fada74269a56/list4.acns.txt.sorted.txt
work/f9/f8f00fd0419f8692f1fada74269a56/list4.acns.txt
work/ee/26ed46d55250f023486c028e12b35a/list1.acns.txt.sorted.txt
work/ee/26ed46d55250f023486c028e12b35a/list1.acns.txt
work/e4/8f8fe216efa01d1003cd8b61b6e751/comm.txt
work/16/93a72d3a82357caf76dabc1387b88f/comm.txt
work/0e/374c9595830d4741f08496f4a46607/comm.txt
work/5d/0c6d2ae9f4e00771e702938f19c1fa/list3.acns.txt
work/5d/0c6d2ae9f4e00771e702938f19c1fa/list3.acns.txt.sorted.txt
work/eb/a4534816f35c4f35167e68f788c690/comm.txt
work/52/5e48357b4e243a57867978686bee80/comm.txt
work/b1/f2ef87ccffc9b84a65f00fe91c9e4d/list2.acns.txt.sorted.txt
work/b1/f2ef87ccffc9b84a65f00fe91c9e4d/list2.acns.txt
work/3f/fbe7cb75878c360324400e06f580b7/comm.txt
```



## Workflow

![Workflow](flowchart.png)


## Trace

```
task_id	hash	native_id	name	status	exit	submit	duration	realtime	%cpu	rss	vmem	rchar	wchar
2	5d/0c6d2a	32741	sortAcns (sorting list3.acns.txt)	COMPLETED	0	2018-11-02 16:10:16.776	406ms	40ms	0.0%	0	0	0	0
1	f9/f8f00f	32747	sortAcns (sorting list4.acns.txt)	COMPLETED	0	2018-11-02 16:10:16.868	450ms	33ms	0.0%	0	0	0	0
3	b1/f2ef87	397	sortAcns (sorting list2.acns.txt)	COMPLETED	0	2018-11-02 16:10:17.202	534ms	47ms	0.0%	0	0	0	0
4	ee/26ed46	427	sortAcns (sorting list1.acns.txt)	COMPLETED	0	2018-11-02 16:10:17.338	474ms	27ms	0.0%	0	0	0	0
7	eb/a45348	549	commonAcns (comm list2.acns.txt.sorted.txt and list3.acns.txt.sorted.txt)	COMPLETED	0	2018-11-02 16:10:17.839	340ms	21ms	0.0%	0	0	0	0
5	0e/374c95	521	commonAcns (comm list3.acns.txt.sorted.txt and list4.acns.txt.sorted.txt)	COMPLETED	0	2018-11-02 16:10:17.757	523ms	79ms	0.0%	0	0	0	0
6	3f/fbe7cb	652	commonAcns (comm list2.acns.txt.sorted.txt and list4.acns.txt.sorted.txt)	COMPLETED	0	2018-11-02 16:10:18.207	482ms	28ms	0.0%	0	0	0	0
8	16/93a72d	670	commonAcns (comm list1.acns.txt.sorted.txt and list4.acns.txt.sorted.txt)	COMPLETED	0	2018-11-02 16:10:18.299	412ms	38ms	0.0%	0	0	0	0
10	52/5e4835	789	commonAcns (comm list1.acns.txt.sorted.txt and list2.acns.txt.sorted.txt)	COMPLETED	0	2018-11-02 16:10:18.696	337ms	25ms	0.0%	0	0	0	0
9	e4/8f8fe2	791	commonAcns (comm list1.acns.txt.sorted.txt and list3.acns.txt.sorted.txt)	COMPLETED	0	2018-11-02 16:10:18.724	347ms	33ms	0.0%	0	0	0	0
```

