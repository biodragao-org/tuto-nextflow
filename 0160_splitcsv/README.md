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
Launching `workflow.nf` [astonishing_curie] - revision: 405ebec4f4
[warm up] executor > local
[2c/fba3cb] Submitted process > sortAcns (sorting list3.acns.txt)
[21/8dc031] Submitted process > sortAcns (sorting list2.acns.txt)
[d6/64cc29] Submitted process > sortAcns (sorting list4.acns.txt)
[9b/cba690] Submitted process > sortAcns (sorting list1.acns.txt)
[29/823682] Submitted process > commonAcns (comm list2.acns.txt vs list3.acns.txt)
[e3/c5d35b] Submitted process > commonAcns (comm list3.acns.txt vs list4.acns.txt)
[88/4a2db0] Submitted process > commonAcns (comm list2.acns.txt vs list4.acns.txt)
[24/62e2b8] Submitted process > commonAcns (comm list1.acns.txt vs list3.acns.txt)
[2b/51296f] Submitted process > commonAcns (comm list1.acns.txt vs list4.acns.txt)
[01/8e450e] Submitted process > commonAcns (comm list1.acns.txt vs list2.acns.txt)
[6d/c566ec] Submitted process > listCommons (common list size: 6)
[3a/6e9cc3] Submitted process > each (processing AF002815.1)
[e3/8a0b1d] Submitted process > each (processing AF002816.1)
[86/0c5f4e] Submitted process > each (processing AF004836.1)
[6d/f9ff62] Submitted process > each (processing AF188126.1)
[5b/554fcb] Submitted process > each (processing AF188530.1)
[37/c6d264] Submitted process > each (processing AX244961.1)
[5b/0b6d90] Submitted process > each (processing AX244962.1)
[99/35378e] Submitted process > each (processing AX244963.1)
[c1/bfdd01] Submitted process > each (processing AX244964.1)
[6e/bb3ce6] Submitted process > each (processing AX244966.1)
[4f/4a3346] Submitted process > each (processing AX244967.1)
[25/a5b957] Submitted process > each (processing AX244968.1)
[6e/a07355] Submitted process > each (processing AX244965.1)
[5d/eb6639] Submitted process > each (processing NM_017590.5)
[e9/84449c] Submitted process > each (processing AY116592.1)
```


## Files

```
work/6d/c566ec5d3ad787fb8673e8effb361e/distinct.acns.txt
work/6d/c566ec5d3ad787fb8673e8effb361e/table.csv
work/21/8dc03103decb29ae9d02894b33063a/list2.acns.txt.sorted.txt
work/21/8dc03103decb29ae9d02894b33063a/list2.acns.txt
work/88/4a2db0804b909e2296300bacac6241/comm.txt
work/29/823682bc6b312ae66b8167d107ce38/comm.txt
work/2b/51296f23ee1ece2467d833e89721f3/comm.txt
work/9b/cba690e875a4fc1332903d083d9205/list1.acns.txt.sorted.txt
work/9b/cba690e875a4fc1332903d083d9205/list1.acns.txt
work/e3/c5d35b7d438a1ce1949b483eef94bc/comm.txt
work/d6/64cc29ba8b4a19179dd53d0a13f65e/list4.acns.txt.sorted.txt
work/d6/64cc29ba8b4a19179dd53d0a13f65e/list4.acns.txt
work/2c/fba3cbe93a25167167a0f8fa95464f/list3.acns.txt
work/2c/fba3cbe93a25167167a0f8fa95464f/list3.acns.txt.sorted.txt
work/24/62e2b86f21b282d0859e7fb1bd677f/comm.txt
work/01/8e450eaa0565c761e5e41b993fd682/comm.txt
```


