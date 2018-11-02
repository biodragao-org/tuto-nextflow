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
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [boring_williams] - revision: 159f833755
[warm up] executor > local
[7f/6d79e3] Submitted process > sortAcns (sorting list3.acns.txt)
[53/c535e8] Submitted process > sortAcns (sorting list2.acns.txt)
[a4/ebdadf] Submitted process > sortAcns (sorting list4.acns.txt)
[1c/3712cc] Submitted process > sortAcns (sorting list1.acns.txt)
[23/653c2c] Submitted process > commonAcns (comm list2.acns.txt vs list3.acns.txt)
[27/eb182a] Submitted process > commonAcns (comm list3.acns.txt vs list4.acns.txt)
[66/3c39f4] Submitted process > commonAcns (comm list2.acns.txt vs list4.acns.txt)
[56/e9a179] Submitted process > commonAcns (comm list1.acns.txt vs list2.acns.txt)
[a7/88c133] Submitted process > commonAcns (comm list1.acns.txt vs list4.acns.txt)
[0a/d8fc47] Submitted process > commonAcns (comm list1.acns.txt vs list3.acns.txt)
[3b/74d308] Submitted process > listCommons (common list size: 6)
```


## Files

```
work/23/653c2c05da5f5ce023edbc0519ada3/comm.txt
work/7f/6d79e3f15ec3b2ae5fa22a53654526/list3.acns.txt
work/7f/6d79e3f15ec3b2ae5fa22a53654526/list3.acns.txt.sorted.txt
work/1c/3712ccdb122e1425fd552a67f155bf/list1.acns.txt.sorted.txt
work/1c/3712ccdb122e1425fd552a67f155bf/list1.acns.txt
work/0a/d8fc47cd073a1e95bd0bffb8200cec/comm.txt
work/a4/ebdadfc99970b7f4b12dfbedbdf5ba/list4.acns.txt.sorted.txt
work/a4/ebdadfc99970b7f4b12dfbedbdf5ba/list4.acns.txt
work/a7/88c13391137ff95454265b14f8f04e/comm.txt
work/56/e9a179276034c3adc72cf0b7f6ce41/comm.txt
work/53/c535e8b40011070b3c5adefd881236/list2.acns.txt.sorted.txt
work/53/c535e8b40011070b3c5adefd881236/list2.acns.txt
work/3b/74d3084c04845eac2a3b8da126199c/table.csv
work/3b/74d3084c04845eac2a3b8da126199c/distcint.acns.txt
work/66/3c39f4ba6661bff597baa7f17e61b0/comm.txt
work/27/eb182af0b97ffd529ec983a3117817/comm.txt
```



## Workflow

![Workflow](flowchart.png)


## Trace

```
task_id	hash	native_id	name	status	exit	submit	duration	realtime	%cpu	rss	vmem	rchar	wchar
1	7f/6d79e3	1715	sortAcns (sorting list3.acns.txt)	COMPLETED	0	2018-11-02 16:10:33.998	356ms	24ms	0.0%	0	0	0	0
3	53/c535e8	1720	sortAcns (sorting list2.acns.txt)	COMPLETED	0	2018-11-02 16:10:34.051	454ms	38ms	0.0%	0	0	0	0
2	a4/ebdadf	1851	sortAcns (sorting list4.acns.txt)	COMPLETED	0	2018-11-02 16:10:34.377	505ms	40ms	0.0%	0	0	0	0
4	1c/3712cc	1867	sortAcns (sorting list1.acns.txt)	COMPLETED	0	2018-11-02 16:10:34.556	369ms	16ms	0.0%	0	0	0	0
5	23/653c2c	2039	commonAcns (comm list2.acns.txt vs list3.acns.txt)	COMPLETED	0	2018-11-02 16:10:34.899	320ms	32ms	0.0%	0	0	0	0
6	27/eb182a	2059	commonAcns (comm list3.acns.txt vs list4.acns.txt)	COMPLETED	0	2018-11-02 16:10:34.941	311ms	40ms	0.0%	0	0	0	0
7	66/3c39f4	2277	commonAcns (comm list2.acns.txt vs list4.acns.txt)	COMPLETED	0	2018-11-02 16:10:35.226	243ms	49ms	0.0%	0	0	0	0
8	56/e9a179	2309	commonAcns (comm list1.acns.txt vs list2.acns.txt)	COMPLETED	0	2018-11-02 16:10:35.283	222ms	21ms	0.0%	0	0	0	0
9	0a/d8fc47	2496	commonAcns (comm list1.acns.txt vs list3.acns.txt)	COMPLETED	0	2018-11-02 16:10:35.510	252ms	22ms	0.0%	0	0	0	0
10	a7/88c133	2483	commonAcns (comm list1.acns.txt vs list4.acns.txt)	COMPLETED	0	2018-11-02 16:10:35.481	293ms	47ms	0.0%	0	0	0	0
11	3b/74d308	2662	listCommons (common list size: 6)	COMPLETED	0	2018-11-02 16:10:35.786	267ms	25ms	0.0%	0	0	0	0
```

