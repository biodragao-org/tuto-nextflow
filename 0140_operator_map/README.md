## Synopsis

> The map operator applies a function of your choosing to every item emitted by a channel, and returns the items so obtained as a new channel. The function applied is called the mapping function and is expressed with a closure

Ici

```
map{ROW->[ ROW[0].getName() + " vs " + ROW[2].getName() , ROW[1] , ROW[3] ] }
```

on crée un tableau à trois elements : le titre , fichier trié 1, fichier trié 2


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
 17   	tag "comm ${label}"
 18   	input:
 19   		set label,sorted1,sorted2 from acn_sorted1.
 20                                             combine(acn_sorted2).
 21                                             filter{ROW->ROW[0].getName().compareTo(ROW[2].getName())<0}.
 22   					  map{ROW->[ ROW[0].getName() + " vs " + ROW[2].getName() , ROW[1] , ROW[3] ] }
 23   	output:
 24   		set label,file("comm.txt")
 25   	script:
 26   	"""
 27   	comm -12 "${sorted1}" "${sorted2}" > comm.txt
 28   	"""
 29   }
```


## Execute

```
../bin/nextflow run -resume -with-trace trace.tsv -with-report report.html -with-timeline timeline.html -with-dag flowchart.png workflow.nf --acns '../data/list*.acns.txt'
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [adoring_raman] - revision: 50561d3246
[warm up] executor > local
[3a/5a3670] Submitted process > sortAcns (sorting list4.acns.txt)
[da/26776d] Submitted process > sortAcns (sorting list3.acns.txt)
[c8/c1e9f0] Submitted process > sortAcns (sorting list2.acns.txt)
[df/dafc28] Submitted process > sortAcns (sorting list1.acns.txt)
[91/0385b4] Submitted process > commonAcns (comm list3.acns.txt vs list4.acns.txt)
[fd/eab94c] Submitted process > commonAcns (comm list2.acns.txt vs list3.acns.txt)
[d3/1c8865] Submitted process > commonAcns (comm list2.acns.txt vs list4.acns.txt)
[be/cf4f01] Submitted process > commonAcns (comm list1.acns.txt vs list3.acns.txt)
[5c/766031] Submitted process > commonAcns (comm list1.acns.txt vs list2.acns.txt)
[a3/2e4bd8] Submitted process > commonAcns (comm list1.acns.txt vs list4.acns.txt)
```


## Files

```
work/5c/7660311b389596013a412f82691fca/comm.txt
work/a3/2e4bd8a223a6bbc0d74b850850b76a/comm.txt
work/c8/c1e9f0255063f93349022edd143185/list2.acns.txt.sorted.txt
work/c8/c1e9f0255063f93349022edd143185/list2.acns.txt
work/d3/1c8865d30ff1e4a2b625b48b743551/comm.txt
work/da/26776d1d143b2fdb5e6a4fc3b69c87/list3.acns.txt
work/da/26776d1d143b2fdb5e6a4fc3b69c87/list3.acns.txt.sorted.txt
work/3a/5a36708cdd8e1b827d6b5424372d24/list4.acns.txt.sorted.txt
work/3a/5a36708cdd8e1b827d6b5424372d24/list4.acns.txt
work/91/0385b447e49a131f6354fea98f1520/comm.txt
work/fd/eab94c1da0687d342067277648d684/comm.txt
work/df/dafc28caacc205fdfecfe2a6d02bbd/list1.acns.txt.sorted.txt
work/df/dafc28caacc205fdfecfe2a6d02bbd/list1.acns.txt
work/be/cf4f01b46477538d01305d1c870fb4/comm.txt
```



## Workflow

![Workflow](flowchart.png)


## Trace

```
task_id	hash	native_id	name	status	exit	submit	duration	realtime	%cpu	rss	vmem	rchar	wchar
2	3a/5a3670	14653	sortAcns (sorting list4.acns.txt)	COMPLETED	0	2018-11-08 15:29:52.423	224ms	24ms	0.0%	0	0	0	0
1	da/26776d	14683	sortAcns (sorting list3.acns.txt)	COMPLETED	0	2018-11-08 15:29:52.481	265ms	22ms	0.0%	0	0	0	0
3	c8/c1e9f0	14776	sortAcns (sorting list2.acns.txt)	COMPLETED	0	2018-11-08 15:29:52.667	267ms	30ms	0.0%	0	0	0	0
4	df/dafc28	14807	sortAcns (sorting list1.acns.txt)	COMPLETED	0	2018-11-08 15:29:52.762	255ms	26ms	0.0%	0	0	0	0
5	91/0385b4	14899	commonAcns (comm list3.acns.txt vs list4.acns.txt)	COMPLETED	0	2018-11-08 15:29:52.960	369ms	20ms	0.0%	0	0	0	0
7	fd/eab94c	14932	commonAcns (comm list2.acns.txt vs list3.acns.txt)	COMPLETED	0	2018-11-08 15:29:53.084	315ms	39ms	0.0%	0	0	0	0
6	d3/1c8865	15018	commonAcns (comm list2.acns.txt vs list4.acns.txt)	COMPLETED	0	2018-11-08 15:29:53.335	227ms	31ms	0.0%	0	0	0	0
8	be/cf4f01	15050	commonAcns (comm list1.acns.txt vs list3.acns.txt)	COMPLETED	0	2018-11-08 15:29:53.408	217ms	5ms	0.0%	0	0	0	0
10	a3/2e4bd8	15191	commonAcns (comm list1.acns.txt vs list4.acns.txt)	COMPLETED	0	2018-11-08 15:29:53.637	45ms	1ms	-	-	-	-	-
9	5c/766031	15136	commonAcns (comm list1.acns.txt vs list2.acns.txt)	COMPLETED	0	2018-11-08 15:29:53.570	202ms	4ms	0.0%	0	0	0	0
```

