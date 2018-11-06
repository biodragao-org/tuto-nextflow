## Synopsis
> The maxForks directive allows you to define the maximum number of process instances that can be executed in parallel.

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
		file("distinct.acns.txt") into distinct_acns
	script:
	"""
	echo '${array_of_rows.join("\n")}' > table.csv
	cut -d ',' -f2 table.csv | while read F
	do
		cat \$F
	done | sort | uniq > distinct.acns.txt
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
	../bin/ncbicurl ${acn} > "${acn}.fa"
	"""
	}

```


## Execute

```
../bin/nextflow run  workflow.nf --acns '../data/list*.acns.txt'
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [awesome_swartz] - revision: e51b9730ab
[warm up] executor > local
[81/346078] Submitted process > sortAcns (sorting list3.acns.txt)
[21/0f292c] Submitted process > sortAcns (sorting list4.acns.txt)
[51/33347a] Submitted process > sortAcns (sorting list2.acns.txt)
[cf/204ae2] Submitted process > sortAcns (sorting list1.acns.txt)
[90/ad2c24] Submitted process > commonAcns (comm list3.acns.txt vs list4.acns.txt)
[fd/3cb52d] Submitted process > commonAcns (comm list2.acns.txt vs list3.acns.txt)
[99/c8977e] Submitted process > commonAcns (comm list2.acns.txt vs list4.acns.txt)
[72/56e5ad] Submitted process > commonAcns (comm list1.acns.txt vs list3.acns.txt)
[25/dabc62] Submitted process > commonAcns (comm list1.acns.txt vs list4.acns.txt)
[f1/ca3ce4] Submitted process > commonAcns (comm list1.acns.txt vs list2.acns.txt)
[10/dda949] Submitted process > listCommons (common list size: 6)
[59/6393c7] Submitted process > eachAcn (dowloading AF002815.1)
ERROR ~ Error executing process > 'eachAcn (dowloading AF002815.1)'

Caused by:
  Process `eachAcn (dowloading AF002815.1)` terminated with an error exit status (1)

Command executed:

  ../bin/ncbicurl AF002815.1 > "AF002815.1.fa"

Command exit status:
  1

Command output:
  (empty)

Command error:
  .command.sh: line 2: ../bin/ncbicurl: No such file or directory

Work dir:
  /home/lindenb/src/tuto-nextflow/0170_maxFork/work/59/6393c70eece2e173650b8ae0b0e24b

Tip: you can replicate the issue by changing to the process work dir and entering the command `bash .command.run`

 -- Check '.nextflow.log' file for details
[e2/8ab57f] Submitted process > eachAcn (dowloading AF002816.1)
WARN: Killing pending tasks (1)
Makefile:4: recipe for target 'all' failed
make[1]: *** [all] Error 1
```


## Files

```
work/21/0f292c54c79bd46c6d093d6938de16/list4.acns.txt.sorted.txt
work/21/0f292c54c79bd46c6d093d6938de16/list4.acns.txt
work/59/6393c70eece2e173650b8ae0b0e24b/AF002815.1.fa
work/10/dda949432d12f7de3b2c702bf3a286/distinct.acns.txt
work/10/dda949432d12f7de3b2c702bf3a286/table.csv
work/cf/204ae2de53bc42ae5c31c78395218b/list1.acns.txt.sorted.txt
work/cf/204ae2de53bc42ae5c31c78395218b/list1.acns.txt
work/e2/8ab57ff38eddb0e91a2f60da7a38fd/AF002816.1.fa
work/51/33347a3aebe73bfe8397bfee7582a7/list2.acns.txt.sorted.txt
work/51/33347a3aebe73bfe8397bfee7582a7/list2.acns.txt
work/81/346078eb1b4e81f9ff95a7d7e06fb6/list3.acns.txt
work/81/346078eb1b4e81f9ff95a7d7e06fb6/list3.acns.txt.sorted.txt
work/90/ad2c24c8dc3aafd939a63dd5476bc7/comm.txt
work/fd/3cb52d16cd70ad8b8354a338a855c0/comm.txt
work/f1/ca3ce46b5b148a2a7bacbfb752ff5a/comm.txt
work/72/56e5ad884c49e95195151ed367ff91/comm.txt
work/25/dabc62c6a8afb69b15bf7f82789772/comm.txt
work/99/c8977e900508e4752cdff88dcd0f58/comm.txt
```


