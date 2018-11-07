## Synopsis

Ici l'output est constituté par un `set`/`vector`/`liste` de données contenant deux objets: le nom original du fichier et le nom du fichier après le trie.

```
 output:
                set acnFile, file("${acnFile}.sorted.txt")
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
  8   		set acnFile, file("${acnFile}.sorted.txt")
  9   	script:
 10   	
 11   	"""
 12   	sort '${acnFile}' > "${acnFile}.sorted.txt"
 13   	"""
 14   }
```


## Execute

```
../bin/nextflow run -resume -with-trace trace.tsv -with-report report.html -with-timeline timeline.html -with-dag flowchart.png workflow.nf --acns '../data/list*.acns.txt'
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [gloomy_bohr] - revision: efdcb56eb1
[warm up] executor > local
[37/f120d7] Submitted process > sortAcns (sorting list4.acns.txt)
[59/db35c9] Submitted process > sortAcns (sorting list3.acns.txt)
[49/38e8e4] Submitted process > sortAcns (sorting list1.acns.txt)
[47/36df62] Submitted process > sortAcns (sorting list2.acns.txt)
```


## Files

```
work/59/db35c920c0fc2f86f2d17cdfa1c4ca/list3.acns.txt
work/59/db35c920c0fc2f86f2d17cdfa1c4ca/list3.acns.txt.sorted.txt
work/37/f120d793451005ccbb5d40d16633b8/list4.acns.txt.sorted.txt
work/37/f120d793451005ccbb5d40d16633b8/list4.acns.txt
work/49/38e8e41dc64e29a7387ec57d1db501/list1.acns.txt.sorted.txt
work/49/38e8e41dc64e29a7387ec57d1db501/list1.acns.txt
work/47/36df62b51d61e795a13ce1abc3bc90/list2.acns.txt.sorted.txt
work/47/36df62b51d61e795a13ce1abc3bc90/list2.acns.txt
```



## Workflow

![Workflow](flowchart.png)


## Trace

```
task_id	hash	native_id	name	status	exit	submit	duration	realtime	%cpu	rss	vmem	rchar	wchar
1	37/f120d7	15982	sortAcns (sorting list4.acns.txt)	COMPLETED	0	2018-11-07 10:10:37.284	787ms	58ms	0.0%	0	0	0	0
2	59/db35c9	15985	sortAcns (sorting list3.acns.txt)	COMPLETED	0	2018-11-07 10:10:37.335	831ms	93ms	0.0%	0	0	0	0
3	49/38e8e4	16106	sortAcns (sorting list1.acns.txt)	COMPLETED	0	2018-11-07 10:10:38.087	509ms	42ms	0.0%	0	0	0	0
4	47/36df62	16113	sortAcns (sorting list2.acns.txt)	COMPLETED	0	2018-11-07 10:10:38.173	476ms	62ms	0.0%	0	0	0	0
```

