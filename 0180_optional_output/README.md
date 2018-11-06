## Synopsis
> In most cases a process is expected to generate output that is added to the output channel. However, there are situations where it is valid for a process to not generate output. In these cases optional true may be added to the output declaration

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
		file("${acn}.fa") into fastas
	script:
	"""
	../bin/ncbicurl ${acn} > "${acn}.fa"
	"""
	}

process filterSize {
	tag "size for ${fasta}"

	input:
		file fasta from fastas
	output:
		file("${fasta}.small.fa") optional true into smallfastas
	script:

	"""
	if [ `grep -v ">" ${fasta} | tr -d '\\n ' | wc -c` -lt 100 ]; then
		cp "${fasta}"  "${fasta}.small.fa"
	fi
	"""


	}
```


## Execute

```
../bin/nextflow run -resume -with-trace trace.tsv -with-report report.html -with-timeline timeline.html -with-dag flowchart.png workflow.nf --acns '../data/list*.acns.txt'
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [ecstatic_elion] - revision: 00439c5ba9
[warm up] executor > local
[7f/2465f6] Submitted process > sortAcns (sorting list4.acns.txt)
[ba/347cb5] Submitted process > sortAcns (sorting list2.acns.txt)
[a4/6d0840] Submitted process > sortAcns (sorting list3.acns.txt)
[d1/c250c0] Submitted process > sortAcns (sorting list1.acns.txt)
[5d/d0081e] Submitted process > commonAcns (comm list2.acns.txt vs list4.acns.txt)
[96/d7aa64] Submitted process > commonAcns (comm list2.acns.txt vs list3.acns.txt)
[1a/d521ac] Submitted process > commonAcns (comm list3.acns.txt vs list4.acns.txt)
[d0/af98bb] Submitted process > commonAcns (comm list1.acns.txt vs list4.acns.txt)
[72/2b73c1] Submitted process > commonAcns (comm list1.acns.txt vs list2.acns.txt)
[03/c0e199] Submitted process > commonAcns (comm list1.acns.txt vs list3.acns.txt)
[c2/e534de] Submitted process > listCommons (common list size: 6)
[03/f99394] Submitted process > eachAcn (dowloading AF002815.1)
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
  /home/lindenb/src/tuto-nextflow/0180_optional_output/work/03/f993947a50e2355130b2c5b418ebcb

Tip: you can replicate the issue by changing to the process work dir and entering the command `bash .command.run`

 -- Check '.nextflow.log' file for details
[9f/062561] Submitted process > eachAcn (dowloading AF002816.1)
WARN: Killing pending tasks (1)
Makefile:4: recipe for target 'all' failed
make[1]: *** [all] Error 1
```


## Files

```
work/9f/0625616ba730c07e37ff970eff3c60/AF002816.1.fa
work/7f/2465f687b48cc213eb7a15a5d418fe/list4.acns.txt.sorted.txt
work/7f/2465f687b48cc213eb7a15a5d418fe/list4.acns.txt
work/ba/347cb5e6ab777d478bda62b119b98b/list2.acns.txt.sorted.txt
work/ba/347cb5e6ab777d478bda62b119b98b/list2.acns.txt
work/a4/6d0840269741787c8d390a45fe6778/list3.acns.txt
work/a4/6d0840269741787c8d390a45fe6778/list3.acns.txt.sorted.txt
work/1a/d521acd0efc03eab32122976814049/comm.txt
work/c2/e534de790c14e03d045bc2f5593bf9/distinct.acns.txt
work/c2/e534de790c14e03d045bc2f5593bf9/table.csv
work/d1/c250c0cce5cb2e99813a346aea19a6/list1.acns.txt.sorted.txt
work/d1/c250c0cce5cb2e99813a346aea19a6/list1.acns.txt
work/96/d7aa64945ed82c18a353e70a6dae0c/comm.txt
work/5d/d0081ed4fdd5c05ff118b371098aac/comm.txt
work/03/c0e199eb590b7ad87a037da67e6911/comm.txt
work/03/f993947a50e2355130b2c5b418ebcb/AF002815.1.fa
work/72/2b73c1384b0323d6ff302d478cbb00/comm.txt
work/d0/af98bb3d2a5d73dc55dda549be3d37/comm.txt
```



## Workflow

![Workflow](flowchart.png)


## Trace

```
task_id	hash	native_id	name	status	exit	submit	duration	realtime	%cpu	rss	vmem	rchar	wchar
2	7f/2465f6	11543	sortAcns (sorting list4.acns.txt)	COMPLETED	0	2018-11-06 10:57:27.327	276ms	55ms	0.0%	0	0	0	0
3	ba/347cb5	11574	sortAcns (sorting list2.acns.txt)	COMPLETED	0	2018-11-06 10:57:27.425	285ms	5ms	0.0%	0	0	0	0
1	a4/6d0840	11666	sortAcns (sorting list3.acns.txt)	COMPLETED	0	2018-11-06 10:57:27.621	348ms	45ms	0.0%	0	0	0	0
4	d1/c250c0	11699	sortAcns (sorting list1.acns.txt)	COMPLETED	0	2018-11-06 10:57:27.729	291ms	22ms	0.0%	0	0	0	0
7	96/d7aa64	11807	commonAcns (comm list2.acns.txt vs list3.acns.txt)	COMPLETED	0	2018-11-06 10:57:28.026	216ms	24ms	0.0%	0	0	0	0
5	5d/d0081e	11789	commonAcns (comm list2.acns.txt vs list4.acns.txt)	COMPLETED	0	2018-11-06 10:57:27.987	306ms	39ms	0.0%	0	0	0	0
9	d0/af98bb	11921	commonAcns (comm list1.acns.txt vs list4.acns.txt)	COMPLETED	0	2018-11-06 10:57:28.319	235ms	30ms	0.0%	0	0	0	0
6	1a/d521ac	11909	commonAcns (comm list3.acns.txt vs list4.acns.txt)	COMPLETED	0	2018-11-06 10:57:28.260	385ms	40ms	0.0%	0	0	0	0
8	72/2b73c1	12027	commonAcns (comm list1.acns.txt vs list2.acns.txt)	COMPLETED	0	2018-11-06 10:57:28.572	368ms	29ms	0.0%	0	0	0	0
10	03/c0e199	12044	commonAcns (comm list1.acns.txt vs list3.acns.txt)	COMPLETED	0	2018-11-06 10:57:28.668	288ms	24ms	0.0%	0	0	0	0
11	c2/e534de	12146	listCommons (common list size: 6)	COMPLETED	0	2018-11-06 10:57:28.979	215ms	19ms	0.0%	0	0	0	0
12	03/f99394	12214	eachAcn (dowloading AF002815.1)	FAILED	1	2018-11-06 10:57:29.215	301ms	29ms	0.0%	0	0	0	0
13	9f/062561	12273	eachAcn (dowloading AF002816.1)	FAILED	-	2018-11-06 10:57:29.631	-	-	-	-	-	-	-
```

