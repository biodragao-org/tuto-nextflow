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
../bin/nextflow run workflow.nf --acns '../data/list*.acns.txt'
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [kickass_waddington] - revision: 50561d3246
[warm up] executor > local
[f9/e54a19] Submitted process > sortAcns (sorting list2.acns.txt)
[95/e143e9] Submitted process > sortAcns (sorting list3.acns.txt)
[51/8fa89a] Submitted process > sortAcns (sorting list4.acns.txt)
[53/429dab] Submitted process > sortAcns (sorting list1.acns.txt)
[68/906b96] Submitted process > commonAcns (comm list2.acns.txt vs list3.acns.txt)
[19/b740c4] Submitted process > commonAcns (comm list2.acns.txt vs list4.acns.txt)
[ae/fcd89b] Submitted process > commonAcns (comm list3.acns.txt vs list4.acns.txt)
[63/bcdaae] Submitted process > commonAcns (comm list1.acns.txt vs list3.acns.txt)
[c6/5fbbaf] Submitted process > commonAcns (comm list1.acns.txt vs list2.acns.txt)
[82/ca096d] Submitted process > commonAcns (comm list1.acns.txt vs list4.acns.txt)
```


## Files

```
work/47/5647d5a7a9ec19ed6ffe10c71da66a/comm.txt
work/68/906b96385ae8e37ba8cda85119079a/comm.txt
work/f9/e54a198398d449ca474a312eb82d52/list2.acns.txt.sorted.txt
work/f9/e54a198398d449ca474a312eb82d52/list2.acns.txt
work/b5/0b9362ea653e3e68810ce30201b3f8/comm.txt
work/b5/e8dcce943d78ff27630b7e69baa92b/comm.txt
work/43/03a54044960647783c960f65b2f696/list1.acns.txt
work/43/03a54044960647783c960f65b2f696/list1.acns.txt.sorted.txt
work/5a/4dfea410d36aa0307e3c260f78f41b/list4.acns.txt
work/5a/4dfea410d36aa0307e3c260f78f41b/list4.acns.txt.sorted.txt
work/53/429daba01451029237622146607ce2/list1.acns.txt
work/53/429daba01451029237622146607ce2/list1.acns.txt.sorted.txt
work/0d/ae97f9e41706873ce5c713acb2565e/comm.txt
work/63/bcdaae713eff99fc9d487b63d0298d/comm.txt
work/50/53289ceba63758ec8851a183d7cbf5/comm.txt
work/59/72f7ba855bacfdb76c9c8f2551b992/comm.txt
work/19/b740c43d572d04ccec3162d0d9564b/comm.txt
work/ae/fcd89b22e74e07c53bffec717bb050/comm.txt
work/95/e143e961f0522fd78fc9dce92f6634/list3.acns.txt
work/95/e143e961f0522fd78fc9dce92f6634/list3.acns.txt.sorted.txt
work/82/ca096d56db36f37d950de94b5fcbe5/comm.txt
work/74/b97215578de74ec8ca970a03eaa081/list2.acns.txt.sorted.txt
work/74/b97215578de74ec8ca970a03eaa081/list2.acns.txt
work/3e/4b85b4177e93c2c9f507ef2fd08e3d/list3.acns.txt
work/3e/4b85b4177e93c2c9f507ef2fd08e3d/list3.acns.txt.sorted.txt
work/c6/5fbbaf78204b5258245e08edeca5bb/comm.txt
work/51/8fa89afc5b28ce9eedd9ee361b24f2/list4.acns.txt
work/51/8fa89afc5b28ce9eedd9ee361b24f2/list4.acns.txt.sorted.txt
```


