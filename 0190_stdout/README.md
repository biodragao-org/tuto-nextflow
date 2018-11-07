## Synopsis

> `stdout` Sends the executed process stdout over the output channel.

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
 69   		file("${fasta}.small.fa") optional true into (smallfastas1,smallfastas2)
 70   	script:
 71   
 72   	"""
 73   	if [ `grep -v ">" ${fasta} | tr -d '\\n ' | wc -c` -lt 100 ]; then
 74   		cp "${fasta}"  "${fasta}.small.fa"
 75   	fi
 76   	"""
 77   	}
 78   
 79   process pairwise_align {
 80   	tag "pairwise ${fasta1} vs ${fasta2}"
 81   	maxForks 1
 82   	input:
 83   		set fasta1,fasta2 from smallfastas1.
 84   		          combine(smallfastas2).
 85   		          filter{ROW->ROW[0].getName().compareTo(ROW[1].getName())<0}.
 86   			  take(2)
 87   			  
 88   	output:
 89   		stdout scores
 90   	script:
 91   	"""
 92   	SEQ1=`grep -v ">" "${fasta1}" | tr -d "\n"`
 93   	SEQ2=`grep -v ">" "${fasta2}" | tr -d "\n"`
 94   	
 95   	echo -n "${fasta1},${fasta2},"
 96   
 97   	curl 'https://embnet.vital-it.ch/cgi-bin/LALIGN_form_parser' \
 98   		-H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:62.0) Gecko/20100101 Firefox/62.0' \
 99   		-H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' -H 'Accept-Language: en-US,en;q=0.5' \
100   		--compressed \
101   		-H 'Referer: https://embnet.vital-it.ch/software/LALIGN_form.html' \
102   		-H 'Content-Type: application/x-www-form-urlencoded' \
103   		-H 'DNT: 1' \
104   		-H 'Connection: keep-alive' \
105   		-H 'Upgrade-Insecure-Requests: 1' \
106   		--data "method=global&no=1&evalue=10.0&matrix=dna&open=-12&exten=-2&comm1=seq1&format1=plain_text&seq1=\${SEQ1}&comm2=seq2&format2=plain_text&seq2=\${SEQ2}" |\
107   	xmllint --html --format --xpath '//pre[1]/text()' - |\
108   		grep -F 'Z-score:' -m1 | cut -d ':' -f 5 | tr -d ' '
109   	"""
110   	}
111   
112   scores.subscribe { print "I say..  $it" }
```


## Execute

```
../bin/nextflow run -resume -with-trace trace.tsv -with-report report.html -with-timeline timeline.html -with-dag flowchart.png workflow.nf --acns '../data/list*.acns.txt'
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [romantic_faggin] - revision: dd0fa59370
[warm up] executor > local
[dd/eb5b0d] Submitted process > sortAcns (sorting list3.acns.txt)
[b3/ef8b23] Submitted process > sortAcns (sorting list2.acns.txt)
[93/b5c456] Submitted process > sortAcns (sorting list4.acns.txt)
[f1/385af9] Submitted process > sortAcns (sorting list1.acns.txt)
[d3/d1bc2a] Submitted process > commonAcns (comm list2.acns.txt vs list3.acns.txt)
[eb/0ce6c4] Submitted process > commonAcns (comm list1.acns.txt vs list3.acns.txt)
[8d/8f04b1] Submitted process > commonAcns (comm list1.acns.txt vs list2.acns.txt)
[0a/f0b294] Submitted process > commonAcns (comm list3.acns.txt vs list4.acns.txt)
[8a/e5a97b] Submitted process > commonAcns (comm list1.acns.txt vs list4.acns.txt)
[76/52dd01] Submitted process > commonAcns (comm list2.acns.txt vs list4.acns.txt)
[70/d84c12] Submitted process > listCommons (common list size: 6)
[3b/1e91fb] Submitted process > eachAcn (dowloading AF002815.1)
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
  /home/lindenb/src/tuto-nextflow/0190_stdout/work/3b/1e91fb9a157d555c5d9d3cfd05a0ef

Tip: you can replicate the issue by changing to the process work dir and entering the command `bash .command.run`

 -- Check '.nextflow.log' file for details
