## Synopsis
> The combine operator combines (cartesian product) the items emitted by two channels.

Ici c'est le premier workflow où nous combinons deux `process`.

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
			combine(acn_sorted2)
	output:
		set acn1,acn2,file("comm.txt") into comm_out
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
Launching `workflow.nf` [cheesy_northcutt] - revision: 0fdc53866d
[warm up] executor > local
[a2/d5eda9] Submitted process > sortAcns (sorting list4.acns.txt)
[d8/178946] Submitted process > sortAcns (sorting list3.acns.txt)
[9d/3d7781] Submitted process > sortAcns (sorting list2.acns.txt)
[f2/791801] Submitted process > sortAcns (sorting list1.acns.txt)
[03/e7142d] Submitted process > commonAcns (comm list4.acns.txt.sorted.txt and list4.acns.txt.sorted.txt)
[f6/b461d8] Submitted process > commonAcns (comm list3.acns.txt.sorted.txt and list4.acns.txt.sorted.txt)
[5d/e2ada1] Submitted process > commonAcns (comm list3.acns.txt.sorted.txt and list3.acns.txt.sorted.txt)
[cf/e9b57d] Submitted process > commonAcns (comm list4.acns.txt.sorted.txt and list3.acns.txt.sorted.txt)
[5f/ad790a] Submitted process > commonAcns (comm list1.acns.txt.sorted.txt and list4.acns.txt.sorted.txt)
[14/51f1ac] Submitted process > commonAcns (comm list1.acns.txt.sorted.txt and list3.acns.txt.sorted.txt)
[dd/9806f1] Submitted process > commonAcns (comm list3.acns.txt.sorted.txt and list1.acns.txt.sorted.txt)
[cf/c0e78e] Submitted process > commonAcns (comm list1.acns.txt.sorted.txt and list1.acns.txt.sorted.txt)
[44/487874] Submitted process > commonAcns (comm list4.acns.txt.sorted.txt and list1.acns.txt.sorted.txt)
[5b/c9c5b7] Submitted process > commonAcns (comm list2.acns.txt.sorted.txt and list4.acns.txt.sorted.txt)
[2b/06c2b8] Submitted process > commonAcns (comm list2.acns.txt.sorted.txt and list3.acns.txt.sorted.txt)
[49/8df86b] Submitted process > commonAcns (comm list4.acns.txt.sorted.txt and list2.acns.txt.sorted.txt)
[9b/189c3a] Submitted process > commonAcns (comm list3.acns.txt.sorted.txt and list2.acns.txt.sorted.txt)
[07/30cbe8] Submitted process > commonAcns (comm list1.acns.txt.sorted.txt and list2.acns.txt.sorted.txt)
[56/7041f1] Submitted process > commonAcns (comm list2.acns.txt.sorted.txt and list2.acns.txt.sorted.txt)
[27/fe9244] Submitted process > commonAcns (comm list2.acns.txt.sorted.txt and list1.acns.txt.sorted.txt)
```


## Files

```
work/07/30cbe813ed348bea7e0c1cd0e471a9/comm.txt
work/d8/17894647d00cb707b48cab66c78bc4/list3.acns.txt
work/d8/17894647d00cb707b48cab66c78bc4/list3.acns.txt.sorted.txt
work/44/487874fc17c2eb5fa83962d62fcd25/comm.txt
work/9d/3d7781c39fde2aa34413886c6390b7/list2.acns.txt.sorted.txt
work/9d/3d7781c39fde2aa34413886c6390b7/list2.acns.txt
work/f2/7918019c161dde6686ca1ebc2c7fe8/list1.acns.txt.sorted.txt
work/f2/7918019c161dde6686ca1ebc2c7fe8/list1.acns.txt
work/a2/d5eda93055b60258c8367ee99c60d5/list4.acns.txt.sorted.txt
work/a2/d5eda93055b60258c8367ee99c60d5/list4.acns.txt
work/cf/e9b57dd17789f2b9496074c2c4038e/comm.txt
work/cf/c0e78eecaf07888a2dc29e756f7074/comm.txt
work/56/7041f1105e2550f60a6bd4266fbd45/comm.txt
work/5d/e2ada14f73180794bc04bc65adc27b/comm.txt
work/2b/06c2b855859eff65aab1d52737e4e3/comm.txt
work/49/8df86b456288adabfeff44a599bab5/comm.txt
work/03/e7142d74c1784509ea6b812fa877d6/comm.txt
work/9b/189c3a7b17f832200833e33f3eceab/comm.txt
work/14/51f1accb15869729a46f27b13b5b0b/comm.txt
work/5b/c9c5b7e6253d6b96d0a16f61ebbbd2/comm.txt
work/dd/9806f1cacb309e05ba8ec6eff7dac8/comm.txt
work/27/fe924437c8415748bca6183ce70f91/comm.txt
work/5f/ad790af92de1271cb0055cd4ea2a1c/comm.txt
work/f6/b461d8e28e10e51614dea2692db5ba/comm.txt
```



## Workflow

![Workflow](flowchart.png)


## Trace

```
task_id	hash	native_id	name	status	exit	submit	duration	realtime	%cpu	rss	vmem	rchar	wchar
2	a2/d5eda9	7351	sortAcns (sorting list4.acns.txt)	COMPLETED	0	2018-11-06 10:56:31.558	223ms	22ms	0.0%	0	0	0	0
1	d8/178946	7371	sortAcns (sorting list3.acns.txt)	COMPLETED	0	2018-11-06 10:56:31.608	249ms	5ms	0.0%	0	0	0	0
4	f2/791801	7482	sortAcns (sorting list1.acns.txt)	COMPLETED	0	2018-11-06 10:56:31.867	268ms	39ms	0.0%	0	0	0	0
3	9d/3d7781	7474	sortAcns (sorting list2.acns.txt)	COMPLETED	0	2018-11-06 10:56:31.797	360ms	38ms	0.0%	0	0	0	0
5	03/e7142d	7599	commonAcns (comm list4.acns.txt.sorted.txt and list4.acns.txt.sorted.txt)	COMPLETED	0	2018-11-06 10:56:32.144	256ms	47ms	0.0%	0	0	0	0
6	f6/b461d8	7602	commonAcns (comm list3.acns.txt.sorted.txt and list4.acns.txt.sorted.txt)	COMPLETED	0	2018-11-06 10:56:32.172	252ms	34ms	0.0%	0	0	0	0
7	5d/e2ada1	7717	commonAcns (comm list3.acns.txt.sorted.txt and list3.acns.txt.sorted.txt)	COMPLETED	0	2018-11-06 10:56:32.406	245ms	41ms	0.0%	0	0	0	0
8	cf/e9b57d	7732	commonAcns (comm list4.acns.txt.sorted.txt and list3.acns.txt.sorted.txt)	COMPLETED	0	2018-11-06 10:56:32.433	259ms	33ms	0.0%	0	0	0	0
9	5f/ad790a	7835	commonAcns (comm list1.acns.txt.sorted.txt and list4.acns.txt.sorted.txt)	COMPLETED	0	2018-11-06 10:56:32.664	217ms	36ms	0.0%	0	0	0	0
10	14/51f1ac	7851	commonAcns (comm list1.acns.txt.sorted.txt and list3.acns.txt.sorted.txt)	COMPLETED	0	2018-11-06 10:56:32.700	232ms	16ms	0.0%	0	0	0	0
12	cf/c0e78e	7960	commonAcns (comm list1.acns.txt.sorted.txt and list1.acns.txt.sorted.txt)	COMPLETED	0	2018-11-06 10:56:32.937	73ms	3ms	-	-	-	-	-
11	dd/9806f1	7953	commonAcns (comm list3.acns.txt.sorted.txt and list1.acns.txt.sorted.txt)	COMPLETED	0	2018-11-06 10:56:32.887	302ms	8ms	0.0%	0	0	0	0
13	44/487874	8013	commonAcns (comm list4.acns.txt.sorted.txt and list1.acns.txt.sorted.txt)	COMPLETED	0	2018-11-06 10:56:33.016	200ms	25ms	0.0%	0	0	0	0
14	5b/c9c5b7	8098	commonAcns (comm list2.acns.txt.sorted.txt and list4.acns.txt.sorted.txt)	COMPLETED	0	2018-11-06 10:56:33.197	214ms	27ms	0.0%	0	0	0	0
15	2b/06c2b8	8105	commonAcns (comm list2.acns.txt.sorted.txt and list3.acns.txt.sorted.txt)	COMPLETED	0	2018-11-06 10:56:33.227	245ms	8ms	0.0%	0	0	0	0
18	9b/189c3a	8253	commonAcns (comm list3.acns.txt.sorted.txt and list2.acns.txt.sorted.txt)	COMPLETED	0	2018-11-06 10:56:33.491	49ms	3ms	-	-	-	-	-
16	49/8df86b	8216	commonAcns (comm list4.acns.txt.sorted.txt and list2.acns.txt.sorted.txt)	COMPLETED	0	2018-11-06 10:56:33.433	193ms	38ms	0.0%	0	0	0	0
19	07/30cbe8	8302	commonAcns (comm list1.acns.txt.sorted.txt and list2.acns.txt.sorted.txt)	COMPLETED	0	2018-11-06 10:56:33.547	175ms	7ms	0.0%	0	0	0	0
20	56/7041f1	8361	commonAcns (comm list2.acns.txt.sorted.txt and list2.acns.txt.sorted.txt)	COMPLETED	0	2018-11-06 10:56:33.632	173ms	18ms	0.0%	0	0	0	0
17	27/fe9244	8420	commonAcns (comm list2.acns.txt.sorted.txt and list1.acns.txt.sorted.txt)	COMPLETED	0	2018-11-06 10:56:33.725	190ms	20ms	0.0%	0	0	0	0
```

