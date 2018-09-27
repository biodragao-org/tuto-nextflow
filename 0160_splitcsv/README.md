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
../bin/nextflow run workflow.nf --acns '../data/list*.acns.txt'
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [mighty_stone] - revision: 111c7d7269
[warm up] executor > local
[06/212780] Submitted process > sortAcns (sorting list4.acns.txt)
[47/10acbe] Submitted process > sortAcns (sorting list1.acns.txt)
[0c/e5d13b] Submitted process > sortAcns (sorting list2.acns.txt)
[d7/01ed0b] Submitted process > sortAcns (sorting list3.acns.txt)
[44/97c706] Submitted process > commonAcns (comm list1.acns.txt vs list2.acns.txt)
[de/95362a] Submitted process > commonAcns (comm list3.acns.txt vs list4.acns.txt)
[a5/cc791f] Submitted process > commonAcns (comm list2.acns.txt vs list4.acns.txt)
[d3/6d6cae] Submitted process > commonAcns (comm list1.acns.txt vs list4.acns.txt)
[46/2ac452] Submitted process > commonAcns (comm list2.acns.txt vs list3.acns.txt)
[75/5f93bf] Submitted process > commonAcns (comm list1.acns.txt vs list3.acns.txt)
[35/da0e80] Submitted process > listCommons (common list size: 6)
[e7/2e9eb5] Submitted process > each (processing AF004836.1)
[cf/9ab0b6] Submitted process > each (processing AF188126.1)
[75/7fe714] Submitted process > each (processing AF002816.1)
[2d/249d87] Submitted process > each (processing AF002815.1)
[57/f6da1f] Submitted process > each (processing AX244962.1)
[ae/950a90] Submitted process > each (processing AF188530.1)
[b7/12509a] Submitted process > each (processing AX244963.1)
[23/1997c5] Submitted process > each (processing AX244966.1)
[fa/45cd26] Submitted process > each (processing AX244964.1)
[28/26fd47] Submitted process > each (processing AX244965.1)
[3c/ff758a] Submitted process > each (processing AX244961.1)
[84/293fd0] Submitted process > each (processing AX244967.1)
[6d/7a85be] Submitted process > each (processing AY116592.1)
[a9/944fa9] Submitted process > each (processing NM_017590.5)
[64/fc2ba1] Submitted process > each (processing AX244968.1)
```


## Files

```
work/47/10acbe1e5669a93bc4e5499caa2ad3/list1.acns.txt
work/47/10acbe1e5669a93bc4e5499caa2ad3/list1.acns.txt.sorted.txt
work/e8/1a268ab3f696f472a6ebcc2c601e0b/list3.acns.txt
work/e8/1a268ab3f696f472a6ebcc2c601e0b/list3.acns.txt.sorted.txt
work/b3/1f4859c91068db92ef319617ea6a09/comm.txt
work/a5/cc791f85e86a43a181cfde72aae714/comm.txt
work/ee/3561158e906837028ff000f3de1514/comm.txt
work/2a/c77e628fd23cadb2f23d30045db909/comm.txt
work/08/f4814a494866a10404125ac5ccf25c/list1.acns.txt
work/08/f4814a494866a10404125ac5ccf25c/list1.acns.txt.sorted.txt
work/14/9b13e06b2bbe46ca51fc1f3f54bfd5/list2.acns.txt.sorted.txt
work/14/9b13e06b2bbe46ca51fc1f3f54bfd5/list2.acns.txt
work/d3/6d6caefb930591b6dc99aeabbac1bf/comm.txt
work/0c/e5d13b19a8da80f49ca9c53bd4a791/list2.acns.txt.sorted.txt
work/0c/e5d13b19a8da80f49ca9c53bd4a791/list2.acns.txt
work/3d/771654ca6b32357a5a2f3a5dd57abf/comm.txt
work/46/2ac4528e5227f3e279b9bb0e1dbb53/comm.txt
work/7f/9bdf51acaa7674349006f1e26e64cf/list4.acns.txt
work/7f/9bdf51acaa7674349006f1e26e64cf/list4.acns.txt.sorted.txt
work/d7/01ed0bf40ec3d64149a21333ab8eb3/list3.acns.txt
work/d7/01ed0bf40ec3d64149a21333ab8eb3/list3.acns.txt.sorted.txt
work/de/95362ad27da738b3d14eac52920544/comm.txt
work/0e/bd1420b8f05d8d07b41c8fb433ad06/table.csv
work/0e/bd1420b8f05d8d07b41c8fb433ad06/distcint.acns.txt
work/35/da0e80da684c6532836a1c7c079f5d/table.csv
work/35/da0e80da684c6532836a1c7c079f5d/distcint.acns.txt
work/93/3433bb6df51612b254efb481974641/comm.txt
work/07/6c06f1fce46740574a22c90006c51b/comm.txt
work/44/97c70662d0ba774ce96ee35f8e58c7/comm.txt
work/75/5f93bf9950cc5064bbe18a70284d7d/comm.txt
work/06/21278055c8db4506234c7c3658a60c/list4.acns.txt
work/06/21278055c8db4506234c7c3658a60c/list4.acns.txt.sorted.txt
```


