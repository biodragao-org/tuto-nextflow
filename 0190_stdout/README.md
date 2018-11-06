## Synopsis
> `stdout` Sends the executed process stdout over the output channel.

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
		file("${fasta}.small.fa") optional true into (smallfastas1,smallfastas2)
	script:

	"""
	if [ `grep -v ">" ${fasta} | tr -d '\\n ' | wc -c` -lt 100 ]; then
		cp "${fasta}"  "${fasta}.small.fa"
	fi
	"""
	}

process pairwise_align {
	tag "pairwise ${fasta1} vs ${fasta2}"
	maxForks 1
	input:
		set fasta1,fasta2 from smallfastas1.
		          combine(smallfastas2).
		          filter{ROW->ROW[0].getName().compareTo(ROW[1].getName())<0}.
			  take(2)
			  
	output:
		stdout scores
	script:
	"""
	SEQ1=`grep -v ">" "${fasta1}" | tr -d "\n"`
	SEQ2=`grep -v ">" "${fasta2}" | tr -d "\n"`
	
	echo -n "${fasta1},${fasta2},"

	curl 'https://embnet.vital-it.ch/cgi-bin/LALIGN_form_parser' \
		-H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:62.0) Gecko/20100101 Firefox/62.0' \
		-H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' -H 'Accept-Language: en-US,en;q=0.5' \
		--compressed \
		-H 'Referer: https://embnet.vital-it.ch/software/LALIGN_form.html' \
		-H 'Content-Type: application/x-www-form-urlencoded' \
		-H 'DNT: 1' \
		-H 'Connection: keep-alive' \
		-H 'Upgrade-Insecure-Requests: 1' \
		--data "method=global&no=1&evalue=10.0&matrix=dna&open=-12&exten=-2&comm1=seq1&format1=plain_text&seq1=\${SEQ1}&comm2=seq2&format2=plain_text&seq2=\${SEQ2}" |\
	xmllint --html --format --xpath '//pre[1]/text()' - |\
		grep -F 'Z-score:' -m1 | cut -d ':' -f 5 | tr -d ' '
	"""
	}

scores.subscribe { print "I say..  $it" }
```


## Execute

```
../bin/nextflow run -resume -with-trace trace.tsv -with-report report.html -with-timeline timeline.html -with-dag flowchart.png workflow.nf --acns '../data/list*.acns.txt'
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [fabulous_goldstine] - revision: dd0fa59370
[warm up] executor > local
[93/b5c456] Submitted process > sortAcns (sorting list4.acns.txt)
[dd/eb5b0d] Submitted process > sortAcns (sorting list3.acns.txt)
[b3/ef8b23] Submitted process > sortAcns (sorting list2.acns.txt)
[f1/385af9] Submitted process > sortAcns (sorting list1.acns.txt)
[e8/e8b77e] Submitted process > commonAcns (comm list3.acns.txt vs list4.acns.txt)
[f4/68ca64] Submitted process > commonAcns (comm list2.acns.txt vs list3.acns.txt)
[7a/fdfd1b] Submitted process > commonAcns (comm list2.acns.txt vs list4.acns.txt)
[2a/4a643c] Submitted process > commonAcns (comm list1.acns.txt vs list3.acns.txt)
[67/58b7b3] Submitted process > commonAcns (comm list1.acns.txt vs list2.acns.txt)
[1f/135e27] Submitted process > commonAcns (comm list1.acns.txt vs list4.acns.txt)
[b3/1552af] Submitted process > listCommons (common list size: 6)
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

