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
N E X T F L O W  ~  version 0.32.0
Launching `workflow.nf` [clever_mccarthy] - revision: 111c7d7269
[warm up] executor > local
[fe/d431a3] Submitted process > sortAcns (sorting list4.acns.txt)
[87/21f4e0] Submitted process > sortAcns (sorting list1.acns.txt)
[96/9c5f6d] Submitted process > sortAcns (sorting list3.acns.txt)
[a8/7b4bbb] Submitted process > sortAcns (sorting list2.acns.txt)
[03/f3e6d0] Submitted process > commonAcns (comm list3.acns.txt vs list4.acns.txt)
[ff/2b16c0] Submitted process > commonAcns (comm list1.acns.txt vs list4.acns.txt)
[4f/b9a7b6] Submitted process > commonAcns (comm list1.acns.txt vs list3.acns.txt)
[b1/6a2d80] Submitted process > commonAcns (comm list2.acns.txt vs list4.acns.txt)
[aa/a38135] Submitted process > commonAcns (comm list1.acns.txt vs list2.acns.txt)
[3f/8c8bf2] Submitted process > commonAcns (comm list2.acns.txt vs list3.acns.txt)
[60/65ef5c] Submitted process > listCommons (common list size: 6)
[07/383969] Submitted process > each (processing AF188126.1)
[1c/522a1a] Submitted process > each (processing AF002816.1)
[dc/9f3696] Submitted process > each (processing AF004836.1)
[73/08796f] Submitted process > each (processing AX244961.1)
[3b/359ccf] Submitted process > each (processing AF002815.1)
[e3/5544c9] Submitted process > each (processing AX244962.1)
[59/e76a89] Submitted process > each (processing AF188530.1)
[1f/e32102] Submitted process > each (processing AX244963.1)
[1e/ad8b3d] Submitted process > each (processing AX244964.1)
[40/9f7c35] Submitted process > each (processing AX244967.1)
[86/a70e0f] Submitted process > each (processing AX244965.1)
[5e/2e50fd] Submitted process > each (processing AX244966.1)
[3a/423f33] Submitted process > each (processing AY116592.1)
[f7/44e607] Submitted process > each (processing NM_017590.5)
[aa/33598d] Submitted process > each (processing AX244968.1)
```


## Files

```
work/fe/d431a3679625941aa86c4c60520a0a/list4.acns.txt
work/fe/d431a3679625941aa86c4c60520a0a/list4.acns.txt.sorted.txt
work/a8/7b4bbb0bd07a78b43987819dc8f8c0/list2.acns.txt
work/a8/7b4bbb0bd07a78b43987819dc8f8c0/list2.acns.txt.sorted.txt
work/87/21f4e0e186ddd1ff1895f713034503/list1.acns.txt
work/87/21f4e0e186ddd1ff1895f713034503/list1.acns.txt.sorted.txt
work/96/9c5f6dbfb98a306180f5bcfa3f4ef9/list3.acns.txt
work/96/9c5f6dbfb98a306180f5bcfa3f4ef9/list3.acns.txt.sorted.txt
work/03/f3e6d021b1b47b6bcf5654a4854c32/comm.txt
work/ff/2b16c0089f3332b186277d7cb6bbe2/comm.txt
work/4f/b9a7b6ff26c5180b3d6cf6a2777c54/comm.txt
work/b1/6a2d8071a1bb99566940d3c0f5634c/comm.txt
work/aa/a381353e2bb17a882ee6e16990432b/comm.txt
work/3f/8c8bf26a996cd5b990bcf5adaa84a7/comm.txt
work/60/65ef5cd2c0b70f69af6022b22adcb9/table.csv
work/60/65ef5cd2c0b70f69af6022b22adcb9/distcint.acns.txt
```


