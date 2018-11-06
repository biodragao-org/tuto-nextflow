## Synopsis
dans ce workflow, on définit un `flux`/ `channel`/ `stream` de noms de fichiers spécifié en argument.

```
acn_file_channel = Channel.fromPath( "${params.acns}")
```

chacun de ces fichiers sert de `input` pour le workflow.

```
        input:
                file acnFile from acn_file_channel

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
		file("${acnFile}.sorted.txt")
	script:
	
	"""
	sort '${acnFile}' > "${acnFile}.sorted.txt"
	"""
}
```


## Execute

```
../bin/nextflow run -resume -with-trace trace.tsv -with-report report.html -with-timeline timeline.html -with-dag flowchart.png workflow.nf --acns '../data/list*.acns.txt'
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [grave_sammet] - revision: 5846808ae4
[warm up] executor > local
[23/95a314] Submitted process > sortAcns (sorting list4.acns.txt)
[e9/198d97] Submitted process > sortAcns (sorting list3.acns.txt)
[a7/3e8610] Submitted process > sortAcns (sorting list2.acns.txt)
[52/95f8d7] Submitted process > sortAcns (sorting list1.acns.txt)
```


## Files

```
work/23/95a314c67f09f1295288ff5cac4c04/list4.acns.txt.sorted.txt
work/23/95a314c67f09f1295288ff5cac4c04/list4.acns.txt
work/a7/3e86100bec490f2d79d547823ac1aa/list2.acns.txt.sorted.txt
work/a7/3e86100bec490f2d79d547823ac1aa/list2.acns.txt
work/e9/198d97234c0fb53972614d034686c6/list3.acns.txt
work/e9/198d97234c0fb53972614d034686c6/list3.acns.txt.sorted.txt
work/52/95f8d7db3744912d140c6a670847c6/list1.acns.txt.sorted.txt
work/52/95f8d7db3744912d140c6a670847c6/list1.acns.txt
```



## Workflow

![Workflow](flowchart.png)


## Trace

```
task_id	hash	native_id	name	status	exit	submit	duration	realtime	%cpu	rss	vmem	rchar	wchar
2	23/95a314	6341	sortAcns (sorting list4.acns.txt)	COMPLETED	0	2018-11-06 10:56:07.382	434ms	50ms	0.0%	0	0	0	0
1	e9/198d97	6403	sortAcns (sorting list3.acns.txt)	COMPLETED	0	2018-11-06 10:56:07.461	758ms	40ms	0.0%	0	0	0	0
3	a7/3e8610	6407	sortAcns (sorting list2.acns.txt)	COMPLETED	0	2018-11-06 10:56:07.845	403ms	41ms	0.0%	0	0	0	0
4	52/95f8d7	6526	sortAcns (sorting list1.acns.txt)	COMPLETED	0	2018-11-06 10:56:08.232	208ms	25ms	0.0%	0	0	0	0
```

