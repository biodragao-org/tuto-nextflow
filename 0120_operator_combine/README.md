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
		set acn1,sorted1,acn2,sorted2 from acn_sorted1.combine(acn_sorted2)
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
Launching `workflow.nf` [peaceful_heisenberg] - revision: 58a06a28ba
[warm up] executor > local
[d8/178946] Submitted process > sortAcns (sorting list3.acns.txt)
[a2/d5eda9] Submitted process > sortAcns (sorting list4.acns.txt)
[f2/791801] Submitted process > sortAcns (sorting list1.acns.txt)
[9d/3d7781] Submitted process > sortAcns (sorting list2.acns.txt)
[cb/8f01c8] Submitted process > commonAcns (comm list3.acns.txt.sorted.txt and list3.acns.txt.sorted.txt)
[fb/0a3c89] Submitted process > commonAcns (comm list3.acns.txt.sorted.txt and list4.acns.txt.sorted.txt)
[6b/e8c7f8] Submitted process > commonAcns (comm list4.acns.txt.sorted.txt and list3.acns.txt.sorted.txt)
[83/a5e174] Submitted process > commonAcns (comm list4.acns.txt.sorted.txt and list4.acns.txt.sorted.txt)
[e3/eb2e04] Submitted process > commonAcns (comm list1.acns.txt.sorted.txt and list4.acns.txt.sorted.txt)
[40/605871] Submitted process > commonAcns (comm list1.acns.txt.sorted.txt and list3.acns.txt.sorted.txt)
[2c/2691fa] Submitted process > commonAcns (comm list3.acns.txt.sorted.txt and list1.acns.txt.sorted.txt)
[0c/e5e5cf] Submitted process > commonAcns (comm list1.acns.txt.sorted.txt and list1.acns.txt.sorted.txt)
[98/18565f] Submitted process > commonAcns (comm list4.acns.txt.sorted.txt and list1.acns.txt.sorted.txt)
[d8/9fc0d8] Submitted process > commonAcns (comm list2.acns.txt.sorted.txt and list3.acns.txt.sorted.txt)
[d0/2ced57] Submitted process > commonAcns (comm list2.acns.txt.sorted.txt and list4.acns.txt.sorted.txt)
[5d/673cd1] Submitted process > commonAcns (comm list3.acns.txt.sorted.txt and list2.acns.txt.sorted.txt)
[55/3a64ab] Submitted process > commonAcns (comm list2.acns.txt.sorted.txt and list1.acns.txt.sorted.txt)
[73/1f1e92] Submitted process > commonAcns (comm list4.acns.txt.sorted.txt and list2.acns.txt.sorted.txt)
[95/4df6d2] Submitted process > commonAcns (comm list1.acns.txt.sorted.txt and list2.acns.txt.sorted.txt)
[91/336a0d] Submitted process > commonAcns (comm list2.acns.txt.sorted.txt and list2.acns.txt.sorted.txt)
```


## Files

```
work/98/18565f2eccd00958f923f5e9f237b1/comm.txt
work/cb/8f01c87b0be3cda45445623ee46fc1/comm.txt
work/6b/e8c7f84b360e4ff5823afe7b658a81/comm.txt
work/fb/0a3c891a40c9fb6112ca066933f9e1/comm.txt
work/d8/9fc0d8cf754e05627cb0beea7e43cf/comm.txt
work/d8/17894647d00cb707b48cab66c78bc4/list3.acns.txt
work/d8/17894647d00cb707b48cab66c78bc4/list3.acns.txt.sorted.txt
work/9d/3d7781c39fde2aa34413886c6390b7/list2.acns.txt.sorted.txt
work/9d/3d7781c39fde2aa34413886c6390b7/list2.acns.txt
work/95/4df6d292c135895f1892a89337f8b0/comm.txt
work/f2/7918019c161dde6686ca1ebc2c7fe8/list1.acns.txt.sorted.txt
work/f2/7918019c161dde6686ca1ebc2c7fe8/list1.acns.txt
work/a2/d5eda93055b60258c8367ee99c60d5/list4.acns.txt.sorted.txt
work/a2/d5eda93055b60258c8367ee99c60d5/list4.acns.txt
work/73/1f1e927b09f8507fdfde8b794310c4/comm.txt
work/5d/673cd1fd4f3a65230068b4a3d613ef/comm.txt
work/83/a5e174fb857997d2a603411634c856/comm.txt
work/e3/eb2e04cf4839d098ab1f4669bbb6b3/comm.txt
work/91/336a0d8ed4137f7f6e87b1763ee793/comm.txt
work/2c/2691faedce1405a197cd0d9064b552/comm.txt
work/55/3a64ab41b173e09e567d11b1674030/comm.txt
work/0c/e5e5cf78d6eef6f4fb1943ec3015c1/comm.txt
work/40/6058712c3540b584366ecf73cd454c/comm.txt
work/d0/2ced579597f33ebc6e6b885f873c9b/comm.txt
```



## Workflow

![Workflow](flowchart.png)


## Trace

```
task_id	hash	native_id	name	status	exit	submit	duration	realtime	%cpu	rss	vmem	rchar	wchar
1	d8/178946	31444	sortAcns (sorting list3.acns.txt)	COMPLETED	0	2018-11-02 16:10:05.680	456ms	22ms	0.0%	0	0	0	0
2	a2/d5eda9	31461	sortAcns (sorting list4.acns.txt)	COMPLETED	0	2018-11-02 16:10:05.811	473ms	29ms	0.0%	0	0	0	0
3	f2/791801	31568	sortAcns (sorting list1.acns.txt)	COMPLETED	0	2018-11-02 16:10:06.174	317ms	23ms	0.0%	0	0	0	0
4	9d/3d7781	31608	sortAcns (sorting list2.acns.txt)	COMPLETED	0	2018-11-02 16:10:06.300	289ms	44ms	0.0%	0	0	0	0
5	cb/8f01c8	31691	commonAcns (comm list3.acns.txt.sorted.txt and list3.acns.txt.sorted.txt)	COMPLETED	0	2018-11-02 16:10:06.508	315ms	35ms	0.0%	0	0	0	0
7	fb/0a3c89	31746	commonAcns (comm list3.acns.txt.sorted.txt and list4.acns.txt.sorted.txt)	COMPLETED	0	2018-11-02 16:10:06.615	274ms	53ms	0.0%	0	0	0	0
6	6b/e8c7f8	31832	commonAcns (comm list4.acns.txt.sorted.txt and list3.acns.txt.sorted.txt)	COMPLETED	0	2018-11-02 16:10:06.831	286ms	43ms	0.0%	0	0	0	0
8	83/a5e174	31859	commonAcns (comm list4.acns.txt.sorted.txt and list4.acns.txt.sorted.txt)	COMPLETED	0	2018-11-02 16:10:06.905	263ms	23ms	0.0%	0	0	0	0
9	e3/eb2e04	31950	commonAcns (comm list1.acns.txt.sorted.txt and list4.acns.txt.sorted.txt)	COMPLETED	0	2018-11-02 16:10:07.126	410ms	59ms	0.0%	0	0	0	0
10	40/605871	31965	commonAcns (comm list1.acns.txt.sorted.txt and list3.acns.txt.sorted.txt)	COMPLETED	0	2018-11-02 16:10:07.179	373ms	34ms	0.0%	0	0	0	0
11	2c/2691fa	32069	commonAcns (comm list3.acns.txt.sorted.txt and list1.acns.txt.sorted.txt)	COMPLETED	0	2018-11-02 16:10:07.542	311ms	43ms	0.0%	0	0	0	0
13	0c/e5e5cf	32071	commonAcns (comm list1.acns.txt.sorted.txt and list1.acns.txt.sorted.txt)	COMPLETED	0	2018-11-02 16:10:07.571	303ms	32ms	0.0%	0	0	0	0
12	98/18565f	32187	commonAcns (comm list4.acns.txt.sorted.txt and list1.acns.txt.sorted.txt)	COMPLETED	0	2018-11-02 16:10:07.861	365ms	29ms	0.0%	0	0	0	0
15	d8/9fc0d8	32202	commonAcns (comm list2.acns.txt.sorted.txt and list3.acns.txt.sorted.txt)	COMPLETED	0	2018-11-02 16:10:07.895	381ms	43ms	0.0%	0	0	0	0
16	5d/673cd1	32312	commonAcns (comm list3.acns.txt.sorted.txt and list2.acns.txt.sorted.txt)	COMPLETED	0	2018-11-02 16:10:08.307	238ms	29ms	0.0%	0	0	0	0
14	d0/2ced57	32304	commonAcns (comm list2.acns.txt.sorted.txt and list4.acns.txt.sorted.txt)	COMPLETED	0	2018-11-02 16:10:08.236	349ms	43ms	0.0%	0	0	0	0
17	55/3a64ab	32422	commonAcns (comm list2.acns.txt.sorted.txt and list1.acns.txt.sorted.txt)	COMPLETED	0	2018-11-02 16:10:08.552	283ms	27ms	0.0%	0	0	0	0
19	73/1f1e92	32428	commonAcns (comm list4.acns.txt.sorted.txt and list2.acns.txt.sorted.txt)	COMPLETED	0	2018-11-02 16:10:08.589	273ms	26ms	0.0%	0	0	0	0
18	95/4df6d2	32540	commonAcns (comm list1.acns.txt.sorted.txt and list2.acns.txt.sorted.txt)	COMPLETED	0	2018-11-02 16:10:08.839	350ms	29ms	0.0%	0	0	0	0
20	91/336a0d	32544	commonAcns (comm list2.acns.txt.sorted.txt and list2.acns.txt.sorted.txt)	COMPLETED	0	2018-11-02 16:10:08.879	340ms	48ms	0.0%	0	0	0	0
```

