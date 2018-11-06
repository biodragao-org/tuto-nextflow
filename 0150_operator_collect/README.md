## Synopsis
> The collect operator collects all the items emitted by a channel to a List and return the resulting object as a sole emission


```
 commons.map{ROW->ROW[0]+","+ROW[1]}.collect()
```

va collecter toutes les paires 'label/path` et retourner une liste contenant l'output de chaque process précédent.



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
		file("distinct.acns.txt")
	script:
	"""
	## table.csv est un fichier tsv. 1st column: label, 2nd column: path to file of common acns
	echo '${array_of_rows.join("\n")}' > table.csv
	
	## loop over each path in the second file , concatenate and extract the uniq
	cut -d ',' -f2 table.csv | while read F
	do
		cat \$F
	done | sort | uniq > distinct.acns.txt
	"""

}
```


## Execute

```
../bin/nextflow run -resume -with-trace trace.tsv -with-report report.html -with-timeline timeline.html -with-dag flowchart.png workflow.nf --acns '../data/list*.acns.txt'
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [reverent_hugle] - revision: eea5eea3ad
[warm up] executor > local
[a4/ebdadf] Submitted process > sortAcns (sorting list4.acns.txt)
[7f/6d79e3] Submitted process > sortAcns (sorting list3.acns.txt)
[53/c535e8] Submitted process > sortAcns (sorting list2.acns.txt)
[1c/3712cc] Submitted process > sortAcns (sorting list1.acns.txt)
[70/4102bf] Submitted process > commonAcns (comm list3.acns.txt vs list4.acns.txt)
[de/ffcc78] Submitted process > commonAcns (comm list2.acns.txt vs list4.acns.txt)
[25/e3b6b3] Submitted process > commonAcns (comm list2.acns.txt vs list3.acns.txt)
[ce/50e3be] Submitted process > commonAcns (comm list1.acns.txt vs list3.acns.txt)
[11/fb553b] Submitted process > commonAcns (comm list1.acns.txt vs list4.acns.txt)
[36/f2d95d] Submitted process > commonAcns (comm list1.acns.txt vs list2.acns.txt)
[56/3bca23] Submitted process > listCommons (common list size: 6)
```


## Files

```
work/7f/6d79e3f15ec3b2ae5fa22a53654526/list3.acns.txt
work/7f/6d79e3f15ec3b2ae5fa22a53654526/list3.acns.txt.sorted.txt
work/1c/3712ccdb122e1425fd552a67f155bf/list1.acns.txt.sorted.txt
work/1c/3712ccdb122e1425fd552a67f155bf/list1.acns.txt
work/a4/ebdadfc99970b7f4b12dfbedbdf5ba/list4.acns.txt.sorted.txt
work/a4/ebdadfc99970b7f4b12dfbedbdf5ba/list4.acns.txt
work/36/f2d95d31c6297763ba52528f60ab05/comm.txt
work/56/3bca23ca49b227c65fa083040f5362/distinct.acns.txt
work/56/3bca23ca49b227c65fa083040f5362/table.csv
work/de/ffcc78a46e6e468ef3d2d6d1b7ef3f/comm.txt
work/11/fb553bab76dbdd939ffb394d26e27d/comm.txt
work/53/c535e8b40011070b3c5adefd881236/list2.acns.txt.sorted.txt
work/53/c535e8b40011070b3c5adefd881236/list2.acns.txt
work/70/4102bf422b1e89a7b6762c94157519/comm.txt
work/ce/50e3bea8143e36af2f262a22a08ccf/comm.txt
work/25/e3b6b37ef04e4316b5ee9d5a68260a/comm.txt
```



## Workflow

![Workflow](flowchart.png)


## Trace

```
task_id	hash	native_id	name	status	exit	submit	duration	realtime	%cpu	rss	vmem	rchar	wchar
1	7f/6d79e3	10004	sortAcns (sorting list3.acns.txt)	COMPLETED	0	2018-11-06 10:57:02.846	263ms	39ms	0.0%	0	0	0	0
2	a4/ebdadf	10000	sortAcns (sorting list4.acns.txt)	COMPLETED	0	2018-11-06 10:57:02.807	418ms	30ms	0.0%	0	0	0	0
3	53/c535e8	10123	sortAcns (sorting list2.acns.txt)	COMPLETED	0	2018-11-06 10:57:03.144	525ms	35ms	0.0%	0	0	0	0
4	1c/3712cc	10144	sortAcns (sorting list1.acns.txt)	COMPLETED	0	2018-11-06 10:57:03.242	528ms	56ms	0.0%	0	0	0	0
5	70/4102bf	10246	commonAcns (comm list3.acns.txt vs list4.acns.txt)	COMPLETED	0	2018-11-06 10:57:03.713	387ms	14ms	0.0%	0	0	0	0
6	de/ffcc78	10255	commonAcns (comm list2.acns.txt vs list4.acns.txt)	COMPLETED	0	2018-11-06 10:57:03.777	352ms	61ms	0.0%	0	0	0	0
7	25/e3b6b3	10371	commonAcns (comm list2.acns.txt vs list3.acns.txt)	COMPLETED	0	2018-11-06 10:57:04.110	347ms	34ms	0.0%	0	0	0	0
9	ce/50e3be	10376	commonAcns (comm list1.acns.txt vs list3.acns.txt)	COMPLETED	0	2018-11-06 10:57:04.135	356ms	47ms	0.0%	0	0	0	0
10	36/f2d95d	10495	commonAcns (comm list1.acns.txt vs list2.acns.txt)	COMPLETED	0	2018-11-06 10:57:04.505	322ms	30ms	0.0%	0	0	0	0
8	11/fb553b	10493	commonAcns (comm list1.acns.txt vs list4.acns.txt)	COMPLETED	0	2018-11-06 10:57:04.477	404ms	40ms	0.0%	0	0	0	0
11	56/3bca23	10612	listCommons (common list size: 6)	COMPLETED	0	2018-11-06 10:57:04.908	371ms	59ms	0.0%	0	0	0	0
```

