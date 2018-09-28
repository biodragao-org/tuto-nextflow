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
Launching `workflow.nf` [tender_wozniak] - revision: a352490a63
[warm up] executor > local
[03/2b7bb5] Submitted process > sortAcns (sorting list3.acns.txt)
[3a/8c6f5e] Submitted process > sortAcns (sorting list4.acns.txt)
[d7/82666d] Submitted process > sortAcns (sorting list1.acns.txt)
[8d/260424] Submitted process > sortAcns (sorting list2.acns.txt)
[03/4eeea1] Submitted process > commonAcns (comm list3.acns.txt vs list4.acns.txt)
[d8/bfd388] Submitted process > commonAcns (comm list1.acns.txt vs list3.acns.txt)
[09/fa6875] Submitted process > commonAcns (comm list1.acns.txt vs list4.acns.txt)
[58/14d626] Submitted process > commonAcns (comm list2.acns.txt vs list3.acns.txt)
[f7/994718] Submitted process > commonAcns (comm list2.acns.txt vs list4.acns.txt)
[03/40d614] Submitted process > commonAcns (comm list1.acns.txt vs list2.acns.txt)
[70/a2f650] Submitted process > listCommons (common list size: 6)
[a7/5a4e07] Submitted process > eachAcn (dowloading AF002815.1)
[49/bd01c9] Submitted process > eachAcn (dowloading AF002816.1)
[ef/42298e] Submitted process > eachAcn (dowloading AF004836.1)
[93/59583a] Submitted process > eachAcn (dowloading AF188126.1)
[ed/1f235d] Submitted process > eachAcn (dowloading AF188530.1)
[20/96f9b5] Submitted process > eachAcn (dowloading AX244961.1)
[20/f4ccf2] Submitted process > eachAcn (dowloading AX244962.1)
[01/868292] Submitted process > eachAcn (dowloading AX244963.1)
[a2/e1f99c] Submitted process > eachAcn (dowloading AX244964.1)
[79/1191ab] Submitted process > eachAcn (dowloading AX244965.1)
[c6/c2dc2e] Submitted process > eachAcn (dowloading AX244966.1)
[e4/1c3192] Submitted process > eachAcn (dowloading AX244967.1)
[2f/e3564b] Submitted process > eachAcn (dowloading AX244968.1)
[a6/45ed72] Submitted process > eachAcn (dowloading AY116592.1)
[2c/929215] Submitted process > eachAcn (dowloading NM_017590.5)
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
work/f7/9947182336ebb9c0059f64291b4fbe/comm.txt
work/7c/34dfb266b238099ba7f7891c5f72c7/AX244964.1.fa
work/3f/203785c693cc2bd30134ed8be0bed9/AX244966.1.fa
work/28/77f2b0877384320b8d6be73381b345/AX244967.1.fa
work/6c/9fa5cb0ab7f3c75f4da31e174d4805/AX244968.1.fa
work/8f/4342f902a881b724a930a233c1075a/AY116592.1.fa
work/cd/540faf6c1573b98911bf4f79225b91/NM_017590.5.fa
work/d7/82666ddfffe9a0dc00db2d9aa63174/list1.acns.txt
work/d7/82666ddfffe9a0dc00db2d9aa63174/list1.acns.txt.sorted.txt
work/3a/8c6f5ef32825e57d41ed110b23ddb0/list4.acns.txt
work/3a/8c6f5ef32825e57d41ed110b23ddb0/list4.acns.txt.sorted.txt
work/03/2b7bb596c6a63d4ddc5ec04e856485/list3.acns.txt
work/03/2b7bb596c6a63d4ddc5ec04e856485/list3.acns.txt.sorted.txt
work/03/4eeea10e0ef5fc1db0f5ceddbce38f/comm.txt
work/03/40d61471197592552be3be3b99555c/comm.txt
work/8d/2604249910e52f4824f9aaddd5e5a6/list2.acns.txt
work/8d/2604249910e52f4824f9aaddd5e5a6/list2.acns.txt.sorted.txt
work/d8/bfd3886b1d0bdacdb05cba2b7525e8/comm.txt
work/09/fa68752b7d029eb639fce635fec179/comm.txt
work/58/14d6261826ebfc705bd6aaffc3575e/comm.txt
work/70/a2f650230bd82a7fec99bdd45a9e4a/table.csv
work/70/a2f650230bd82a7fec99bdd45a9e4a/distcint.acns.txt
work/a7/5a4e073128eb014c4fff01fc68e6d2/AF002815.1.fa
work/49/bd01c9b268cb3959c99d24d810e07c/AF002816.1.fa
work/ef/42298e6cec8e419873a3fafa69db27/AF004836.1.fa
work/93/59583ac45b071480cc5bfa9ae4b355/AF188126.1.fa
work/ed/1f235ded6dbf6e2788064c978ba278/AF188530.1.fa
work/20/96f9b5267b13db36bc4e630800a133/AX244961.1.fa
work/20/f4ccf27ee3b8ac2a622794ab36491d/AX244962.1.fa
work/01/8682922917f431448bf26c03b2c809/AX244963.1.fa
work/a2/e1f99cd34bde66b4ca11b58962c836/AX244964.1.fa
work/79/1191ab4b5e369981ac572734c11219/AX244965.1.fa
work/c6/c2dc2e0f9439a65d3fd6f50490f452/AX244966.1.fa
work/e4/1c31928b03ea48185b22f42fdf7bbf/AX244967.1.fa
work/2f/e3564b5049a25f5a75b133e832f5e6/AX244968.1.fa
work/a6/45ed72afe094a86e9fae3fded19ee8/AY116592.1.fa
work/2c/92921511cfbf6d7949a1dac16ccee5/NM_017590.5.fa
```


