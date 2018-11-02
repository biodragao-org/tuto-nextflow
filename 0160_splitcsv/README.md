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
		file("distcint.acns.txt") into distinct_acns
	script:
	"""
	echo '${array_of_rows.join("\n")}' > table.csv
	cut -d ',' -f2 table.csv | while read F
	do
		cat \$F
	done | sort | uniq > distcint.acns.txt
	"""

}

process each {
	tag "processing ${acn}"
	input:	
		val acn from distinct_acns.splitCsv(sep:',',strip:true).map{ARRAY->ARRAY[0]}
	script:
	"""
	echo "${acn}"
	"""
	}
```


## Execute

```
../bin/nextflow run  workflow.nf --acns '../data/list*.acns.txt'
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [confident_raman] - revision: 111c7d7269
[warm up] executor > local
[20/bf5fb9] Submitted process > sortAcns (sorting list3.acns.txt)
[4d/139ae7] Submitted process > sortAcns (sorting list4.acns.txt)
[c5/19530c] Submitted process > sortAcns (sorting list2.acns.txt)
[4a/ee1b45] Submitted process > sortAcns (sorting list1.acns.txt)
[f9/e1f4b9] Submitted process > commonAcns (comm list3.acns.txt vs list4.acns.txt)
[04/57ceec] Submitted process > commonAcns (comm list2.acns.txt vs list4.acns.txt)
[fb/c5e4cc] Submitted process > commonAcns (comm list2.acns.txt vs list3.acns.txt)
[9f/883d5e] Submitted process > commonAcns (comm list1.acns.txt vs list3.acns.txt)
[47/8d6ec0] Submitted process > commonAcns (comm list1.acns.txt vs list4.acns.txt)
[a9/0965fb] Submitted process > commonAcns (comm list1.acns.txt vs list2.acns.txt)
[93/aec6d8] Submitted process > listCommons (common list size: 6)
[25/692648] Submitted process > each (processing AF002816.1)
[38/af7e92] Submitted process > each (processing AF004836.1)
[74/aafb68] Submitted process > each (processing AF002815.1)
[d1/1ebadc] Submitted process > each (processing AF188126.1)
[ac/3d1235] Submitted process > each (processing AF188530.1)
[10/ed9c2c] Submitted process > each (processing AX244961.1)
[75/57beba] Submitted process > each (processing AX244963.1)
[8b/eed748] Submitted process > each (processing AX244964.1)
[eb/403e78] Submitted process > each (processing AX244965.1)
[27/96b9de] Submitted process > each (processing AX244966.1)
[e1/9172e1] Submitted process > each (processing AX244967.1)
[62/255ea6] Submitted process > each (processing AX244968.1)
[e5/855f99] Submitted process > each (processing AY116592.1)
[c6/437a8f] Submitted process > each (processing AX244962.1)
[23/3c6904] Submitted process > each (processing NM_017590.5)
```


## Files

```
work/9f/883d5e9f07e922ced02ffa02cb2374/comm.txt
work/fb/c5e4ccf0c11ef1d4dbbcd6756ab92f/comm.txt
work/f9/e1f4b9c1d30828878553c5be8878a3/comm.txt
work/93/aec6d8fd8ba16b89d4c2bb07f364c8/table.csv
work/93/aec6d8fd8ba16b89d4c2bb07f364c8/distcint.acns.txt
work/4d/139ae7a830fe8525505ff5118fa52f/list4.acns.txt.sorted.txt
work/4d/139ae7a830fe8525505ff5118fa52f/list4.acns.txt
work/4a/ee1b454a312cb1cdbce94dee2bbd0d/list1.acns.txt.sorted.txt
work/4a/ee1b454a312cb1cdbce94dee2bbd0d/list1.acns.txt
work/a9/0965fb5e25cd3d895245eb94bbf240/comm.txt
work/c5/19530c49c964c11cb3f2d6bd4877ff/list2.acns.txt.sorted.txt
work/c5/19530c49c964c11cb3f2d6bd4877ff/list2.acns.txt
work/04/57ceec2c5553647c59895187abe056/comm.txt
work/20/bf5fb9c59f08b4a79d21dde15fa996/list3.acns.txt
work/20/bf5fb9c59f08b4a79d21dde15fa996/list3.acns.txt.sorted.txt
work/47/8d6ec0b4333e08f74650a85f791386/comm.txt
```


