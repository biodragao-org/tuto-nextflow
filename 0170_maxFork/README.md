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
Launching `workflow.nf` [evil_pare] - revision: a352490a63
[warm up] executor > local
[47/e8b04c] Submitted process > sortAcns (sorting list3.acns.txt)
[8a/62b980] Submitted process > sortAcns (sorting list4.acns.txt)
[d4/5cf791] Submitted process > sortAcns (sorting list2.acns.txt)
[50/3ecc21] Submitted process > sortAcns (sorting list1.acns.txt)
[7a/c3a510] Submitted process > commonAcns (comm list3.acns.txt vs list4.acns.txt)
[10/638c78] Submitted process > commonAcns (comm list2.acns.txt vs list4.acns.txt)
[78/8e37bc] Submitted process > commonAcns (comm list2.acns.txt vs list3.acns.txt)
[0d/674499] Submitted process > commonAcns (comm list1.acns.txt vs list2.acns.txt)
[87/307f6c] Submitted process > commonAcns (comm list1.acns.txt vs list3.acns.txt)
[8c/90b1fc] Submitted process > commonAcns (comm list1.acns.txt vs list4.acns.txt)
[7d/b8a0d6] Submitted process > listCommons (common list size: 6)
[bf/1385b7] Submitted process > eachAcn (dowloading AF002815.1)
[d0/a7e4c0] Submitted process > eachAcn (dowloading AF002816.1)
[31/398237] Submitted process > eachAcn (dowloading AF004836.1)
[9f/5ee909] Submitted process > eachAcn (dowloading AF188126.1)
[89/9a6072] Submitted process > eachAcn (dowloading AF188530.1)
[4c/70bd98] Submitted process > eachAcn (dowloading AX244961.1)
[6e/fa932f] Submitted process > eachAcn (dowloading AX244962.1)
[f7/0972ff] Submitted process > eachAcn (dowloading AX244963.1)
[7c/34dfb2] Submitted process > eachAcn (dowloading AX244964.1)
[6e/c3c89b] Submitted process > eachAcn (dowloading AX244965.1)
[3f/203785] Submitted process > eachAcn (dowloading AX244966.1)
[28/77f2b0] Submitted process > eachAcn (dowloading AX244967.1)
[6c/9fa5cb] Submitted process > eachAcn (dowloading AX244968.1)
[8f/4342f9] Submitted process > eachAcn (dowloading AY116592.1)
[cd/540faf] Submitted process > eachAcn (dowloading NM_017590.5)
```


## Files

```
work/d4/5cf791eca81bd9bd2fb1d7b45e4324/list2.acns.txt
work/d4/5cf791eca81bd9bd2fb1d7b45e4324/list2.acns.txt.sorted.txt
work/50/3ecc21b922a72513440020bae4932c/list1.acns.txt
work/50/3ecc21b922a72513440020bae4932c/list1.acns.txt.sorted.txt
work/47/e8b04ce96152f297a2effaa6f7f86b/list3.acns.txt
work/47/e8b04ce96152f297a2effaa6f7f86b/list3.acns.txt.sorted.txt
work/8a/62b980cb2963033993fad1db4a5a81/list4.acns.txt
work/8a/62b980cb2963033993fad1db4a5a81/list4.acns.txt.sorted.txt
work/7a/c3a510a4696a5069339fda69d7ee51/comm.txt
work/10/638c789c27e14bfbfa925fc90d5a1b/comm.txt
work/78/8e37bc260ea65d0d4bf63fd88e14e5/comm.txt
work/0d/6744993b1194a9e96dcc6324ed2885/comm.txt
work/87/307f6c1f2cdcfc59333fee1197de7c/comm.txt
work/8c/90b1fc4607295c32f9e072a2e3e4fd/comm.txt
work/7d/b8a0d6b1e1aaa9be0f4ac96ec046aa/table.csv
work/7d/b8a0d6b1e1aaa9be0f4ac96ec046aa/distcint.acns.txt
work/bf/1385b7cfeb4f94b210dd940f4432c0/AF002815.1.fa
work/d0/a7e4c0fc6b56a84797116e95bd6b9c/AF002816.1.fa
work/31/398237211e9eaa92dd279b1e29db4a/AF004836.1.fa
work/9f/5ee909bd7e53e628c33f9bce7601c6/AF188126.1.fa
work/89/9a6072efe729eecda0006ef89addd9/AF188530.1.fa
work/4c/70bd98fe73e5f73eb04b87ea9a76df/AX244961.1.fa
work/6e/fa932f431d589a40660b66f8d01bc2/AX244962.1.fa
work/6e/c3c89b7975d4a690a1fa1e56618d9c/AX244965.1.fa
work/f7/0972ff2778883c294f3b85a3a8162e/AX244963.1.fa
work/7c/34dfb266b238099ba7f7891c5f72c7/AX244964.1.fa
work/3f/203785c693cc2bd30134ed8be0bed9/AX244966.1.fa
work/28/77f2b0877384320b8d6be73381b345/AX244967.1.fa
work/6c/9fa5cb0ab7f3c75f4da31e174d4805/AX244968.1.fa
work/8f/4342f902a881b724a930a233c1075a/AY116592.1.fa
work/cd/540faf6c1573b98911bf4f79225b91/NM_017590.5.fa
```


