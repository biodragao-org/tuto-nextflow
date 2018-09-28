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

// https://www.nextflow.io/docs/latest/process.html?highlight=maxfork#maxforks
process eachAcn {
	tag "dowloading ${acn}"
	maxForks 1
	input:	
		val acn from distinct_acns.splitCsv(sep:',',strip:true).map{ARRAY->ARRAY[0]}
	output:
		file("${acn}.fa")
	script:
	"""
	wget -O "${acn}.fa" "https://www.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nucleotide&id=${acn}&rettype=fasta"
	"""
	}
```


## Execute

```
../bin/nextflow run  workflow.nf --acns '../data/list*.acns.txt'
N E X T F L O W  ~  version 0.32.0
Launching `workflow.nf` [lonely_booth] - revision: a352490a63
[warm up] executor > local
[4b/1bb158] Submitted process > sortAcns (sorting list1.acns.txt)
[38/095c74] Submitted process > sortAcns (sorting list2.acns.txt)
[b4/1092e3] Submitted process > sortAcns (sorting list3.acns.txt)
[ed/7e43fe] Submitted process > sortAcns (sorting list4.acns.txt)
[85/6cf62d] Submitted process > commonAcns (comm list2.acns.txt vs list3.acns.txt)
[0f/de11a7] Submitted process > commonAcns (comm list1.acns.txt vs list2.acns.txt)
[d7/0c3f9a] Submitted process > commonAcns (comm list1.acns.txt vs list3.acns.txt)
[87/9c5767] Submitted process > commonAcns (comm list2.acns.txt vs list4.acns.txt)
[91/02808f] Submitted process > commonAcns (comm list1.acns.txt vs list4.acns.txt)
[b5/6b3f68] Submitted process > commonAcns (comm list3.acns.txt vs list4.acns.txt)
[36/47f30a] Submitted process > listCommons (common list size: 6)
[36/3921f3] Submitted process > eachAcn (dowloading AF002815.1)
[93/3f095b] Submitted process > eachAcn (dowloading AF002816.1)
[32/930ad2] Submitted process > eachAcn (dowloading AF004836.1)
[e6/aad45d] Submitted process > eachAcn (dowloading AF188126.1)
[04/65b961] Submitted process > eachAcn (dowloading AF188530.1)
[7a/95c7e7] Submitted process > eachAcn (dowloading AX244961.1)
[bf/7b50df] Submitted process > eachAcn (dowloading AX244962.1)
[e3/d50349] Submitted process > eachAcn (dowloading AX244963.1)
[d7/0ee7b9] Submitted process > eachAcn (dowloading AX244964.1)
[c9/75fec5] Submitted process > eachAcn (dowloading AX244965.1)
[3b/493c27] Submitted process > eachAcn (dowloading AX244966.1)
[2d/2ce484] Submitted process > eachAcn (dowloading AX244967.1)
[a6/12801d] Submitted process > eachAcn (dowloading AX244968.1)
[ed/cfd674] Submitted process > eachAcn (dowloading AY116592.1)
[55/87902f] Submitted process > eachAcn (dowloading NM_017590.5)
```


## Files

```
work/4b/1bb15897b5cf4ddc03d1e3dee07e7c/list1.acns.txt
work/4b/1bb15897b5cf4ddc03d1e3dee07e7c/list1.acns.txt.sorted.txt
work/38/095c749bfe16a37f6fe276aa35b09b/list2.acns.txt
work/38/095c749bfe16a37f6fe276aa35b09b/list2.acns.txt.sorted.txt
work/b4/1092e3df547f6885efaad9861f7ab6/list3.acns.txt
work/b4/1092e3df547f6885efaad9861f7ab6/list3.acns.txt.sorted.txt
work/ed/7e43fe3f39fd8d530d28f886d5daf3/list4.acns.txt
work/ed/7e43fe3f39fd8d530d28f886d5daf3/list4.acns.txt.sorted.txt
work/ed/cfd674c0dc96b2c261e7c8deaf53f5/AY116592.1.fa
work/85/6cf62dd29c4e052d37e116e08b0d28/comm.txt
work/0f/de11a786e05d04ebe1f127dec8bfbd/comm.txt
work/d7/0c3f9a7d95ee96430e80db8f52ad7c/comm.txt
work/d7/0ee7b962f4dc8ec08033b438e0da3f/AX244964.1.fa
work/87/9c57675100d530abd9cd00e52a3a21/comm.txt
work/b5/6b3f6843a794675265e940c11fa38d/comm.txt
work/91/02808f4caa8c8915a8b740fc2ba0d9/comm.txt
work/36/47f30a156a904eb33705bc09c01aa2/table.csv
work/36/47f30a156a904eb33705bc09c01aa2/distcint.acns.txt
work/36/3921f32a7bdd45d25cc4ba4d541b51/AF002815.1.fa
work/93/3f095bda1839aec4a34daea0197221/AF002816.1.fa
work/32/930ad20bd2d8b2d8f4ff19eacad9d1/AF004836.1.fa
work/e6/aad45dc9dcabe296407a23fd276aba/AF188126.1.fa
work/04/65b961d1272600f1bea88d3842baa6/AF188530.1.fa
work/7a/95c7e7c46c1d345cdfcce2621fa93d/AX244961.1.fa
work/bf/7b50dfb98cf918c8bb30fe414bdb6a/AX244962.1.fa
work/e3/d5034947833d729aba07f78f8081f9/AX244963.1.fa
work/c9/75fec52d8da3583055a6de4c4d9a14/AX244965.1.fa
work/3b/493c27d46d84ef1dc0c5249aa33be6/AX244966.1.fa
work/2d/2ce4844a66d223c59159c536656546/AX244967.1.fa
work/a6/12801d347cc389a42c2fb780f8568b/AX244968.1.fa
work/55/87902f3f7369d6d6cb19bd15217dbb/NM_017590.5.fa
```


