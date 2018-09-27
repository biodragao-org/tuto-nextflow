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
../bin/nextflow run workflow.nf --acns '../data/list*.acns.txt'
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [elated_mahavira] - revision: 5846808ae4
[warm up] executor > local
[a8/f8e15f] Submitted process > sortAcns (sorting list3.acns.txt)
[6c/f0ef49] Submitted process > sortAcns (sorting list2.acns.txt)
[ed/cb9145] Submitted process > sortAcns (sorting list4.acns.txt)
[5a/1100df] Submitted process > sortAcns (sorting list1.acns.txt)
```


## Files

```
work/a8/f8e15fd6cecdabad1fc1a17d509cd8/list3.acns.txt
work/a8/f8e15fd6cecdabad1fc1a17d509cd8/list3.acns.txt.sorted.txt
work/32/63187f6c0eef126dacea9b4b4bf41e/list4.acns.txt
work/32/63187f6c0eef126dacea9b4b4bf41e/list4.acns.txt.sorted.txt
work/bc/6650c1f165fa79c66ece57b7558980/list3.acns.txt
work/bc/6650c1f165fa79c66ece57b7558980/list3.acns.txt.sorted.txt
work/5a/1100df12a52159ab8d18b141ea7f78/list1.acns.txt
work/5a/1100df12a52159ab8d18b141ea7f78/list1.acns.txt.sorted.txt
work/6c/f0ef492e65692e065bbee09adecf8f/list2.acns.txt.sorted.txt
work/6c/f0ef492e65692e065bbee09adecf8f/list2.acns.txt
work/15/7517e0b82324505cdedfc52c645875/list2.acns.txt.sorted.txt
work/15/7517e0b82324505cdedfc52c645875/list2.acns.txt
work/ed/cb91451c93e583375c74b254fff4f2/list4.acns.txt
work/ed/cb91451c93e583375c74b254fff4f2/list4.acns.txt.sorted.txt
work/a1/75ff6926526b6bd179efc14d536354/list1.acns.txt
work/a1/75ff6926526b6bd179efc14d536354/list1.acns.txt.sorted.txt
```


