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
../bin/nextflow run workflow.nf --acns '../data/list*.acns.txt'
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [jovial_mcclintock] - revision: a352490a63
[warm up] executor > local
[c5/024ec2] Submitted process > sortAcns (sorting list4.acns.txt)
[96/e4e6d2] Submitted process > sortAcns (sorting list3.acns.txt)
[63/051eae] Submitted process > sortAcns (sorting list1.acns.txt)
[51/32199c] Submitted process > sortAcns (sorting list2.acns.txt)
[7b/c068b8] Submitted process > commonAcns (comm list1.acns.txt vs list4.acns.txt)
[d5/c15cac] Submitted process > commonAcns (comm list1.acns.txt vs list3.acns.txt)
[47/71d7f9] Submitted process > commonAcns (comm list3.acns.txt vs list4.acns.txt)
[70/48d56b] Submitted process > commonAcns (comm list2.acns.txt vs list4.acns.txt)
[8d/a0a797] Submitted process > commonAcns (comm list2.acns.txt vs list3.acns.txt)
[21/a8ec35] Submitted process > commonAcns (comm list1.acns.txt vs list2.acns.txt)
[c4/8cabde] Submitted process > listCommons (common list size: 6)
[0a/4727bf] Submitted process > eachAcn (dowloading AF002815.1)
[dc/5556a0] Submitted process > eachAcn (dowloading AF002816.1)
[6e/d37e29] Submitted process > eachAcn (dowloading AF004836.1)
[c6/a68865] Submitted process > eachAcn (dowloading AF188126.1)
[39/60fc41] Submitted process > eachAcn (dowloading AF188530.1)
[72/70b619] Submitted process > eachAcn (dowloading AX244961.1)
[3d/ce8441] Submitted process > eachAcn (dowloading AX244962.1)
[29/c05030] Submitted process > eachAcn (dowloading AX244963.1)
[6c/5f03bf] Submitted process > eachAcn (dowloading AX244964.1)
[54/54984f] Submitted process > eachAcn (dowloading AX244965.1)
[14/d2f30d] Submitted process > eachAcn (dowloading AX244966.1)
[1f/d3d4bf] Submitted process > eachAcn (dowloading AX244967.1)
[c1/fe63fd] Submitted process > eachAcn (dowloading AX244968.1)
[bf/d90811] Submitted process > eachAcn (dowloading AY116592.1)
[7a/76171c] Submitted process > eachAcn (dowloading NM_017590.5)
```


## Files

```
work/29/c05030c24f532bd9b3c038a013741f/AX244963.1.fa
work/47/71d7f9d59900b625d3ec920ae8384f/comm.txt
work/f2/abd40d8a27ced1f678739641886e54/NM_017590.5.fa
work/d9/eab4a009aeb52a9ff421baf35a797a/comm.txt
work/54/54984fe09ba710b3389882e9c21e06/AX244965.1.fa
work/ee/73478c80a798a7f76ba405b7466079/AX244967.1.fa
work/0a/4727bfac99825cb685f0c0c4564233/AF002815.1.fa
work/eb/00a7b02a1d07297d6de2b39b7c2180/comm.txt
work/71/ab13d8d329d713de11002bebdb3653/comm.txt
work/08/275736e7339e1a0678c75c701a4418/comm.txt
work/14/d2f30d19f20b4f045aab7e001c9738/AX244966.1.fa
work/c5/024ec24bc0d0e90f0930f58d415ce8/list4.acns.txt
work/c5/024ec24bc0d0e90f0930f58d415ce8/list4.acns.txt.sorted.txt
work/db/513b181b3d6be0da7589c30f9a9e36/AF004836.1.fa
work/39/60fc419c7d09859d0b7842e2fe86ee/AF188530.1.fa
work/dc/5556a04a7f24832af2b877299db66b/AF002816.1.fa
work/6c/5f03bf36ae37fb20754be25ec79b34/AX244964.1.fa
work/20/ab7f196d47be9e104bd7339dfdb3bc/comm.txt
work/0c/61f0abc56102191dce961e44d44bc4/list1.acns.txt
work/0c/61f0abc56102191dce961e44d44bc4/list1.acns.txt.sorted.txt
work/c1/fe63fd2c9358448af23a553f9bf9ee/AX244968.1.fa
work/bf/d908114f3c4bbcecf29e823105b8f1/AY116592.1.fa
work/3d/ce8441f9e79359dd9bdc8d070219b6/AX244962.1.fa
work/63/051eae317934d5efe3e35fc9f4c8a2/list1.acns.txt
work/63/051eae317934d5efe3e35fc9f4c8a2/list1.acns.txt.sorted.txt
work/63/0410db09f6b81181028d9db20527f4/AF002815.1.fa
work/6e/d37e295bc4773e71ae70651d81ce33/AF004836.1.fa
work/21/a8ec35f7aba09882b87026ce9bc307/comm.txt
work/7a/76171c129939e7f2d474ec6c4a4359/NM_017590.5.fa
work/d5/c15caca9207a5f6f5ef486c7e280a9/comm.txt
work/35/a2a980f76b84849bed607cdc51b060/AX244964.1.fa
work/f6/aefcb98dcb77096c93d6d64f11191e/AF002816.1.fa
work/fb/54eb53a63abdfdd4dc50baf0faf8af/AX244961.1.fa
work/19/0807eb5eccc1dffd0833aadc4be702/list3.acns.txt
work/19/0807eb5eccc1dffd0833aadc4be702/list3.acns.txt.sorted.txt
work/19/73590b9c005ccf66461f0cf8338dcb/AX244968.1.fa
work/c4/8cabde8a982490426607fc0cb56fa2/table.csv
work/c4/8cabde8a982490426607fc0cb56fa2/distcint.acns.txt
work/a2/f70ed3d7a7993753a353d9e85dbcb2/AX244962.1.fa
work/17/05d999e519a8ef24922de9acfcf9a2/AF188126.1.fa
work/8d/a0a797d750dcf2815140cac9899135/comm.txt
work/82/ba725fa2474fea6d0c787e0e19ba3c/AX244965.1.fa
work/72/70b619800b5be543ad1a5b7458413c/AX244961.1.fa
work/62/2ec4d0e64bbc4bf616f7e58121bbda/AX244963.1.fa
work/3f/44a46231c6f8e5f97e601b4107d663/table.csv
work/3f/44a46231c6f8e5f97e601b4107d663/distcint.acns.txt
work/3f/de642f5ae089dc4a89a950ae916929/comm.txt
work/7b/c068b8e7a705a1d713b4f3e8003343/comm.txt
work/af/1f2d876742345663d7ebe5b8c8a2ab/list2.acns.txt.sorted.txt
work/af/1f2d876742345663d7ebe5b8c8a2ab/list2.acns.txt
work/96/e4e6d2efaf32496721c29284e982f7/list3.acns.txt
work/96/e4e6d2efaf32496721c29284e982f7/list3.acns.txt.sorted.txt
work/1f/d3d4bf2cefabcb6115dd579cd6e940/AX244967.1.fa
work/aa/1daee6c9ac558e15eb686fed6186ca/AX244966.1.fa
work/8f/3757400e225f266b7cedd9f74d4a35/list4.acns.txt
work/8f/3757400e225f266b7cedd9f74d4a35/list4.acns.txt.sorted.txt
work/c6/a68865ebd68acc2201da4249a62e7e/AF188126.1.fa
work/51/32199c3dec6e095c2979bc9d338c2a/list2.acns.txt.sorted.txt
work/51/32199c3dec6e095c2979bc9d338c2a/list2.acns.txt
work/70/48d56b5802f348ccc60b816b7a8299/comm.txt
work/05/5153cc70de6e4568b219bded455a6f/AF188530.1.fa
work/02/3c4de90fc84eb652c0c5081eaaedce/AY116592.1.fa
```


