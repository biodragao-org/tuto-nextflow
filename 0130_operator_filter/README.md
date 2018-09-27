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
	tag "comm ${sorted1.getName()} and ${sorted2.getName()}"
	input:
		set acn1,sorted1,acn2,sorted2 from acn_sorted1.
                                          combine(acn_sorted2).
                                          filter{ROW->ROW[1].getName().compareTo(ROW[3].getName())<0}
	output:
		set acn1,acn2,file("comm.txt")
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
Launching `workflow.nf` [serene_jennings] - revision: 41d209f8fc
[warm up] executor > local
[df/ce70dc] Submitted process > sortAcns (sorting list4.acns.txt)
[01/a970ae] Submitted process > sortAcns (sorting list3.acns.txt)
[91/4dfd7c] Submitted process > sortAcns (sorting list2.acns.txt)
[c7/6ef897] Submitted process > sortAcns (sorting list1.acns.txt)
[83/c7fd11] Submitted process > commonAcns (comm list2.acns.txt.sorted.txt and list3.acns.txt.sorted.txt)
[ce/1c333d] Submitted process > commonAcns (comm list1.acns.txt.sorted.txt and list4.acns.txt.sorted.txt)
[68/efbf28] Submitted process > commonAcns (comm list2.acns.txt.sorted.txt and list4.acns.txt.sorted.txt)
[e8/0ffece] Submitted process > commonAcns (comm list3.acns.txt.sorted.txt and list4.acns.txt.sorted.txt)
[a0/1c9301] Submitted process > commonAcns (comm list1.acns.txt.sorted.txt and list3.acns.txt.sorted.txt)
[9e/7cbf87] Submitted process > commonAcns (comm list1.acns.txt.sorted.txt and list2.acns.txt.sorted.txt)
```


## Files

```
work/4c/469a7de490056b0e1438553dbc837d/comm.txt
work/e8/0ffece7fb0f32705ffe2c22eed4da0/comm.txt
work/ce/1c333d9a40d7cbd63f1224664276ae/comm.txt
work/df/ce70dcbe6f45e6907619bdce5a30b9/list4.acns.txt
work/df/ce70dcbe6f45e6907619bdce5a30b9/list4.acns.txt.sorted.txt
work/91/4dfd7c2c7058c4c8ed2395d82e80f0/list2.acns.txt.sorted.txt
work/91/4dfd7c2c7058c4c8ed2395d82e80f0/list2.acns.txt
work/68/efbf2887e4a991719a79f5452dae09/comm.txt
work/ca/ce71ff469f6360ded8841d03f63a48/comm.txt
work/14/af51f1d4f236a563b7939609eebc68/list1.acns.txt
work/14/af51f1d4f236a563b7939609eebc68/list1.acns.txt.sorted.txt
work/c5/7dec187d52750b4e7739d29bdefa75/comm.txt
work/09/5a8efc8498fd320859cfc6528b7cb8/list3.acns.txt
work/09/5a8efc8498fd320859cfc6528b7cb8/list3.acns.txt.sorted.txt
work/e1/ebca8ced6ee49eae8611dd7ddc2ab3/comm.txt
work/c1/b4bf0865e18a1d3f9c7553e498bf3f/comm.txt
work/2d/879dc7e05a550a941b7a33d8cdba00/list4.acns.txt
work/2d/879dc7e05a550a941b7a33d8cdba00/list4.acns.txt.sorted.txt
work/d2/2ae842688e52b481af9923ee816110/comm.txt
work/24/e255b8e4a6077b40e3f74347363be7/list2.acns.txt.sorted.txt
work/24/e255b8e4a6077b40e3f74347363be7/list2.acns.txt
work/9e/7cbf87bd490e9c7417e26d1aa2b69b/comm.txt
work/01/a970ae451ac391fa923d735637ac55/list3.acns.txt
work/01/a970ae451ac391fa923d735637ac55/list3.acns.txt.sorted.txt
work/c7/6ef8975b40a2ac7550d391578eb2d0/list1.acns.txt
work/c7/6ef8975b40a2ac7550d391578eb2d0/list1.acns.txt.sorted.txt
work/83/c7fd11893065cf28dd1aa8e465dbf6/comm.txt
work/a0/1c930150f661617a3165b9c7a683ca/comm.txt
```


