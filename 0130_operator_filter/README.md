## Synopsis
> The filter operator allows you to get only the items emitted by a channel that satisfy a condition and discarding all the others. The filtering condition can be specified by using either a regular expression, a literal value, a type qualifier (i.e. a Java class) or any boolean predicate.


ici, après `combine` on ne garde que les lignes où le premier nom est 'plus petit' que le deuxième.

```
filter{ROW->ROW[1].getName().compareTo(ROW[3].getName())<0}
```

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
Launching `workflow.nf` [insane_poincare] - revision: 41d209f8fc
[warm up] executor > local
[5d/0c6d2a] Submitted process > sortAcns (sorting list3.acns.txt)
[f9/f8f00f] Submitted process > sortAcns (sorting list4.acns.txt)
[b1/f2ef87] Submitted process > sortAcns (sorting list2.acns.txt)
[ee/26ed46] Submitted process > sortAcns (sorting list1.acns.txt)
[08/bd0d02] Submitted process > commonAcns (comm list3.acns.txt.sorted.txt and list4.acns.txt.sorted.txt)
[9d/665c62] Submitted process > commonAcns (comm list2.acns.txt.sorted.txt and list3.acns.txt.sorted.txt)
[6f/3c88a6] Submitted process > commonAcns (comm list2.acns.txt.sorted.txt and list4.acns.txt.sorted.txt)
[12/fdf9bf] Submitted process > commonAcns (comm list1.acns.txt.sorted.txt and list3.acns.txt.sorted.txt)
[40/91bd5b] Submitted process > commonAcns (comm list1.acns.txt.sorted.txt and list4.acns.txt.sorted.txt)
[8e/1394e2] Submitted process > commonAcns (comm list1.acns.txt.sorted.txt and list2.acns.txt.sorted.txt)
```


## Files

```
work/6f/3c88a6bac9093bfd4bf86eb385888a/comm.txt
work/f9/f8f00fd0419f8692f1fada74269a56/list4.acns.txt.sorted.txt
work/f9/f8f00fd0419f8692f1fada74269a56/list4.acns.txt
work/ee/26ed46d55250f023486c028e12b35a/list1.acns.txt.sorted.txt
work/ee/26ed46d55250f023486c028e12b35a/list1.acns.txt
work/9d/665c620027c9841c87dd27bbd0331f/comm.txt
work/8e/1394e2351564fca7df4a779284af75/comm.txt
work/5d/0c6d2ae9f4e00771e702938f19c1fa/list3.acns.txt
work/5d/0c6d2ae9f4e00771e702938f19c1fa/list3.acns.txt.sorted.txt
work/12/fdf9bf8df7ca4edffec6963348fd5b/comm.txt
work/b1/f2ef87ccffc9b84a65f00fe91c9e4d/list2.acns.txt.sorted.txt
work/b1/f2ef87ccffc9b84a65f00fe91c9e4d/list2.acns.txt
work/08/bd0d02961ea1c044d391909e49eb7f/comm.txt
work/40/91bd5b588a22e02ba6dce0e67dce80/comm.txt
```



## Workflow

![Workflow](flowchart.png)


## Trace

```
task_id	hash	native_id	name	status	exit	submit	duration	realtime	%cpu	rss	vmem	rchar	wchar
1	5d/0c6d2a	8563	sortAcns (sorting list3.acns.txt)	COMPLETED	0	2018-11-06 10:56:39.594	516ms	41ms	0.0%	0	0	0	0
2	f9/f8f00f	8577	sortAcns (sorting list4.acns.txt)	COMPLETED	0	2018-11-06 10:56:39.700	573ms	78ms	0.0%	0	0	0	0
3	b1/f2ef87	8686	sortAcns (sorting list2.acns.txt)	COMPLETED	0	2018-11-06 10:56:40.140	581ms	36ms	0.0%	0	0	0	0
4	ee/26ed46	8707	sortAcns (sorting list1.acns.txt)	COMPLETED	0	2018-11-06 10:56:40.292	513ms	50ms	0.0%	0	0	0	0
5	08/bd0d02	8809	commonAcns (comm list3.acns.txt.sorted.txt and list4.acns.txt.sorted.txt)	COMPLETED	0	2018-11-06 10:56:40.748	489ms	30ms	0.0%	0	0	0	0
7	9d/665c62	8819	commonAcns (comm list2.acns.txt.sorted.txt and list3.acns.txt.sorted.txt)	COMPLETED	0	2018-11-06 10:56:40.830	439ms	42ms	0.0%	0	0	0	0
6	6f/3c88a6	8928	commonAcns (comm list2.acns.txt.sorted.txt and list4.acns.txt.sorted.txt)	COMPLETED	0	2018-11-06 10:56:41.255	376ms	38ms	0.0%	0	0	0	0
9	12/fdf9bf	8943	commonAcns (comm list1.acns.txt.sorted.txt and list3.acns.txt.sorted.txt)	COMPLETED	0	2018-11-06 10:56:41.300	369ms	26ms	0.0%	0	0	0	0
8	40/91bd5b	9046	commonAcns (comm list1.acns.txt.sorted.txt and list4.acns.txt.sorted.txt)	COMPLETED	0	2018-11-06 10:56:41.646	330ms	44ms	0.0%	0	0	0	0
10	8e/1394e2	9074	commonAcns (comm list1.acns.txt.sorted.txt and list2.acns.txt.sorted.txt)	COMPLETED	0	2018-11-06 10:56:41.741	327ms	16ms	0.0%	0	0	0	0
```

