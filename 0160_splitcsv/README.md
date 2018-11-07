## Synopsis

The `splitCsv` operator allows you to parse text items emitted by a channel, that are formatted using the CSV format, and split them into records or group them into list of records with a specified length.

## nextflow

### ./workflow.nf

```groovy
  1   acn_file_channel = Channel.fromPath( "${params.acns}")
  2   
  3   process sortAcns {
  4   	tag "sorting ${acnFile}"
  5   	input:
  6   		file acnFile from acn_file_channel
  7   	output:
  8   		set acnFile, file("${acnFile}.sorted.txt") into (acn_sorted1,acn_sorted2)
  9   	script:
 10   	
 11   	"""
 12   	sort '${acnFile}' > "${acnFile}.sorted.txt"
 13   	"""
 14   }
 15   
 16   process commonAcns {
 17   	tag "comm ${label}"
 18   	input:
 19   		set label,sorted1,sorted2 from acn_sorted1.
 20                                             combine(acn_sorted2).
 21                                             filter{ROW->ROW[0].getName().compareTo(ROW[2].getName())<0}.
 22   					  map{ROW->[ ROW[0].getName() + " vs " + ROW[2].getName() , ROW[1] , ROW[3] ] }
 23   	output:
 24   		set label,file("comm.txt") into commons
 25   	script:
 26   	"""
 27   	comm -12 "${sorted1}" "${sorted2}" > comm.txt
 28   	"""
 29   }
 30   
 31   process listCommons {
 32   	tag "common list size: ${array_of_rows.size()}"
 33   	input:
 34   		val array_of_rows from commons.map{ROW->ROW[0]+","+ROW[1]}.collect()
 35   	output:
 36   		file("table.csv")
 37   		file("distinct.acns.txt") into distinct_acns
 38   	script:
 39   	"""
 40   	echo '${array_of_rows.join("\n")}' > table.csv
 41   	cut -d ',' -f2 table.csv | while read F
 42   	do
 43   		cat \$F
 44   	done | sort | uniq > distinct.acns.txt
 45   	"""
 46   
 47   }
 48   
 49   process each {
 50   	tag "processing ${acn}"
 51   	input:	
 52   		val acn from distinct_acns.splitCsv(sep:',',strip:true).map{ARRAY->ARRAY[0]}
 53   	script:
 54   	"""
 55   	echo "${acn}"
 56   	"""
 57   	}
```


## Execute

```
../bin/nextflow run  workflow.nf --acns '../data/list*.acns.txt'
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [special_church] - revision: 405ebec4f4
[warm up] executor > local
[35/12a4cd] Submitted process > sortAcns (sorting list3.acns.txt)
[d5/8b8eae] Submitted process > sortAcns (sorting list4.acns.txt)
[95/6fd429] Submitted process > sortAcns (sorting list2.acns.txt)
[39/9e2b7c] Submitted process > sortAcns (sorting list1.acns.txt)
[dc/dccb98] Submitted process > commonAcns (comm list2.acns.txt vs list4.acns.txt)
[34/4150e7] Submitted process > commonAcns (comm list2.acns.txt vs list3.acns.txt)
[c0/14ba2f] Submitted process > commonAcns (comm list3.acns.txt vs list4.acns.txt)
[20/924cc8] Submitted process > commonAcns (comm list1.acns.txt vs list3.acns.txt)
[6b/a7425b] Submitted process > commonAcns (comm list1.acns.txt vs list2.acns.txt)
[61/84aa0b] Submitted process > commonAcns (comm list1.acns.txt vs list4.acns.txt)
[ac/4f3c36] Submitted process > listCommons (common list size: 6)
[d6/053dcd] Submitted process > each (processing AF002815.1)
[e9/fc40da] Submitted process > each (processing AF002816.1)
[59/042bcd] Submitted process > each (processing AF004836.1)
[bd/feff23] Submitted process > each (processing AF188126.1)
[8b/56dd3f] Submitted process > each (processing AX244961.1)
[17/6bbf86] Submitted process > each (processing AX244962.1)
[f6/73b410] Submitted process > each (processing AF188530.1)
[a9/04a3ae] Submitted process > each (processing AX244964.1)
[f9/d473e3] Submitted process > each (processing AX244965.1)
[bf/ee9a8c] Submitted process > each (processing AX244963.1)
[e6/503e8b] Submitted process > each (processing AX244966.1)
[4a/a79332] Submitted process > each (processing AX244968.1)
[d4/4d70f3] Submitted process > each (processing AX244967.1)
[87/a027e2] Submitted process > each (processing NM_017590.5)
[7f/c6976a] Submitted process > each (processing AY116592.1)
```


## Files

```
work/6b/a7425bb4dd8758802774af571e4894/comm.txt
work/39/9e2b7c34ce9b5244ca8c4139372f89/list1.acns.txt.sorted.txt
work/39/9e2b7c34ce9b5244ca8c4139372f89/list1.acns.txt
work/95/6fd429f23a39ea6e88883b5fdd830e/list2.acns.txt.sorted.txt
work/95/6fd429f23a39ea6e88883b5fdd830e/list2.acns.txt
work/c0/14ba2f3a4a744ba7968d50fb086368/comm.txt
work/61/84aa0bba56254c7be46b7c738f0e13/comm.txt
work/dc/dccb9891ee96be3185abe2a7d35eab/comm.txt
work/ac/4f3c36823d1eeaa50f0082ce2fc9f5/distinct.acns.txt
work/ac/4f3c36823d1eeaa50f0082ce2fc9f5/table.csv
work/d5/8b8eae4dc9276acca3cf82827bd91f/list4.acns.txt.sorted.txt
work/d5/8b8eae4dc9276acca3cf82827bd91f/list4.acns.txt
work/35/12a4cd47eda9d9da53bbea16f96ba5/list3.acns.txt
work/35/12a4cd47eda9d9da53bbea16f96ba5/list3.acns.txt.sorted.txt
work/20/924cc82a7e6e0c36da36b5f09825c7/comm.txt
work/34/4150e7bb7153e15df3f1e91d1824e5/comm.txt
```


