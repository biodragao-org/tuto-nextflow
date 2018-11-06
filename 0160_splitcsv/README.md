## Synopsis
The `splitCsv` operator allows you to parse text items emitted by a channel, that are formatted using the CSV format, and split them into records or group them into list of records with a specified length.

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
		file("distinct.acns.txt") into distinct_acns
	script:
	"""
	echo '${array_of_rows.join("\n")}' > table.csv
	cut -d ',' -f2 table.csv | while read F
	do
		cat \$F
	done | sort | uniq > distinct.acns.txt
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
Launching `workflow.nf` [desperate_rubens] - revision: 405ebec4f4
[warm up] executor > local
[03/f7246d] Submitted process > sortAcns (sorting list4.acns.txt)
[db/c40c0d] Submitted process > sortAcns (sorting list3.acns.txt)
[82/95fad1] Submitted process > sortAcns (sorting list2.acns.txt)
[49/66a20e] Submitted process > sortAcns (sorting list1.acns.txt)
[db/266bdf] Submitted process > commonAcns (comm list3.acns.txt vs list4.acns.txt)
[fd/df29cd] Submitted process > commonAcns (comm list2.acns.txt vs list4.acns.txt)
[69/0db329] Submitted process > commonAcns (comm list2.acns.txt vs list3.acns.txt)
[71/cea31b] Submitted process > commonAcns (comm list1.acns.txt vs list3.acns.txt)
[ae/0348bb] Submitted process > commonAcns (comm list1.acns.txt vs list2.acns.txt)
[51/7b4a45] Submitted process > commonAcns (comm list1.acns.txt vs list4.acns.txt)
[1e/a096c9] Submitted process > listCommons (common list size: 6)
[8d/f99819] Submitted process > each (processing AF002816.1)
[32/be6b95] Submitted process > each (processing AF004836.1)
[14/dfba03] Submitted process > each (processing AF002815.1)
[69/4ae2ec] Submitted process > each (processing AF188126.1)
[2e/e1315f] Submitted process > each (processing AF188530.1)
[9a/9a3d24] Submitted process > each (processing AX244961.1)
[4d/2edb2d] Submitted process > each (processing AX244963.1)
[fd/68e3e9] Submitted process > each (processing AX244962.1)
[7a/789246] Submitted process > each (processing AX244964.1)
[e4/cc80dd] Submitted process > each (processing AX244966.1)
[90/8d8c66] Submitted process > each (processing AX244967.1)
[04/cd997b] Submitted process > each (processing AX244965.1)
[aa/7e8441] Submitted process > each (processing AX244968.1)
[e3/1e676b] Submitted process > each (processing AY116592.1)
[43/6ad2ba] Submitted process > each (processing NM_017590.5)
```


## Files

```
work/1e/a096c935e67d84b2ff71e67124cc0c/distinct.acns.txt
work/1e/a096c935e67d84b2ff71e67124cc0c/table.csv
work/82/95fad1b0c86ccca9671de571a13e86/list2.acns.txt.sorted.txt
work/82/95fad1b0c86ccca9671de571a13e86/list2.acns.txt
work/69/0db3297cedd7e3f707f6a09cd8c848/comm.txt
work/49/66a20e29b0ab906ba2d361e5117e2f/list1.acns.txt.sorted.txt
work/49/66a20e29b0ab906ba2d361e5117e2f/list1.acns.txt
work/51/7b4a452a52ced773d721315528f02c/comm.txt
work/03/f7246d9768b861a3d962352c80ccbc/list4.acns.txt.sorted.txt
work/03/f7246d9768b861a3d962352c80ccbc/list4.acns.txt
work/fd/df29cd4e95e5a44b48ef866c938dcd/comm.txt
work/db/c40c0da7905baa1789372f10763773/list3.acns.txt
work/db/c40c0da7905baa1789372f10763773/list3.acns.txt.sorted.txt
work/db/266bdfa969a01273b775d7009038cd/comm.txt
work/ae/0348bb16b2e3601309c5e31807ce64/comm.txt
work/71/cea31bd3ef3d30ef8871fdc8af63e3/comm.txt
```


