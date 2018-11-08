## Synopsis

> The filter operator allows you to get only the items emitted by a channel that satisfy a condition and discarding all the others. The filtering condition can be specified by using either a regular expression, a literal value, a type qualifier (i.e. a Java class) or any boolean predicate.


ici, après `combine` on ne garde que les lignes où le premier nom est 'plus petit' que le deuxième.

```
filter{ROW->ROW[1].getName().compareTo(ROW[3].getName())<0}
```

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
 20                                             combine(acn_sorted2).
 21                                             filter{ROW->ROW[1].getName().compareTo(ROW[3].getName())<0}
 22   	output:
 23   		set acn1,acn2,file("comm.txt")
 24   	script:
 25   	"""
 26   	comm -12 "${sorted1}" "${sorted2}" > comm.txt
 27   	"""
 28   }
```


## Execute

```
../bin/nextflow run -resume -with-trace trace.tsv -with-report report.html -with-timeline timeline.html -with-dag flowchart.png workflow.nf --acns '../data/list*.acns.txt'
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [agitated_torvalds] - revision: 41d209f8fc
[warm up] executor > local
[f9/f8f00f] Submitted process > sortAcns (sorting list4.acns.txt)
[5d/0c6d2a] Submitted process > sortAcns (sorting list3.acns.txt)
[b1/f2ef87] Submitted process > sortAcns (sorting list2.acns.txt)
[ee/26ed46] Submitted process > sortAcns (sorting list1.acns.txt)
[55/ca169f] Submitted process > commonAcns (comm list3.acns.txt.sorted.txt and list4.acns.txt.sorted.txt)
[83/b031f3] Submitted process > commonAcns (comm list2.acns.txt.sorted.txt and list3.acns.txt.sorted.txt)
[96/2b6c27] Submitted process > commonAcns (comm list2.acns.txt.sorted.txt and list4.acns.txt.sorted.txt)
[24/ff14eb] Submitted process > commonAcns (comm list1.acns.txt.sorted.txt and list4.acns.txt.sorted.txt)
[3c/564aad] Submitted process > commonAcns (comm list1.acns.txt.sorted.txt and list2.acns.txt.sorted.txt)
[d5/15fd95] Submitted process > commonAcns (comm list1.acns.txt.sorted.txt and list3.acns.txt.sorted.txt)
```


## Files

```
work/f9/f8f00fd0419f8692f1fada74269a56/list4.acns.txt.sorted.txt
work/f9/f8f00fd0419f8692f1fada74269a56/list4.acns.txt
work/ee/26ed46d55250f023486c028e12b35a/list1.acns.txt.sorted.txt
work/ee/26ed46d55250f023486c028e12b35a/list1.acns.txt
work/96/2b6c2764c581eb1e32647490c6db9f/comm.txt
work/5d/0c6d2ae9f4e00771e702938f19c1fa/list3.acns.txt
work/5d/0c6d2ae9f4e00771e702938f19c1fa/list3.acns.txt.sorted.txt
work/d5/15fd95d2dcb66f3c6cdb3ab0d01ccb/comm.txt
work/3c/564aada77222fc25cde6cdad7fdef0/comm.txt
work/83/b031f3250f3a72d9a5d914695a5d39/comm.txt
work/b1/f2ef87ccffc9b84a65f00fe91c9e4d/list2.acns.txt.sorted.txt
work/b1/f2ef87ccffc9b84a65f00fe91c9e4d/list2.acns.txt
work/55/ca169f93f6b37eee7d8c857d4f7a4e/comm.txt
work/24/ff14ebd91a7ebc8b6314c80c0bd62a/comm.txt
```



## Workflow

![Workflow](flowchart.png)


## Trace

```
task_id	hash	native_id	name	status	exit	submit	duration	realtime	%cpu	rss	vmem	rchar	wchar
2	f9/f8f00f	13965	sortAcns (sorting list4.acns.txt)	COMPLETED	0	2018-11-08 15:29:44.451	407ms	9ms	0.0%	0	0	0	0
1	5d/0c6d2a	13975	sortAcns (sorting list3.acns.txt)	COMPLETED	0	2018-11-08 15:29:44.564	394ms	25ms	0.0%	0	0	0	0
3	b1/f2ef87	14089	sortAcns (sorting list2.acns.txt)	COMPLETED	0	2018-11-08 15:29:44.871	309ms	22ms	0.0%	0	0	0	0
4	ee/26ed46	14119	sortAcns (sorting list1.acns.txt)	COMPLETED	0	2018-11-08 15:29:44.968	292ms	24ms	0.0%	0	0	0	0
7	83/b031f3	14219	commonAcns (comm list2.acns.txt.sorted.txt and list3.acns.txt.sorted.txt)	COMPLETED	0	2018-11-08 15:29:45.283	326ms	37ms	0.0%	0	0	0	0
5	55/ca169f	14212	commonAcns (comm list3.acns.txt.sorted.txt and list4.acns.txt.sorted.txt)	COMPLETED	0	2018-11-08 15:29:45.205	429ms	21ms	0.0%	0	0	0	0
6	96/2b6c27	14332	commonAcns (comm list2.acns.txt.sorted.txt and list4.acns.txt.sorted.txt)	COMPLETED	0	2018-11-08 15:29:45.613	344ms	24ms	0.0%	0	0	0	0
9	24/ff14eb	14369	commonAcns (comm list1.acns.txt.sorted.txt and list4.acns.txt.sorted.txt)	COMPLETED	0	2018-11-08 15:29:45.691	314ms	48ms	0.0%	0	0	0	0
10	3c/564aad	14450	commonAcns (comm list1.acns.txt.sorted.txt and list2.acns.txt.sorted.txt)	COMPLETED	0	2018-11-08 15:29:45.971	263ms	30ms	0.0%	0	0	0	0
8	d5/15fd95	14474	commonAcns (comm list1.acns.txt.sorted.txt and list3.acns.txt.sorted.txt)	COMPLETED	0	2018-11-08 15:29:46.014	272ms	34ms	0.0%	0	0	0	0
```