Tip: view the complete command output by changing to the process work dir and entering the command `cat .command.out`

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
work/f4/68ca64584c25fccb68a119091130fa/comm.txt
work/e8/e8b77ea01dfe35e14b24285f9f04a6/comm.txt
work/67/58b7b3f9eba782b1277849d8a1ddaa/comm.txt
work/7a/fdfd1be90032f5d1cafeb4ef29e699/comm.txt
work/1f/135e27d8448c13e5533fefefb8dbfe/comm.txt
work/f1/385af9daa0fbb85533a2be494ae243/list1.acns.txt.sorted.txt
work/f1/385af9daa0fbb85533a2be494ae243/list1.acns.txt
work/3b/1e91fb9a157d555c5d9d3cfd05a0ef/AF002815.1.fa
work/dd/eb5b0def1dd8d333a774c762e44d2c/list3.acns.txt
work/dd/eb5b0def1dd8d333a774c762e44d2c/list3.acns.txt.sorted.txt
work/2a/4a643cb7e1dac8b77bcfa8879f483b/comm.txt
work/b3/ef8b23870cd7bba18d8fa9eb79b97f/list2.acns.txt.sorted.txt
work/b3/ef8b23870cd7bba18d8fa9eb79b97f/list2.acns.txt
work/b3/1552af0b94084519abd99f0e0b4ed1/distinct.acns.txt
work/b3/1552af0b94084519abd99f0e0b4ed1/table.csv
```



## Workflow

![Workflow](flowchart.png)


## Trace

```
task_id	hash	native_id	name	status	exit	submit	duration	realtime	%cpu	rss	vmem	rchar	wchar
1	dd/eb5b0d	12416	sortAcns (sorting list3.acns.txt)	COMPLETED	0	2018-11-06 10:57:36.769	262ms	28ms	0.0%	0	0	0	0
2	93/b5c456	12412	sortAcns (sorting list4.acns.txt)	COMPLETED	0	2018-11-06 10:57:36.715	573ms	44ms	0.0%	0	0	0	0
3	b3/ef8b23	12536	sortAcns (sorting list2.acns.txt)	COMPLETED	0	2018-11-06 10:57:37.079	320ms	75ms	0.0%	0	0	0	0
4	f1/385af9	12597	sortAcns (sorting list1.acns.txt)	COMPLETED	0	2018-11-06 10:57:37.308	430ms	36ms	0.0%	0	0	0	0
5	e8/e8b77e	12624	commonAcns (comm list3.acns.txt vs list4.acns.txt)	COMPLETED	0	2018-11-06 10:57:37.413	586ms	44ms	0.0%	0	0	0	0
7	f4/68ca64	12705	commonAcns (comm list2.acns.txt vs list3.acns.txt)	COMPLETED	0	2018-11-06 10:57:37.781	326ms	41ms	0.0%	0	0	0	0
6	7a/fdfd1b	12776	commonAcns (comm list2.acns.txt vs list4.acns.txt)	COMPLETED	0	2018-11-06 10:57:38.015	394ms	43ms	0.0%	0	0	0	0
9	2a/4a643c	12807	commonAcns (comm list1.acns.txt vs list3.acns.txt)	COMPLETED	0	2018-11-06 10:57:38.119	421ms	35ms	0.0%	0	0	0	0
8	1f/135e27	12918	commonAcns (comm list1.acns.txt vs list4.acns.txt)	COMPLETED	0	2018-11-06 10:57:38.560	170ms	90ms	-	-	-	-	-
10	67/58b7b3	12894	commonAcns (comm list1.acns.txt vs list2.acns.txt)	COMPLETED	0	2018-11-06 10:57:38.435	425ms	75ms	0.0%	0	0	0	0
11	b3/1552af	12982	listCommons (common list size: 6)	COMPLETED	0	2018-11-06 10:57:38.889	318ms	28ms	0.0%	0	0	0	0
12	3b/1e91fb	13050	eachAcn (dowloading AF002815.1)	FAILED	1	2018-11-06 10:57:39.235	288ms	29ms	0.0%	0	0	0	0
13	02/164d1c	13109	eachAcn (dowloading AF002816.1)	FAILED	-	2018-11-06 10:57:39.603	-	-	-	-	-	-	-
```

