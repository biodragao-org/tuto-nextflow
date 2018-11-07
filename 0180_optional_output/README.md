## Synopsis

> In most cases a process is expected to generate output that is added to the output channel. However, there are situations where it is valid for a process to not generate output. In these cases optional true may be added to the output declaration

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
 56   		file("${acn}.fa") into fastas
 57   	script:
 58   	"""
 59   	../bin/ncbicurl ${acn} > "${acn}.fa"
 60   	"""
 61   	}
 62   
 63   process filterSize {
 64   	tag "size for ${fasta}"
 65   
 66   	input:
 67   		file fasta from fastas
 68   	output:
 69   		file("${fasta}.small.fa") optional true into smallfastas
 70   	script:
 71   
 72   	"""
 73   	if [ `grep -v ">" ${fasta} | tr -d '\\n ' | wc -c` -lt 100 ]; then
 74   		cp "${fasta}"  "${fasta}.small.fa"
 75   	fi
 76   	"""
 77   
 78   
 79   	}
```


## Execute

```
../bin/nextflow run -resume -with-trace trace.tsv -with-report report.html -with-timeline timeline.html -with-dag flowchart.png workflow.nf --acns '../data/list*.acns.txt'
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [focused_becquerel] - revision: 00439c5ba9
[warm up] executor > local
[7f/2465f6] Submitted process > sortAcns (sorting list4.acns.txt)
[ba/347cb5] Submitted process > sortAcns (sorting list2.acns.txt)
[a4/6d0840] Submitted process > sortAcns (sorting list3.acns.txt)
[d1/c250c0] Submitted process > sortAcns (sorting list1.acns.txt)
[ca/3e661f] Submitted process > commonAcns (comm list2.acns.txt vs list4.acns.txt)
[36/8fac54] Submitted process > commonAcns (comm list1.acns.txt vs list2.acns.txt)
[e0/d6a7b2] Submitted process > commonAcns (comm list1.acns.txt vs list4.acns.txt)
[e8/57abac] Submitted process > commonAcns (comm list3.acns.txt vs list4.acns.txt)
[91/13879b] Submitted process > commonAcns (comm list2.acns.txt vs list3.acns.txt)
[86/6b6955] Submitted process > commonAcns (comm list1.acns.txt vs list3.acns.txt)
[2b/6263a9] Submitted process > listCommons (common list size: 6)
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

Tip: when you have fixed the problem you can continue the execution appending to the nextflow command line the option `-resume`

 -- Check '.nextflow.log' file for details
Makefile:4: recipe for target 'all' failed
make[1]: *** [all] Error 1
```


## Files

```
work/7f/2465f687b48cc213eb7a15a5d418fe/list4.acns.txt.sorted.txt
work/7f/2465f687b48cc213eb7a15a5d418fe/list4.acns.txt
work/ba/347cb5e6ab777d478bda62b119b98b/list2.acns.txt.sorted.txt
work/ba/347cb5e6ab777d478bda62b119b98b/list2.acns.txt
work/a4/6d0840269741787c8d390a45fe6778/list3.acns.txt
work/a4/6d0840269741787c8d390a45fe6778/list3.acns.txt.sorted.txt
work/36/8fac543e93110db4eafebffb968c4b/comm.txt
work/e8/57abacee06a784de4b7332f72468cb/comm.txt
work/ca/3e661fc0da641e6076c5b66fd9f21a/comm.txt
work/d1/c250c0cce5cb2e99813a346aea19a6/list1.acns.txt.sorted.txt
work/d1/c250c0cce5cb2e99813a346aea19a6/list1.acns.txt
work/2b/6263a9632dd40e09677d7780299e11/distinct.acns.txt
work/2b/6263a9632dd40e09677d7780299e11/table.csv
work/e0/d6a7b227b965d6f4d9b42438cdfe94/comm.txt
work/03/f993947a50e2355130b2c5b418ebcb/AF002815.1.fa
work/91/13879bed159e7bd62a0e31ccb41aa4/comm.txt
work/86/6b6955f4ee716aeee4e585a1a02d50/comm.txt
```



## Workflow

![Workflow](flowchart.png)


## Trace

```
task_id	hash	native_id	name	status	exit	submit	duration	realtime	%cpu	rss	vmem	rchar	wchar
3	ba/347cb5	20809	sortAcns (sorting list2.acns.txt)	COMPLETED	0	2018-11-07 10:11:58.877	310ms	29ms	0.0%	0	0	0	0
1	7f/2465f6	20795	sortAcns (sorting list4.acns.txt)	COMPLETED	0	2018-11-07 10:11:58.803	561ms	66ms	0.0%	0	0	0	0
4	d1/c250c0	20938	sortAcns (sorting list1.acns.txt)	COMPLETED	0	2018-11-07 10:11:59.372	288ms	34ms	0.0%	0	0	0	0
2	a4/6d0840	20919	sortAcns (sorting list3.acns.txt)	COMPLETED	0	2018-11-07 10:11:59.221	543ms	42ms	0.0%	0	0	0	0
5	ca/3e661f	21041	commonAcns (comm list2.acns.txt vs list4.acns.txt)	COMPLETED	0	2018-11-07 10:11:59.666	258ms	22ms	0.0%	0	0	0	0
6	36/8fac54	21099	commonAcns (comm list1.acns.txt vs list2.acns.txt)	COMPLETED	0	2018-11-07 10:11:59.800	229ms	28ms	0.0%	0	0	0	0
7	e0/d6a7b2	21161	commonAcns (comm list1.acns.txt vs list4.acns.txt)	COMPLETED	0	2018-11-07 10:11:59.933	180ms	5ms	0.0%	0	0	0	0
8	e8/57abac	21220	commonAcns (comm list3.acns.txt vs list4.acns.txt)	COMPLETED	0	2018-11-07 10:12:00.043	209ms	4ms	0.0%	0	0	0	0
9	91/13879b	21275	commonAcns (comm list2.acns.txt vs list3.acns.txt)	COMPLETED	0	2018-11-07 10:12:00.126	207ms	6ms	0.0%	0	0	0	0
10	86/6b6955	21338	commonAcns (comm list1.acns.txt vs list3.acns.txt)	COMPLETED	0	2018-11-07 10:12:00.262	199ms	5ms	0.0%	0	0	0	0
11	2b/6263a9	21398	listCommons (common list size: 6)	COMPLETED	0	2018-11-07 10:12:00.473	177ms	12ms	0.0%	0	0	0	0
12	03/f99394	21466	eachAcn (dowloading AF002815.1)	FAILED	1	2018-11-07 10:12:00.670	192ms	5ms	0.0%	0	0	0	0
```

