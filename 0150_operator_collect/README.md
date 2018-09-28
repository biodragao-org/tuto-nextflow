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
../bin/nextflow run -with-trace trace.tsv -with-report report.html -with-timeline timeline.html -with-dag flowchart.png workflow.nf --acns '../data/list*.acns.txt'
N E X T F L O W  ~  version 0.32.0
Launching `workflow.nf` [tender_bardeen] - revision: 159f833755
[warm up] executor > local
[d5/c6fab1] Submitted process > sortAcns (sorting list2.acns.txt)
[9f/7908b4] Submitted process > sortAcns (sorting list1.acns.txt)
[1f/d943e9] Submitted process > sortAcns (sorting list3.acns.txt)
[0d/9f6b51] Submitted process > sortAcns (sorting list4.acns.txt)
[f8/01e25b] Submitted process > commonAcns (comm list1.acns.txt vs list2.acns.txt)
[9f/9d9422] Submitted process > commonAcns (comm list1.acns.txt vs list3.acns.txt)
[c9/ecb1ae] Submitted process > commonAcns (comm list2.acns.txt vs list3.acns.txt)
[98/893b5f] Submitted process > commonAcns (comm list1.acns.txt vs list4.acns.txt)
[35/56843a] Submitted process > commonAcns (comm list2.acns.txt vs list4.acns.txt)
[31/088901] Submitted process > commonAcns (comm list3.acns.txt vs list4.acns.txt)
[1b/555659] Submitted process > listCommons (common list size: 6)
```


## Files

```
work/9f/7908b4711232713324a2e646e45b49/list1.acns.txt
work/9f/7908b4711232713324a2e646e45b49/list1.acns.txt.sorted.txt
work/9f/9d9422426f564a9d1464565b4fe6f8/comm.txt
work/1f/d943e957855dd35eaab60d6892d02c/list3.acns.txt
work/1f/d943e957855dd35eaab60d6892d02c/list3.acns.txt.sorted.txt
work/0d/9f6b5173edd38505410391618b63d6/list4.acns.txt
work/0d/9f6b5173edd38505410391618b63d6/list4.acns.txt.sorted.txt
work/d5/c6fab1fb01ce1e74d4ce7749c5dcf2/list2.acns.txt
work/d5/c6fab1fb01ce1e74d4ce7749c5dcf2/list2.acns.txt.sorted.txt
work/f8/01e25bcd520b857120f9827b5adcfa/comm.txt
work/c9/ecb1aef3fec0da6f8fb18c806ae89c/comm.txt
work/98/893b5f501e4bb1bc9277511fb30906/comm.txt
work/35/56843a31078e032c118b07b21c0484/comm.txt
work/31/088901dc88a5f29953653b8e9bee30/comm.txt
work/1b/5556594d2024373707158b6323b1e4/table.csv
work/1b/5556594d2024373707158b6323b1e4/distcint.acns.txt
```



## Workflow

![Workflow](flowchart.png)


## Trace

```
task_id	hash	native_id	name	status	exit	submit	duration	realtime	%cpu	rss	vmem	rchar	wchar
2	d5/c6fab1	1977	sortAcns (sorting list2.acns.txt)	COMPLETED	0	2018-09-28 13:14:55.558	555ms	45ms	0.0%	0	0	0	0
1	9f/7908b4	1980	sortAcns (sorting list1.acns.txt)	COMPLETED	0	2018-09-28 13:14:55.615	589ms	46ms	0.0%	0	0	0	0
3	1f/d943e9	1986	sortAcns (sorting list3.acns.txt)	COMPLETED	0	2018-09-28 13:14:55.639	594ms	53ms	0.0%	0	0	0	0
4	0d/9f6b51	2001	sortAcns (sorting list4.acns.txt)	COMPLETED	0	2018-09-28 13:14:55.667	598ms	54ms	0.0%	0	0	0	0
5	f8/01e25b	2258	commonAcns (comm list1.acns.txt vs list2.acns.txt)	COMPLETED	0	2018-09-28 13:14:56.228	685ms	92ms	0.0%	0	0	0	0
8	98/893b5f	2268	commonAcns (comm list1.acns.txt vs list4.acns.txt)	COMPLETED	0	2018-09-28 13:14:56.316	603ms	38ms	0.0%	0	0	0	0
7	9f/9d9422	2259	commonAcns (comm list1.acns.txt vs list3.acns.txt)	COMPLETED	0	2018-09-28 13:14:56.256	763ms	86ms	0.0%	0	0	0	0
6	c9/ecb1ae	2261	commonAcns (comm list2.acns.txt vs list3.acns.txt)	COMPLETED	0	2018-09-28 13:14:56.267	759ms	69ms	0.0%	0	0	0	0
10	35/56843a	2568	commonAcns (comm list2.acns.txt vs list4.acns.txt)	COMPLETED	0	2018-09-28 13:14:56.929	340ms	20ms	0.0%	0	0	0	0
9	31/088901	2570	commonAcns (comm list3.acns.txt vs list4.acns.txt)	COMPLETED	0	2018-09-28 13:14:56.955	325ms	37ms	0.0%	0	0	0	0
11	1b/555659	2686	listCommons (common list size: 6)	COMPLETED	0	2018-09-28 13:14:57.316	544ms	73ms	0.0%	0	0	0	0
```

