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
Launching `workflow.nf` [adoring_picasso] - revision: 50561d3246
[warm up] executor > local
[da/26776d] Submitted process > sortAcns (sorting list3.acns.txt)
[c8/c1e9f0] Submitted process > sortAcns (sorting list2.acns.txt)
[3a/5a3670] Submitted process > sortAcns (sorting list4.acns.txt)
[df/dafc28] Submitted process > sortAcns (sorting list1.acns.txt)
[18/943e24] Submitted process > commonAcns (comm list2.acns.txt vs list3.acns.txt)
[35/5e55b2] Submitted process > commonAcns (comm list2.acns.txt vs list4.acns.txt)
[83/73d0a5] Submitted process > commonAcns (comm list3.acns.txt vs list4.acns.txt)
[ad/3ca619] Submitted process > commonAcns (comm list1.acns.txt vs list2.acns.txt)
[5e/ff0b99] Submitted process > commonAcns (comm list1.acns.txt vs list3.acns.txt)
[1c/a21bf7] Submitted process > commonAcns (comm list1.acns.txt vs list4.acns.txt)
```


## Files

```
work/1c/a21bf754219d47ff73e09b98ffb5ba/comm.txt
work/18/943e2449f70e215be89bf229c77b39/comm.txt
work/5e/ff0b9912e9a3f6a675eaf736d5d590/comm.txt
work/c8/c1e9f0255063f93349022edd143185/list2.acns.txt.sorted.txt
work/c8/c1e9f0255063f93349022edd143185/list2.acns.txt
work/da/26776d1d143b2fdb5e6a4fc3b69c87/list3.acns.txt
work/da/26776d1d143b2fdb5e6a4fc3b69c87/list3.acns.txt.sorted.txt
work/3a/5a36708cdd8e1b827d6b5424372d24/list4.acns.txt.sorted.txt
work/3a/5a36708cdd8e1b827d6b5424372d24/list4.acns.txt
work/83/73d0a5ac83d7863c75b8a870155722/comm.txt
work/df/dafc28caacc205fdfecfe2a6d02bbd/list1.acns.txt.sorted.txt
work/df/dafc28caacc205fdfecfe2a6d02bbd/list1.acns.txt
work/ad/3ca619ede65cbc78633281b75d9f89/comm.txt
work/35/5e55b2a347e3c9e3ec15d3063764cb/comm.txt
```



## Workflow

![Workflow](flowchart.png)


## Trace

```
task_id	hash	native_id	name	status	exit	submit	duration	realtime	%cpu	rss	vmem	rchar	wchar
1	da/26776d	9277	sortAcns (sorting list3.acns.txt)	COMPLETED	0	2018-11-06 10:56:51.584	473ms	30ms	0.0%	0	0	0	0
3	c8/c1e9f0	9284	sortAcns (sorting list2.acns.txt)	COMPLETED	0	2018-11-06 10:56:51.701	554ms	23ms	0.0%	0	0	0	0
2	3a/5a3670	9401	sortAcns (sorting list4.acns.txt)	COMPLETED	0	2018-11-06 10:56:52.107	617ms	96ms	0.0%	0	0	0	0
4	df/dafc28	9427	sortAcns (sorting list1.acns.txt)	COMPLETED	0	2018-11-06 10:56:52.294	543ms	40ms	0.0%	0	0	0	0
5	18/943e24	9523	commonAcns (comm list2.acns.txt vs list3.acns.txt)	COMPLETED	0	2018-11-06 10:56:52.744	406ms	31ms	0.0%	0	0	0	0
6	35/5e55b2	9553	commonAcns (comm list2.acns.txt vs list4.acns.txt)	COMPLETED	0	2018-11-06 10:56:52.858	334ms	19ms	0.0%	0	0	0	0
7	83/73d0a5	9643	commonAcns (comm list3.acns.txt vs list4.acns.txt)	COMPLETED	0	2018-11-06 10:56:53.166	351ms	30ms	0.0%	0	0	0	0
9	ad/3ca619	9655	commonAcns (comm list1.acns.txt vs list2.acns.txt)	COMPLETED	0	2018-11-06 10:56:53.196	385ms	23ms	0.0%	0	0	0	0
8	5e/ff0b99	9765	commonAcns (comm list1.acns.txt vs list3.acns.txt)	COMPLETED	0	2018-11-06 10:56:53.551	399ms	42ms	0.0%	0	0	0	0
10	1c/a21bf7	9769	commonAcns (comm list1.acns.txt vs list4.acns.txt)	COMPLETED	0	2018-11-06 10:56:53.595	375ms	43ms	0.0%	0	0	0	0
```

