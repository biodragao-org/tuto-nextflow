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
		set label,file("comm.txt") into commons
	script:
	"""
	comm -12 "${sorted1}" "${sorted2}" > comm.txt
	"""
}

process listCommons {
	tag "common list size: ${array_of_rows.size()}"
	input:
		val array_of_rows from commons.map{ROW->ROW[0]+","+ROW[1]}.collect()
	output:
		file("table.csv")
		file("distcint.acns.txt")
	script:
	"""
	echo '${array_of_rows.join("\n")}' > table.csv
	cut -d ',' -f2 table.csv | while read F
	do
		cat \$F
	done | sort | uniq > distcint.acns.txt
	"""

}
```


## Execute

```
../bin/nextflow run -resume -with-trace trace.tsv -with-report report.html -with-timeline timeline.html -with-dag flowchart.png workflow.nf --acns '../data/list*.acns.txt'
N E X T F L O W  ~  version 0.32.0
Launching `workflow.nf` [prickly_shannon] - revision: 159f833755
[warm up] executor > local
[d5/c6fab1] Cached process > sortAcns (sorting list2.acns.txt)
[0d/9f6b51] Cached process > sortAcns (sorting list4.acns.txt)
[1f/d943e9] Cached process > sortAcns (sorting list3.acns.txt)
[9f/7908b4] Cached process > sortAcns (sorting list1.acns.txt)
[9f/e66c27] Cached process > commonAcns (comm list1.acns.txt vs list2.acns.txt)
[3e/448e70] Cached process > commonAcns (comm list1.acns.txt vs list4.acns.txt)
[d1/ef7a70] Cached process > commonAcns (comm list1.acns.txt vs list3.acns.txt)
[5d/fcfa59] Cached process > commonAcns (comm list2.acns.txt vs list3.acns.txt)
[f2/1a603f] Cached process > commonAcns (comm list3.acns.txt vs list4.acns.txt)
[fc/3cece4] Cached process > commonAcns (comm list2.acns.txt vs list4.acns.txt)
[08/2821dd] Cached process > listCommons (common list size: 6)
```


## Files

```
work/1f/d943e957855dd35eaab60d6892d02c/list3.acns.txt
work/1f/d943e957855dd35eaab60d6892d02c/list3.acns.txt.sorted.txt
work/d5/c6fab1fb01ce1e74d4ce7749c5dcf2/list2.acns.txt
work/d5/c6fab1fb01ce1e74d4ce7749c5dcf2/list2.acns.txt.sorted.txt
work/9f/7908b4711232713324a2e646e45b49/list1.acns.txt
work/9f/7908b4711232713324a2e646e45b49/list1.acns.txt.sorted.txt
work/9f/e66c279cf916bd7e9c92d2335a6303/comm.txt
work/0d/9f6b5173edd38505410391618b63d6/list4.acns.txt
work/0d/9f6b5173edd38505410391618b63d6/list4.acns.txt.sorted.txt
work/d1/ef7a70d788cfbc894799379458b72d/comm.txt
work/3e/448e700730f08c36335128527dc9e3/comm.txt
work/f2/1a603f4f440797896b85c4f216426b/comm.txt
work/5d/fcfa5922580132016bba86bc13a96f/comm.txt
work/fc/3cece4ccfb8f92c824656860cc6334/comm.txt
work/08/2821ddf8147268ff5654bc9d0ca383/table.csv
work/08/2821ddf8147268ff5654bc9d0ca383/distcint.acns.txt
```



## Workflow

![Workflow](flowchart.png)


## Trace

```
task_id	hash	native_id	name	status	exit	submit	duration	realtime	%cpu	rss	vmem	rchar	wchar
4	0d/9f6b51	12775	sortAcns (sorting list4.acns.txt)	CACHED	0	2018-09-28 13:21:01.875	522ms	37ms	0.0%	0	0	0	0
3	1f/d943e9	12765	sortAcns (sorting list3.acns.txt)	CACHED	0	2018-09-28 13:21:01.839	543ms	47ms	0.0%	0	0	0	0
1	9f/7908b4	12762	sortAcns (sorting list1.acns.txt)	CACHED	0	2018-09-28 13:21:01.811	528ms	57ms	0.0%	0	0	0	0
2	d5/c6fab1	12770	sortAcns (sorting list2.acns.txt)	CACHED	0	2018-09-28 13:21:01.859	552ms	72ms	0.0%	0	0	0	0
9	9f/e66c27	13320	commonAcns (comm list1.acns.txt vs list2.acns.txt)	CACHED	0	2018-09-28 13:21:02.802	444ms	19ms	0.0%	0	0	0	0
6	3e/448e70	13087	commonAcns (comm list1.acns.txt vs list4.acns.txt)	CACHED	0	2018-09-28 13:21:02.436	410ms	31ms	0.0%	0	0	0	0
5	d1/ef7a70	13086	commonAcns (comm list1.acns.txt vs list3.acns.txt)	CACHED	0	2018-09-28 13:21:02.419	414ms	26ms	0.0%	0	0	0	0
8	5d/fcfa59	13094	commonAcns (comm list2.acns.txt vs list3.acns.txt)	CACHED	0	2018-09-28 13:21:02.455	363ms	19ms	0.0%	0	0	0	0
10	fc/3cece4	13325	commonAcns (comm list2.acns.txt vs list4.acns.txt)	CACHED	0	2018-09-28 13:21:02.835	311ms	20ms	0.0%	0	0	0	0
7	f2/1a603f	13089	commonAcns (comm list3.acns.txt vs list4.acns.txt)	CACHED	0	2018-09-28 13:21:02.446	347ms	26ms	0.0%	0	0	0	0
11	08/2821dd	13444	listCommons (common list size: 6)	CACHED	0	2018-09-28 13:21:03.262	417ms	58ms	0.0%	0	0	0	0
```

