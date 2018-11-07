## Synopsis

> The combine operator combines (cartesian product) the items emitted by two channels.

Ici c'est le premier workflow où nous combinons deux `process`.

## nextflow

### ./workflow.nf

```groovy
  1   acn_file_channel = Channel.fromPath( "${params.acns}")
  2   
  3   process sortAcns {
  4   	tag "sorting ${acnFile}"
  5   	input:
  6   		file acnFile from acn_file_channel
  7   	output:
  8   		set acnFile, file("${acnFile}.sorted.txt") into (acn_sorted1,acn_sorted2)
  9   	script:
 10   	
 11   	"""
 12   	sort '${acnFile}' > "${acnFile}.sorted.txt"
 13   	"""
 14   }
 15   
 16   process commonAcns {
 17   	tag "comm ${sorted1.getName()} and ${sorted2.getName()}"
 18   	input:
 19   		set acn1,sorted1,acn2,sorted2 from acn_sorted1.
 20   			combine(acn_sorted2)
 21   	output:
 22   		set acn1,acn2,file("comm.txt") into comm_out
 23   	script:
 24   	"""
 25   	comm -12 "${sorted1}" "${sorted2}" > comm.txt
 26   	"""
 27   }
```


## Execute

```
../bin/nextflow run -resume -with-trace trace.tsv -with-report report.html -with-timeline timeline.html -with-dag flowchart.png workflow.nf --acns '../data/list*.acns.txt'
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [reverent_goldberg] - revision: 0fdc53866d
[warm up] executor > local
[d8/178946] Submitted process > sortAcns (sorting list3.acns.txt)
[a2/d5eda9] Submitted process > sortAcns (sorting list4.acns.txt)
[9d/3d7781] Submitted process > sortAcns (sorting list2.acns.txt)
[f2/791801] Submitted process > sortAcns (sorting list1.acns.txt)
[f9/47b181] Submitted process > commonAcns (comm list3.acns.txt.sorted.txt and list3.acns.txt.sorted.txt)
[38/531459] Submitted process > commonAcns (comm list4.acns.txt.sorted.txt and list3.acns.txt.sorted.txt)
[f5/bc1b61] Submitted process > commonAcns (comm list4.acns.txt.sorted.txt and list4.acns.txt.sorted.txt)
[0a/ec93f7] Submitted process > commonAcns (comm list3.acns.txt.sorted.txt and list4.acns.txt.sorted.txt)
[54/215075] Submitted process > commonAcns (comm list2.acns.txt.sorted.txt and list3.acns.txt.sorted.txt)
[b8/9b6d89] Submitted process > commonAcns (comm list2.acns.txt.sorted.txt and list4.acns.txt.sorted.txt)
[cf/b655f7] Submitted process > commonAcns (comm list4.acns.txt.sorted.txt and list2.acns.txt.sorted.txt)
[53/d7eee7] Submitted process > commonAcns (comm list3.acns.txt.sorted.txt and list2.acns.txt.sorted.txt)
[db/056c59] Submitted process > commonAcns (comm list2.acns.txt.sorted.txt and list2.acns.txt.sorted.txt)
[ba/88498c] Submitted process > commonAcns (comm list1.acns.txt.sorted.txt and list3.acns.txt.sorted.txt)
[2b/7ee15c] Submitted process > commonAcns (comm list1.acns.txt.sorted.txt and list4.acns.txt.sorted.txt)
[36/5f62ec] Submitted process > commonAcns (comm list1.acns.txt.sorted.txt and list2.acns.txt.sorted.txt)
[41/c168cc] Submitted process > commonAcns (comm list3.acns.txt.sorted.txt and list1.acns.txt.sorted.txt)
[97/51f8dd] Submitted process > commonAcns (comm list4.acns.txt.sorted.txt and list1.acns.txt.sorted.txt)
[96/9186ae] Submitted process > commonAcns (comm list2.acns.txt.sorted.txt and list1.acns.txt.sorted.txt)
[46/2125d8] Submitted process > commonAcns (comm list1.acns.txt.sorted.txt and list1.acns.txt.sorted.txt)
```


## Files

```
work/38/53145952029c2e5f1f22265ea60ef7/comm.txt
work/97/51f8ddc0f1237b4f9de2f696c9612a/comm.txt
work/f9/47b181425fb6e5e8573a6e277ad66a/comm.txt
work/0a/ec93f770ff8a84739c10905436e66f/comm.txt
work/d8/17894647d00cb707b48cab66c78bc4/list3.acns.txt
work/d8/17894647d00cb707b48cab66c78bc4/list3.acns.txt.sorted.txt
work/ba/88498c8fe5b770b9c4964539fc5c78/comm.txt
work/9d/3d7781c39fde2aa34413886c6390b7/list2.acns.txt.sorted.txt
work/9d/3d7781c39fde2aa34413886c6390b7/list2.acns.txt
work/f2/7918019c161dde6686ca1ebc2c7fe8/list1.acns.txt.sorted.txt
work/f2/7918019c161dde6686ca1ebc2c7fe8/list1.acns.txt
work/36/5f62ec851ca90de5b6026575e4fb6b/comm.txt
work/a2/d5eda93055b60258c8367ee99c60d5/list4.acns.txt.sorted.txt
work/a2/d5eda93055b60258c8367ee99c60d5/list4.acns.txt
work/cf/b655f7d6f3f62e02df629757378758/comm.txt
work/96/9186aea2f66b3f25cf49ce16ce6d8e/comm.txt
work/f5/bc1b619fefac65ca347dd7e75ef702/comm.txt
work/2b/7ee15c3061f08cbaa49fccbb0ba165/comm.txt
work/41/c168cc6c4b2babbffcd3c943f5a052/comm.txt
work/46/2125d88b547f9ded23e51e560ddeeb/comm.txt
work/53/d7eee760c3754ad820e69b7372dc70/comm.txt
work/db/056c5998d94776b76eccbddebe8ddb/comm.txt
work/54/215075a953a55603e0c38d0f051ddd/comm.txt
work/b8/9b6d8966e2598b772b56385a04e25a/comm.txt
```



