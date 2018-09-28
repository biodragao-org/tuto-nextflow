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
Launching `workflow.nf` [loving_nightingale] - revision: 111c7d7269
[warm up] executor > local
[6e/3460f0] Submitted process > sortAcns (sorting list3.acns.txt)
[c1/8b179e] Submitted process > sortAcns (sorting list1.acns.txt)
[04/6aacdc] Submitted process > sortAcns (sorting list4.acns.txt)
[e3/e44b68] Submitted process > sortAcns (sorting list2.acns.txt)
[24/06e656] Submitted process > commonAcns (comm list1.acns.txt vs list4.acns.txt)
[f7/5657f1] Submitted process > commonAcns (comm list3.acns.txt vs list4.acns.txt)
[e4/cbc71d] Submitted process > commonAcns (comm list1.acns.txt vs list2.acns.txt)
[55/32339f] Submitted process > commonAcns (comm list1.acns.txt vs list3.acns.txt)
[73/310fb7] Submitted process > commonAcns (comm list2.acns.txt vs list3.acns.txt)
[9d/67f767] Submitted process > commonAcns (comm list2.acns.txt vs list4.acns.txt)
[ef/d1b121] Submitted process > listCommons (common list size: 6)
[7d/b6b8e3] Submitted process > each (processing AF002816.1)
[63/ab4226] Submitted process > each (processing AF188126.1)
[ac/6d140e] Submitted process > each (processing AF004836.1)
[2b/e6b145] Submitted process > each (processing AF002815.1)
[a1/69e573] Submitted process > each (processing AX244962.1)
[07/b728e7] Submitted process > each (processing AF188530.1)
[01/65f341] Submitted process > each (processing AX244963.1)
[8d/3ebd51] Submitted process > each (processing AX244964.1)
[8d/601a97] Submitted process > each (processing AX244967.1)
[21/1b19cf] Submitted process > each (processing AX244965.1)
[40/c0aa32] Submitted process > each (processing AX244961.1)
[e9/e15b47] Submitted process > each (processing AY116592.1)
[56/c66e90] Submitted process > each (processing AX244968.1)
[22/a51e1a] Submitted process > each (processing NM_017590.5)
[89/58333e] Submitted process > each (processing AX244966.1)
```


## Files

```
work/04/6aacdc77ac5bef423076c78181f3fc/list4.acns.txt
work/04/6aacdc77ac5bef423076c78181f3fc/list4.acns.txt.sorted.txt
work/e3/e44b68597328966c52ddf3ce2c0848/list2.acns.txt
work/e3/e44b68597328966c52ddf3ce2c0848/list2.acns.txt.sorted.txt
work/6e/3460f01fbd633b186b9d7d34c8637a/list3.acns.txt
work/6e/3460f01fbd633b186b9d7d34c8637a/list3.acns.txt.sorted.txt
work/c1/8b179eb353818338046a7a78295831/list1.acns.txt
work/c1/8b179eb353818338046a7a78295831/list1.acns.txt.sorted.txt
work/24/06e65673ef60cb772bfa988700f93f/comm.txt
work/55/32339fca1edec2e3258290e5b940ac/comm.txt
work/f7/5657f14fcf2aeea71e1f493908af2f/comm.txt
work/e4/cbc71d0745c6317e8baf93916678db/comm.txt
work/73/310fb7c3f0149b97b501c5a24c013a/comm.txt
work/9d/67f76777b4dcefcc404569d171c836/comm.txt
work/ef/d1b121e28292c42d1a544f01cd6505/table.csv
work/ef/d1b121e28292c42d1a544f01cd6505/distcint.acns.txt
```


