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
Launching `workflow.nf` [amazing_church] - revision: 111c7d7269
[warm up] executor > local
[9d/d5947f] Submitted process > sortAcns (sorting list4.acns.txt)
[70/98ca43] Submitted process > sortAcns (sorting list3.acns.txt)
[85/d7e430] Submitted process > sortAcns (sorting list1.acns.txt)
[ad/4a40c2] Submitted process > sortAcns (sorting list2.acns.txt)
[4e/cf1ca8] Submitted process > commonAcns (comm list1.acns.txt vs list4.acns.txt)
[87/158091] Submitted process > commonAcns (comm list3.acns.txt vs list4.acns.txt)
[b8/f74417] Submitted process > commonAcns (comm list1.acns.txt vs list3.acns.txt)
[b1/d1df88] Submitted process > commonAcns (comm list2.acns.txt vs list3.acns.txt)
[0e/b55774] Submitted process > commonAcns (comm list1.acns.txt vs list2.acns.txt)
[e2/f278b7] Submitted process > commonAcns (comm list2.acns.txt vs list4.acns.txt)
[ab/6d4fe7] Submitted process > listCommons (common list size: 6)
[d4/d660cc] Submitted process > each (processing AF002816.1)
[e9/b2191c] Submitted process > each (processing AF004836.1)
[a3/995594] Submitted process > each (processing AF188126.1)
[fb/1c7935] Submitted process > each (processing AF002815.1)
[3e/53d0c2] Submitted process > each (processing AX244962.1)
[4c/91cb1f] Submitted process > each (processing AF188530.1)
[d1/568a40] Submitted process > each (processing AX244963.1)
[db/d13281] Submitted process > each (processing AX244961.1)
[04/1c5646] Submitted process > each (processing AX244965.1)
[cb/d8ccf8] Submitted process > each (processing AX244966.1)
[b0/021ee4] Submitted process > each (processing AX244964.1)
[37/b969e3] Submitted process > each (processing AX244968.1)
[c0/b178da] Submitted process > each (processing AY116592.1)
[66/600f9b] Submitted process > each (processing NM_017590.5)
[62/42c728] Submitted process > each (processing AX244967.1)
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
work/9d/d5947f35c9d29ef340b44effdd4fc4/list4.acns.txt
work/9d/d5947f35c9d29ef340b44effdd4fc4/list4.acns.txt.sorted.txt
work/ef/d1b121e28292c42d1a544f01cd6505/table.csv
work/ef/d1b121e28292c42d1a544f01cd6505/distcint.acns.txt
work/70/98ca432fff7389edcd46794a9bc206/list3.acns.txt
work/70/98ca432fff7389edcd46794a9bc206/list3.acns.txt.sorted.txt
work/85/d7e430ccefab4816421ffc4625a057/list1.acns.txt
work/85/d7e430ccefab4816421ffc4625a057/list1.acns.txt.sorted.txt
work/ad/4a40c20285e6a0c692d938b4f98a44/list2.acns.txt
work/ad/4a40c20285e6a0c692d938b4f98a44/list2.acns.txt.sorted.txt
work/4e/cf1ca85183a5847e2996b763f9bb12/comm.txt
work/87/158091b0186a5d72921f3503cb11d2/comm.txt
work/b8/f7441792a36ab03bf24bece0729b92/comm.txt
work/b1/d1df88c52a1ec299e7aa50b9bcd6cb/comm.txt
work/0e/b55774f86bb781efca6c0f9f9b547a/comm.txt
work/e2/f278b7cc82cb8cbf56ed4a1521b6f2/comm.txt
work/ab/6d4fe75841432b7a9a082f68af8bef/table.csv
work/ab/6d4fe75841432b7a9a082f68af8bef/distcint.acns.txt
```


