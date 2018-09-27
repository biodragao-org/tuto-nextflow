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

// https://www.nextflow.io/docs/latest/operator.html#view

acn_sorted1.view{F->"CHANNEL 1 : "+F}

acn_sorted2.view{F->"CHANNEL 2 : "+F}
```


## Execute

```
../bin/nextflow run  workflow.nf --acns '../data/list*.acns.txt'
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [silly_mestorf] - revision: 699d554f84
[warm up] executor > local
[f3/1fa8e6] Submitted process > sortAcns (sorting list2.acns.txt)
[d8/78e802] Submitted process > sortAcns (sorting list4.acns.txt)
[fb/ea56c2] Submitted process > sortAcns (sorting list1.acns.txt)
[ae/8e13e9] Submitted process > sortAcns (sorting list3.acns.txt)
CHANNEL 1 : [list2.acns.txt, /home/lindenb/src/tuto-nextflow/0110_copy_channel/work/f3/1fa8e6f56185cbb67514298754afab/list2.acns.txt.sorted.txt]
CHANNEL 2 : [list2.acns.txt, /home/lindenb/src/tuto-nextflow/0110_copy_channel/work/f3/1fa8e6f56185cbb67514298754afab/list2.acns.txt.sorted.txt]
CHANNEL 1 : [list4.acns.txt, /home/lindenb/src/tuto-nextflow/0110_copy_channel/work/d8/78e802b3464a200f4f8374ef53027e/list4.acns.txt.sorted.txt]
CHANNEL 2 : [list4.acns.txt, /home/lindenb/src/tuto-nextflow/0110_copy_channel/work/d8/78e802b3464a200f4f8374ef53027e/list4.acns.txt.sorted.txt]
CHANNEL 1 : [list1.acns.txt, /home/lindenb/src/tuto-nextflow/0110_copy_channel/work/fb/ea56c2730a1175d2403724713fd590/list1.acns.txt.sorted.txt]
CHANNEL 2 : [list1.acns.txt, /home/lindenb/src/tuto-nextflow/0110_copy_channel/work/fb/ea56c2730a1175d2403724713fd590/list1.acns.txt.sorted.txt]
CHANNEL 1 : [list3.acns.txt, /home/lindenb/src/tuto-nextflow/0110_copy_channel/work/ae/8e13e9660b96885ba49b94cf8310d0/list3.acns.txt.sorted.txt]
CHANNEL 2 : [list3.acns.txt, /home/lindenb/src/tuto-nextflow/0110_copy_channel/work/ae/8e13e9660b96885ba49b94cf8310d0/list3.acns.txt.sorted.txt]
```


## Files

```
work/d8/78e802b3464a200f4f8374ef53027e/list4.acns.txt
work/d8/78e802b3464a200f4f8374ef53027e/list4.acns.txt.sorted.txt
work/b5/e2762d61655c3febbd8d43f990bd12/list4.acns.txt
work/b5/e2762d61655c3febbd8d43f990bd12/list4.acns.txt.sorted.txt
work/98/66104bc0f7d966337d66d954997a2c/list1.acns.txt
work/98/66104bc0f7d966337d66d954997a2c/list1.acns.txt.sorted.txt
work/87/3d69a0d366893fc7ba27c7729827d9/list2.acns.txt.sorted.txt
work/87/3d69a0d366893fc7ba27c7729827d9/list2.acns.txt
work/fb/ea56c2730a1175d2403724713fd590/list1.acns.txt
work/fb/ea56c2730a1175d2403724713fd590/list1.acns.txt.sorted.txt
work/ae/8e13e9660b96885ba49b94cf8310d0/list3.acns.txt
work/ae/8e13e9660b96885ba49b94cf8310d0/list3.acns.txt.sorted.txt
work/e6/a04b2331953372dfe5b2baf74d4393/list3.acns.txt
work/e6/a04b2331953372dfe5b2baf74d4393/list3.acns.txt.sorted.txt
work/f3/1fa8e6f56185cbb67514298754afab/list2.acns.txt.sorted.txt
work/f3/1fa8e6f56185cbb67514298754afab/list2.acns.txt
```


