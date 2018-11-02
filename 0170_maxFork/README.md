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
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [pedantic_archimedes] - revision: a352490a63
[warm up] executor > local
[bb/bee1c1] Submitted process > sortAcns (sorting list4.acns.txt)
[e4/c6ef75] Submitted process > sortAcns (sorting list3.acns.txt)
[32/1c33be] Submitted process > sortAcns (sorting list1.acns.txt)
[f6/6c0ad8] Submitted process > sortAcns (sorting list2.acns.txt)
[6b/f717ef] Submitted process > commonAcns (comm list3.acns.txt vs list4.acns.txt)
[6a/cfbff1] Submitted process > commonAcns (comm list1.acns.txt vs list3.acns.txt)
[e1/9ca7d4] Submitted process > commonAcns (comm list1.acns.txt vs list4.acns.txt)
[d7/377221] Submitted process > commonAcns (comm list2.acns.txt vs list3.acns.txt)
[3a/2af224] Submitted process > commonAcns (comm list2.acns.txt vs list4.acns.txt)
[04/0113ba] Submitted process > commonAcns (comm list1.acns.txt vs list2.acns.txt)
[dc/f7daa9] Submitted process > listCommons (common list size: 6)
[90/18fc9f] Submitted process > eachAcn (dowloading AF002815.1)
[1c/9975f1] Submitted process > eachAcn (dowloading AF002816.1)
[2b/cbe739] Submitted process > eachAcn (dowloading AF004836.1)
[cb/efe20b] Submitted process > eachAcn (dowloading AF188126.1)
[4e/8bd0c8] Submitted process > eachAcn (dowloading AF188530.1)
[c2/b190b0] Submitted process > eachAcn (dowloading AX244961.1)
[23/65b9d2] Submitted process > eachAcn (dowloading AX244962.1)
[4f/c15874] Submitted process > eachAcn (dowloading AX244963.1)
[da/5b918d] Submitted process > eachAcn (dowloading AX244964.1)
[ac/97ce40] Submitted process > eachAcn (dowloading AX244965.1)
[65/2ed321] Submitted process > eachAcn (dowloading AX244966.1)
[66/40afee] Submitted process > eachAcn (dowloading AX244967.1)
[d8/1676f9] Submitted process > eachAcn (dowloading AX244968.1)
[4e/87c5a8] Submitted process > eachAcn (dowloading AY116592.1)
[5d/77f0f8] Submitted process > eachAcn (dowloading NM_017590.5)
```


## Files

```
work/23/65b9d20a88e3b90196add48a337f92/AX244962.1.fa
work/1c/9975f1c130e76113232b027c73c22f/AF002816.1.fa
work/cb/efe20bd546ddbe2a04b9ab2022a6a3/AF188126.1.fa
work/6b/f717eff74b2c3cfa73ca675d32547b/comm.txt
work/d8/1676f9663a2bd3515cad5f0a6fbc80/AX244968.1.fa
work/d7/377221052290cba68bd399cadf2c87/comm.txt
work/6a/cfbff1406a9a835fed1360070f5b3a/comm.txt
work/32/1c33befcb6144079564f299105b328/list1.acns.txt.sorted.txt
work/32/1c33befcb6144079564f299105b328/list1.acns.txt
work/e4/c6ef75fc19f0329a672fe4480a34e4/list3.acns.txt
work/e4/c6ef75fc19f0329a672fe4480a34e4/list3.acns.txt.sorted.txt
work/65/2ed321fee98aeef0994722c3e8b01b/AX244966.1.fa
work/bb/bee1c19a66c5aa30450b2118fb3da4/list4.acns.txt.sorted.txt
work/bb/bee1c19a66c5aa30450b2118fb3da4/list4.acns.txt
work/c2/b190b0f6380fc8d0270027c2b5d4d0/AX244961.1.fa
work/4e/87c5a8480e53f2689b62abe3d036f5/AY116592.1.fa
work/4e/8bd0c814750526b94bfa2bca3e820e/AF188530.1.fa
work/5d/77f0f807d763dc9e59fec385c7a03e/NM_017590.5.fa
work/dc/f7daa9ec0d09fbe5307d9f1b3bd46c/table.csv
work/dc/f7daa9ec0d09fbe5307d9f1b3bd46c/distcint.acns.txt
work/ac/97ce4037faf6a2e33fb962f05529ce/AX244965.1.fa
work/2b/cbe73957a1e332b93978bba130a09a/AF004836.1.fa
work/da/5b918d9e840164895f9eed3754229d/AX244964.1.fa
work/e1/9ca7d49babe7e91a02dcd4627bbff5/comm.txt
work/3a/2af224d6b7a449323f657f2f35d381/comm.txt
work/90/18fc9fc3b847ca8b238a56cd2fe213/AF002815.1.fa
work/04/0113ba61de9de10e3e75fffc4327bc/comm.txt
work/66/40afee90bd120cd1a8dd00c4527b24/AX244967.1.fa
work/f6/6c0ad8630d9e4e13fb854a969f8ed1/list2.acns.txt.sorted.txt
work/f6/6c0ad8630d9e4e13fb854a969f8ed1/list2.acns.txt
work/4f/c158747377e87f75dc127be0efd05d/AX244963.1.fa
```


