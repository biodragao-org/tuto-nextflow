## Synopsis

> The maxForks directive allows you to define the maximum number of process instances that can be executed in parallel.

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
 49   // https://www.nextflow.io/docs/latest/process.html?highlight=maxfork#maxforks
 50   process eachAcn {
 51   	tag "dowloading ${acn}"
 52   	maxForks 1
 53   	input:	
 54   		val acn from distinct_acns.splitCsv(sep:',',strip:true).map{ARRAY->ARRAY[0]}
 55   	output:
 56   		file("${acn}.fa")
 57   	script:
 58   	"""
 59    	curl -o "${acn}.fa" -f -L  "https://www.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nucleotide&id=${acn}&rettype=fasta" 
 60   	"""
 61   	}
 62   
```


## Execute

```
../bin/nextflow run  workflow.nf --acns '../data/list*.acns.txt'
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [agitated_bardeen] - revision: a81a1517ab
[warm up] executor > local
[3a/2ff5e6] Submitted process > sortAcns (sorting list4.acns.txt)
[9a/81642b] Submitted process > sortAcns (sorting list2.acns.txt)
[4b/4876f0] Submitted process > sortAcns (sorting list3.acns.txt)
[a6/976541] Submitted process > sortAcns (sorting list1.acns.txt)
[f3/38cd71] Submitted process > commonAcns (comm list3.acns.txt vs list4.acns.txt)
[94/672735] Submitted process > commonAcns (comm list2.acns.txt vs list3.acns.txt)
[24/1964cc] Submitted process > commonAcns (comm list2.acns.txt vs list4.acns.txt)
[db/e7f367] Submitted process > commonAcns (comm list1.acns.txt vs list4.acns.txt)
[32/d022d3] Submitted process > commonAcns (comm list1.acns.txt vs list2.acns.txt)
[16/ed312a] Submitted process > commonAcns (comm list1.acns.txt vs list3.acns.txt)
[0a/b71cbd] Submitted process > listCommons (common list size: 6)
[4b/402354] Submitted process > eachAcn (dowloading AF002815.1)
[93/96ed60] Submitted process > eachAcn (dowloading AF002816.1)
[6d/269dc3] Submitted process > eachAcn (dowloading AF004836.1)
[95/657ea0] Submitted process > eachAcn (dowloading AF188126.1)
[01/2edb38] Submitted process > eachAcn (dowloading AF188530.1)
[b5/aaf634] Submitted process > eachAcn (dowloading AX244961.1)
[7a/0f87a8] Submitted process > eachAcn (dowloading AX244962.1)
[6d/a7d1cc] Submitted process > eachAcn (dowloading AX244963.1)
[6c/757ba2] Submitted process > eachAcn (dowloading AX244964.1)
[30/2c1a0a] Submitted process > eachAcn (dowloading AX244965.1)
[3e/99fc63] Submitted process > eachAcn (dowloading AX244966.1)
[2e/7b4431] Submitted process > eachAcn (dowloading AX244967.1)
[64/37703c] Submitted process > eachAcn (dowloading AX244968.1)
[85/9f582b] Submitted process > eachAcn (dowloading AY116592.1)
[88/2805bd] Submitted process > eachAcn (dowloading NM_017590.5)
```


## Files

```
work/9a/81642bd23eb6fbf4fd35a5a6245ad8/list2.acns.txt.sorted.txt
work/9a/81642bd23eb6fbf4fd35a5a6245ad8/list2.acns.txt
work/6d/269dc3724f1155f2cf027c1d9faeb0/AF004836.1.fa
work/6d/a7d1cc4b4aaa018017a396e812159f/AX244963.1.fa
work/f3/38cd718cce5f7c7c437673b8c3802b/comm.txt
work/93/96ed60dd49e9d3e4b70ecaa4478996/AF002816.1.fa
work/0a/b71cbde3979eb065589cd175165747/distinct.acns.txt
work/0a/b71cbde3979eb065589cd175165747/table.csv
work/32/d022d3747988ae13d77fac3d2ccf20/comm.txt
work/b5/aaf63421c0b973d4813c72796518fc/AX244961.1.fa
work/95/657ea093dc3df50129899cf8dba903/AF188126.1.fa
work/88/2805bdb57986bb75075ae09c6cbe4a/NM_017590.5.fa
work/4b/4023544e0eb7ade59ca5cd30a519d7/AF002815.1.fa
work/4b/4876f06039294af7d0e8c8c9ae1fa3/list3.acns.txt
work/4b/4876f06039294af7d0e8c8c9ae1fa3/list3.acns.txt.sorted.txt
work/16/ed312a5b7416c259348c4aee20075f/comm.txt
work/7a/0f87a80e399bf408cd68905ab1a838/AX244962.1.fa
work/3e/99fc636701b4704e9db1e9ec715a83/AX244966.1.fa
work/a6/976541f6875448560109ee9199d4cb/list1.acns.txt.sorted.txt
work/a6/976541f6875448560109ee9199d4cb/list1.acns.txt
work/2e/7b44314788c3620f6075c190064367/AX244967.1.fa
work/64/37703c1db86ab5738fedcef3d9bab7/AX244968.1.fa
work/3a/2ff5e6e698386e980e3950c668826b/list4.acns.txt.sorted.txt
work/3a/2ff5e6e698386e980e3950c668826b/list4.acns.txt
work/85/9f582bfd064c12c44db059618a1ef0/AY116592.1.fa
work/6c/757ba2e8649fc3a12cbf435be73d5e/AX244964.1.fa
work/db/e7f36785a8b606f9ae31bc8ebdc43c/comm.txt
work/30/2c1a0a1f03f862870ba2ff5f459f01/AX244965.1.fa
work/24/1964cc915e939b0f97dd3ca9ebae99/comm.txt
work/01/2edb38e18aff64279d549b84b9609e/AF188530.1.fa
work/94/6727359b6f44a1c816d4fd612c669e/comm.txt
```


