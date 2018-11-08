## Synopsis

> The collect operator collects all the items emitted by a channel to a List and return the resulting object as a sole emission


```
 commons.map{ROW->ROW[0]+","+ROW[1]}.collect()
```

va collecter toutes les paires 'label/path` et retourner une liste contenant l'output de chaque process précédent.



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
 24   		set label,file("comm.txt") into commons
 25   	script:
 26   	"""
 27   	comm -12 "${sorted1}" "${sorted2}" > comm.txt
 28   	"""
 29   }
 30   
 31   process listCommons {
 32   	tag "common list size: ${array_of_rows.size()}"
 33   	input:
 34   		val array_of_rows from commons.map{ROW->ROW[0]+","+ROW[1]}.collect()
 35   	output:
 36   		file("table.csv")
 37   		file("distinct.acns.txt")
 38   	script:
 39   	"""
 40   	## table.csv est un fichier tsv. 1st column: label, 2nd column: path to file of common acns
 41   	echo '${array_of_rows.join("\n")}' > table.csv
 42   	
 43   	## loop over each path in the second file , concatenate and extract the uniq
 44   	cut -d ',' -f2 table.csv | while read F
 45   	do
 46   		cat \$F
 47   	done | sort | uniq > distinct.acns.txt
 48   	"""
 49   
 50   }
```


## Execute

```
../bin/nextflow run -resume -with-trace trace.tsv -with-report report.html -with-timeline timeline.html -with-dag flowchart.png workflow.nf --acns '../data/list*.acns.txt'
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [cranky_wiles] - revision: eea5eea3ad
[warm up] executor > local
[a4/ebdadf] Submitted process > sortAcns (sorting list4.acns.txt)
[7f/6d79e3] Submitted process > sortAcns (sorting list3.acns.txt)
[53/c535e8] Submitted process > sortAcns (sorting list2.acns.txt)
[1c/3712cc] Submitted process > sortAcns (sorting list1.acns.txt)
[76/fc9666] Submitted process > commonAcns (comm list3.acns.txt vs list4.acns.txt)
[e9/eb8a9e] Submitted process > commonAcns (comm list2.acns.txt vs list3.acns.txt)
[09/ae4f47] Submitted process > commonAcns (comm list2.acns.txt vs list4.acns.txt)
[4e/e14ddb] Submitted process > commonAcns (comm list1.acns.txt vs list3.acns.txt)
[f6/8ce91e] Submitted process > commonAcns (comm list1.acns.txt vs list4.acns.txt)
[8b/816df3] Submitted process > commonAcns (comm list1.acns.txt vs list2.acns.txt)
[05/8ee4ed] Submitted process > listCommons (common list size: 6)
```


## Files

```
work/7f/6d79e3f15ec3b2ae5fa22a53654526/list3.acns.txt
work/7f/6d79e3f15ec3b2ae5fa22a53654526/list3.acns.txt.sorted.txt
work/1c/3712ccdb122e1425fd552a67f155bf/list1.acns.txt.sorted.txt
work/1c/3712ccdb122e1425fd552a67f155bf/list1.acns.txt
work/a4/ebdadfc99970b7f4b12dfbedbdf5ba/list4.acns.txt.sorted.txt
work/a4/ebdadfc99970b7f4b12dfbedbdf5ba/list4.acns.txt
work/05/8ee4ed50b88cfadb6d518f572fe6eb/distinct.acns.txt
work/05/8ee4ed50b88cfadb6d518f572fe6eb/table.csv
work/8b/816df3bcd79f418dcdd6d5d76ed99e/comm.txt
work/09/ae4f47d80cac8bed8d4276880cb52d/comm.txt
work/76/fc9666e74095d8da782a6f053660ff/comm.txt
work/4e/e14ddbe6884038b20cda2fa8620dea/comm.txt
work/e9/eb8a9e28daf39b6d1be910bf137125/comm.txt
work/53/c535e8b40011070b3c5adefd881236/list2.acns.txt.sorted.txt
work/53/c535e8b40011070b3c5adefd881236/list2.acns.txt
work/f6/8ce91eef639951ee1ee88e4e46328a/comm.txt
```



## Workflow

![Workflow](flowchart.png)


## Trace

```
task_id	hash	native_id	name	status	exit	submit	duration	realtime	%cpu	rss	vmem	rchar	wchar
2	a4/ebdadf	15305	sortAcns (sorting list4.acns.txt)	COMPLETED	0	2018-11-08 15:30:01.459	405ms	24ms	0.0%	0	0	0	0
1	7f/6d79e3	15324	sortAcns (sorting list3.acns.txt)	COMPLETED	0	2018-11-08 15:30:01.600	421ms	44ms	0.0%	0	0	0	0
3	53/c535e8	15429	sortAcns (sorting list2.acns.txt)	COMPLETED	0	2018-11-08 15:30:01.889	494ms	78ms	0.0%	0	0	0	0
4	1c/3712cc	15460	sortAcns (sorting list1.acns.txt)	COMPLETED	0	2018-11-08 15:30:02.054	375ms	15ms	0.0%	0	0	0	0
5	76/fc9666	15552	commonAcns (comm list3.acns.txt vs list4.acns.txt)	COMPLETED	0	2018-11-08 15:30:02.405	337ms	20ms	0.0%	0	0	0	0
6	e9/eb8a9e	15560	commonAcns (comm list2.acns.txt vs list3.acns.txt)	COMPLETED	0	2018-11-08 15:30:02.442	334ms	34ms	0.0%	0	0	0	0
7	09/ae4f47	15671	commonAcns (comm list2.acns.txt vs list4.acns.txt)	COMPLETED	0	2018-11-08 15:30:02.754	202ms	23ms	0.0%	0	0	0	0
8	4e/e14ddb	15698	commonAcns (comm list1.acns.txt vs list3.acns.txt)	COMPLETED	0	2018-11-08 15:30:02.795	229ms	21ms	0.0%	0	0	0	0
9	f6/8ce91e	15789	commonAcns (comm list1.acns.txt vs list4.acns.txt)	COMPLETED	0	2018-11-08 15:30:02.969	236ms	18ms	0.0%	0	0	0	0
10	8b/816df3	15822	commonAcns (comm list1.acns.txt vs list2.acns.txt)	COMPLETED	0	2018-11-08 15:30:03.030	184ms	22ms	0.0%	0	0	0	0
11	05/8ee4ed	15908	listCommons (common list size: 6)	COMPLETED	0	2018-11-08 15:30:03.223	211ms	25ms	0.0%	0	0	0	0
```