## Workflow

![Workflow](flowchart.png)


## Trace

```
task_id	hash	native_id	name	status	exit	submit	duration	realtime	%cpu	rss	vmem	rchar	wchar
1	d8/178946	16654	sortAcns (sorting list3.acns.txt)	COMPLETED	0	2018-11-07 10:10:57.192	463ms	28ms	0.0%	0	0	0	0
2	a2/d5eda9	16668	sortAcns (sorting list4.acns.txt)	COMPLETED	0	2018-11-07 10:10:57.331	563ms	32ms	0.0%	0	0	0	0
3	9d/3d7781	16778	sortAcns (sorting list2.acns.txt)	COMPLETED	0	2018-11-07 10:10:57.696	527ms	73ms	0.0%	0	0	0	0
4	f2/791801	16819	sortAcns (sorting list1.acns.txt)	COMPLETED	0	2018-11-07 10:10:57.916	411ms	62ms	0.0%	0	0	0	0
5	f9/47b181	16901	commonAcns (comm list3.acns.txt.sorted.txt and list3.acns.txt.sorted.txt)	COMPLETED	0	2018-11-07 10:10:58.241	484ms	66ms	0.0%	0	0	0	0
7	f5/bc1b61	17019	commonAcns (comm list4.acns.txt.sorted.txt and list4.acns.txt.sorted.txt)	COMPLETED	0	2018-11-07 10:10:58.738	110ms	22ms	-	-	-	-	-
6	38/531459	16919	commonAcns (comm list4.acns.txt.sorted.txt and list3.acns.txt.sorted.txt)	COMPLETED	0	2018-11-07 10:10:58.378	571ms	39ms	0.0%	0	0	0	0
8	0a/ec93f7	17048	commonAcns (comm list3.acns.txt.sorted.txt and list4.acns.txt.sorted.txt)	COMPLETED	0	2018-11-07 10:10:58.866	412ms	17ms	0.0%	0	0	0	0
9	54/215075	17076	commonAcns (comm list2.acns.txt.sorted.txt and list3.acns.txt.sorted.txt)	COMPLETED	0	2018-11-07 10:10:58.977	353ms	37ms	0.0%	0	0	0	0
10	b8/9b6d89	17165	commonAcns (comm list2.acns.txt.sorted.txt and list4.acns.txt.sorted.txt)	COMPLETED	0	2018-11-07 10:10:59.287	400ms	35ms	0.0%	0	0	0	0
11	cf/b655f7	17188	commonAcns (comm list4.acns.txt.sorted.txt and list2.acns.txt.sorted.txt)	COMPLETED	0	2018-11-07 10:10:59.362	348ms	30ms	0.0%	0	0	0	0
13	db/056c59	17290	commonAcns (comm list2.acns.txt.sorted.txt and list2.acns.txt.sorted.txt)	COMPLETED	0	2018-11-07 10:10:59.735	382ms	29ms	0.0%	0	0	0	0
12	53/d7eee7	17288	commonAcns (comm list3.acns.txt.sorted.txt and list2.acns.txt.sorted.txt)	COMPLETED	0	2018-11-07 10:10:59.695	457ms	53ms	0.0%	0	0	0	0
15	ba/88498c	17406	commonAcns (comm list1.acns.txt.sorted.txt and list3.acns.txt.sorted.txt)	COMPLETED	0	2018-11-07 10:11:00.122	374ms	23ms	0.0%	0	0	0	0
14	2b/7ee15c	17417	commonAcns (comm list1.acns.txt.sorted.txt and list4.acns.txt.sorted.txt)	COMPLETED	0	2018-11-07 10:11:00.167	383ms	43ms	0.0%	0	0	0	0
17	36/5f62ec	17523	commonAcns (comm list1.acns.txt.sorted.txt and list2.acns.txt.sorted.txt)	COMPLETED	0	2018-11-07 10:11:00.522	477ms	32ms	0.0%	0	0	0	0
16	41/c168cc	17539	commonAcns (comm list3.acns.txt.sorted.txt and list1.acns.txt.sorted.txt)	COMPLETED	0	2018-11-07 10:11:00.562	492ms	41ms	0.0%	0	0	0	0
18	97/51f8dd	17641	commonAcns (comm list4.acns.txt.sorted.txt and list1.acns.txt.sorted.txt)	COMPLETED	0	2018-11-07 10:11:01.022	363ms	45ms	0.0%	0	0	0	0
19	96/9186ae	17658	commonAcns (comm list2.acns.txt.sorted.txt and list1.acns.txt.sorted.txt)	COMPLETED	0	2018-11-07 10:11:01.073	397ms	24ms	0.0%	0	0	0	0
20	46/2125d8	17759	commonAcns (comm list1.acns.txt.sorted.txt and list1.acns.txt.sorted.txt)	COMPLETED	0	2018-11-07 10:11:01.397	291ms	44ms	0.0%	0	0	0	0
```

