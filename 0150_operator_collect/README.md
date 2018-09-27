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
		file("distcint.acns.txt")
	script:
	"""
	echo '${array_of_rows.join("\n")}' > table.csv
	cut -d ',' -f2 table.csv | while read F
	do
		cat \$F
	done | sort | uniq > distcint.acns.txt
	"""

}
```


## Execute

```
../bin/nextflow run workflow.nf --acns '../data/list*.acns.txt'
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [scruffy_archimedes] - revision: 159f833755
[warm up] executor > local
[52/3409ef] Submitted process > sortAcns (sorting list2.acns.txt)
[d1/41dcaa] Submitted process > sortAcns (sorting list4.acns.txt)
[05/9fe345] Submitted process > sortAcns (sorting list3.acns.txt)
[6d/15e602] Submitted process > sortAcns (sorting list1.acns.txt)
[ec/1438d6] Submitted process > commonAcns (comm list2.acns.txt vs list3.acns.txt)
[2b/15a6f9] Submitted process > commonAcns (comm list1.acns.txt vs list3.acns.txt)
[c3/0fde88] Submitted process > commonAcns (comm list1.acns.txt vs list2.acns.txt)
[b3/f0edb2] Submitted process > commonAcns (comm list3.acns.txt vs list4.acns.txt)
[37/0569cf] Submitted process > commonAcns (comm list1.acns.txt vs list4.acns.txt)
[55/42ccc0] Submitted process > commonAcns (comm list2.acns.txt vs list4.acns.txt)
[44/343f12] Submitted process > listCommons (common list size: 6)
```


## Files

```
work/37/0569cfe4cc31c41396df6a60afdd97/comm.txt
work/00/5be17bb2f3a474f8b0f4c97f7a6ded/comm.txt
work/c3/0fde8828fdbd1d7670547ce7417843/comm.txt
work/b3/f0edb2e62f3c1b293764735a338e0e/comm.txt
work/bb/a128fe418042620bdcbc0e5e8d2a97/list2.acns.txt.sorted.txt
work/bb/a128fe418042620bdcbc0e5e8d2a97/list2.acns.txt
work/d1/41dcaaeb674e92eb60cc9cd75dde7e/list4.acns.txt
work/d1/41dcaaeb674e92eb60cc9cd75dde7e/list4.acns.txt.sorted.txt
work/14/0950616603859ab8eb464bb15c082f/list1.acns.txt
work/14/0950616603859ab8eb464bb15c082f/list1.acns.txt.sorted.txt
work/ec/1438d6544da440694e59aa0ab58be6/comm.txt
work/52/3409ef2f10c2b77d7ae613dd7b1fea/list2.acns.txt.sorted.txt
work/52/3409ef2f10c2b77d7ae613dd7b1fea/list2.acns.txt
work/78/1ab175a557a7393dc032b4be7aa7ea/comm.txt
work/87/5f21ac57316ec03dd34eb8f92153dc/comm.txt
work/6d/15e60299ccadb1b3b8fb56ac02d855/list1.acns.txt
work/6d/15e60299ccadb1b3b8fb56ac02d855/list1.acns.txt.sorted.txt
work/2b/15a6f95f553e40e75a5a9bf9979b48/comm.txt
work/ae/1aad46e76301868081446685aa2784/comm.txt
work/2e/9eb6d625937a25a3afc1067cc536d4/comm.txt
work/55/42ccc0ce77901e8314238bfddf8f0c/comm.txt
work/44/343f124cbbd5a9301530f33cc16bad/table.csv
work/44/343f124cbbd5a9301530f33cc16bad/distcint.acns.txt
work/8c/f412f1efcbb5e4a35dd6e07a2924bc/table.csv
work/8c/f412f1efcbb5e4a35dd6e07a2924bc/distcint.acns.txt
work/5b/497bd381a307bcbd56c40b6be2ace4/comm.txt
work/94/93123c7a4737639effce709e88bbd6/list3.acns.txt
work/94/93123c7a4737639effce709e88bbd6/list3.acns.txt.sorted.txt
work/05/9fe345b5810708b1a6bb5985f8d78c/list3.acns.txt
work/05/9fe345b5810708b1a6bb5985f8d78c/list3.acns.txt.sorted.txt
work/a6/f25fd34c53466070c962162192b5ed/list4.acns.txt
work/a6/f25fd34c53466070c962162192b5ed/list4.acns.txt.sorted.txt
```