[02/164d1c] Submitted process > eachAcn (dowloading AF002816.1)
WARN: Killing pending tasks (1)
Makefile:4: recipe for target 'all' failed
make[1]: *** [all] Error 1
```


## Files

```
work/93/b5c456e39c08171a0971a8d674bcce/list4.acns.txt.sorted.txt
work/93/b5c456e39c08171a0971a8d674bcce/list4.acns.txt
work/0a/f0b294ad241de0eaa3f51a411c861e/comm.txt
work/02/164d1c93c1a9678d00a4dc1a5f1c31/AF002816.1.fa
work/76/52dd01f49926b71bb073da88f7813d/comm.txt
work/d3/d1bc2aba898c1f16b161d083ea9c2d/comm.txt
work/eb/0ce6c41d16414372d7bc3a4595e273/comm.txt
work/8a/e5a97b6f10bbd880cfd0cfccc9c84a/comm.txt
work/f1/385af9daa0fbb85533a2be494ae243/list1.acns.txt.sorted.txt
work/f1/385af9daa0fbb85533a2be494ae243/list1.acns.txt
work/3b/1e91fb9a157d555c5d9d3cfd05a0ef/AF002815.1.fa
work/dd/eb5b0def1dd8d333a774c762e44d2c/list3.acns.txt
work/dd/eb5b0def1dd8d333a774c762e44d2c/list3.acns.txt.sorted.txt
work/70/d84c12c77c70262d0942df71da545e/distinct.acns.txt
work/70/d84c12c77c70262d0942df71da545e/table.csv
work/8d/8f04b1c229c2a124e2a36f8c4777cb/comm.txt
work/b3/ef8b23870cd7bba18d8fa9eb79b97f/list2.acns.txt.sorted.txt
work/b3/ef8b23870cd7bba18d8fa9eb79b97f/list2.acns.txt
```



## Workflow

![Workflow](flowchart.png)


## Trace

```
task_id	hash	native_id	name	status	exit	submit	duration	realtime	%cpu	rss	vmem	rchar	wchar
1	dd/eb5b0d	21609	sortAcns (sorting list3.acns.txt)	COMPLETED	0	2018-11-07 10:12:06.477	273ms	22ms	0.0%	0	0	0	0
3	b3/ef8b23	21620	sortAcns (sorting list2.acns.txt)	COMPLETED	0	2018-11-07 10:12:06.541	311ms	7ms	0.0%	0	0	0	0
4	f1/385af9	21747	sortAcns (sorting list1.acns.txt)	COMPLETED	0	2018-11-07 10:12:06.862	297ms	23ms	0.0%	0	0	0	0
2	93/b5c456	21732	sortAcns (sorting list4.acns.txt)	COMPLETED	0	2018-11-07 10:12:06.770	402ms	41ms	0.0%	0	0	0	0
5	d3/d1bc2a	21856	commonAcns (comm list2.acns.txt vs list3.acns.txt)	COMPLETED	0	2018-11-07 10:12:07.168	224ms	26ms	0.0%	0	0	0	0
7	eb/0ce6c4	21875	commonAcns (comm list1.acns.txt vs list3.acns.txt)	COMPLETED	0	2018-11-07 10:12:07.199	244ms	22ms	0.0%	0	0	0	0
6	8d/8f04b1	21976	commonAcns (comm list1.acns.txt vs list2.acns.txt)	COMPLETED	0	2018-11-07 10:12:07.395	232ms	18ms	0.0%	0	0	0	0
8	0a/f0b294	22006	commonAcns (comm list3.acns.txt vs list4.acns.txt)	COMPLETED	0	2018-11-07 10:12:07.454	235ms	27ms	0.0%	0	0	0	0
10	8a/e5a97b	22094	commonAcns (comm list1.acns.txt vs list4.acns.txt)	COMPLETED	0	2018-11-07 10:12:07.634	217ms	27ms	0.0%	0	0	0	0
9	76/52dd01	22133	commonAcns (comm list2.acns.txt vs list4.acns.txt)	COMPLETED	0	2018-11-07 10:12:07.696	209ms	22ms	0.0%	0	0	0	0
11	70/d84c12	22213	listCommons (common list size: 6)	COMPLETED	0	2018-11-07 10:12:07.922	196ms	16ms	0.0%	0	0	0	0
12	3b/1e91fb	22281	eachAcn (dowloading AF002815.1)	FAILED	1	2018-11-07 10:12:08.138	177ms	3ms	0.0%	0	0	0	0
13	02/164d1c	22340	eachAcn (dowloading AF002816.1)	FAILED	-	2018-11-07 10:12:08.383	-	-	-	-	-	-	-
```

