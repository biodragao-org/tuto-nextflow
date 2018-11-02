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
		file("${acn}.fa") into fastas
	script:
	"""
	wget -O "${acn}.fa" "https://www.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nucleotide&id=${acn}&rettype=fasta"
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
Launching `workflow.nf` [dreamy_hopper] - revision: 5d1f992d42
[warm up] executor > local
[dd/eb5b0d] Submitted process > sortAcns (sorting list3.acns.txt)
[b3/ef8b23] Submitted process > sortAcns (sorting list2.acns.txt)
[93/b5c456] Submitted process > sortAcns (sorting list4.acns.txt)
[f1/385af9] Submitted process > sortAcns (sorting list1.acns.txt)
[01/c8993c] Submitted process > commonAcns (comm list2.acns.txt vs list3.acns.txt)
[3f/158524] Submitted process > commonAcns (comm list2.acns.txt vs list4.acns.txt)
[e9/6843c1] Submitted process > commonAcns (comm list3.acns.txt vs list4.acns.txt)
[ba/d943b9] Submitted process > commonAcns (comm list1.acns.txt vs list2.acns.txt)
[02/f34d60] Submitted process > commonAcns (comm list1.acns.txt vs list4.acns.txt)
[fd/ec3b83] Submitted process > commonAcns (comm list1.acns.txt vs list3.acns.txt)
[20/fd7a56] Submitted process > listCommons (common list size: 6)
[b0/298913] Submitted process > eachAcn (dowloading AF002815.1)
[0e/c6a838] Submitted process > filterSize (size for AF002815.1.fa)
[06/3bdcf6] Submitted process > eachAcn (dowloading AF002816.1)
[23/f783de] Submitted process > eachAcn (dowloading AF004836.1)
[fb/70a72f] Submitted process > filterSize (size for AF002816.1.fa)
[64/1e5ddd] Submitted process > filterSize (size for AF004836.1.fa)
[5e/b0d808] Submitted process > eachAcn (dowloading AF188126.1)
[34/1ee48c] Submitted process > filterSize (size for AF188126.1.fa)
[ef/9bc628] Submitted process > eachAcn (dowloading AF188530.1)
[7c/53193b] Submitted process > eachAcn (dowloading AX244961.1)
[d7/6c060d] Submitted process > filterSize (size for AF188530.1.fa)
[de/303860] Submitted process > filterSize (size for AX244961.1.fa)
[b1/590f9c] Submitted process > eachAcn (dowloading AX244962.1)
[92/f86f69] Submitted process > eachAcn (dowloading AX244963.1)
[57/1daa35] Submitted process > filterSize (size for AX244962.1.fa)
[3c/8d29bd] Submitted process > pairwise_align (pairwise /home/lindenb/src/tuto-nextflow/0190_stdout/work/de/30386051a8d956814f8c00e0138269/AX244961.1.fa.small.fa vs /home/lindenb/src/tuto-nextflow/0190_stdout/work/57/1daa35cf86c04625bd03818a4b2ac0/AX244962.1.fa.small.fa)
[4a/64ff0a] Submitted process > eachAcn (dowloading AX244964.1)
[53/2bc036] Submitted process > filterSize (size for AX244963.1.fa)
[de/89c23e] Submitted process > eachAcn (dowloading AX244965.1)
[ac/889f48] Submitted process > filterSize (size for AX244964.1.fa)
I say..  /home/lindenb/src/tuto-nextflow/0190_stdout/work/de/30386051a8d956814f8c00e0138269/AX244961.1.fa.small.fa,/home/lindenb/src/tuto-nextflow/0190_stdout/work/57/1daa35cf86c04625bd03818a4b2ac0/AX244962.1.fa.small.fa,0.62
[44/3d1ad3] Submitted process > pairwise_align (pairwise /home/lindenb/src/tuto-nextflow/0190_stdout/work/de/30386051a8d956814f8c00e0138269/AX244961.1.fa.small.fa vs /home/lindenb/src/tuto-nextflow/0190_stdout/work/53/2bc036761253ee8a82a74a4051b872/AX244963.1.fa.small.fa)
[21/fb87fe] Submitted process > eachAcn (dowloading AX244966.1)
[28/521a89] Submitted process > filterSize (size for AX244965.1.fa)
I say..  /home/lindenb/src/tuto-nextflow/0190_stdout/work/de/30386051a8d956814f8c00e0138269/AX244961.1.fa.small.fa,/home/lindenb/src/tuto-nextflow/0190_stdout/work/53/2bc036761253ee8a82a74a4051b872/AX244963.1.fa.small.fa,9.7e-06
[d1/428387] Submitted process > filterSize (size for AX244966.1.fa)
[a8/f0d264] Submitted process > eachAcn (dowloading AX244967.1)
[4a/d7f740] Submitted process > filterSize (size for AX244967.1.fa)
[de/1ae236] Submitted process > eachAcn (dowloading AX244968.1)
[68/cf70d6] Submitted process > filterSize (size for AX244968.1.fa)
[ef/1938ff] Submitted process > eachAcn (dowloading AY116592.1)
[70/44e737] Submitted process > filterSize (size for AY116592.1.fa)
[08/bff07a] Submitted process > eachAcn (dowloading NM_017590.5)
[fd/a2db22] Submitted process > filterSize (size for NM_017590.5.fa)
```


## Files

```
work/23/f783def13b3e93e9a11b9733b68a73/AF004836.1.fa
work/57/1daa35cf86c04625bd03818a4b2ac0/AX244962.1.fa.small.fa
work/57/1daa35cf86c04625bd03818a4b2ac0/AX244962.1.fa
work/a8/f0d2648f45b14ce48ab3d5f815a23d/AX244967.1.fa
work/fb/70a72fee12be7e7bc41681597cb5f3/AF002816.1.fa
work/93/b5c456e39c08171a0971a8d674bcce/list4.acns.txt.sorted.txt
work/93/b5c456e39c08171a0971a8d674bcce/list4.acns.txt
work/21/fb87fe4bd2edb0235986b3ca157203/AX244966.1.fa
work/d7/6c060d3989c760119bb3b527b76809/AF188530.1.fa
work/ba/d943b920d9422b1f411bb239387a6b/comm.txt
work/b0/298913b9f2bc9226af802f83c53db4/AF002815.1.fa
work/ef/1938ff252460dd09b3ac6fe27098cf/AY116592.1.fa
work/ef/9bc6288b04eb4887f1cdc332d62ee0/AF188530.1.fa
work/5e/b0d808b60f1b03081761f46c73af87/AF188126.1.fa
work/02/f34d60eceedd044a83a6a73a5f845f/comm.txt
work/0e/c6a838432c8f03a0fa1fde73549ac5/AF002815.1.fa
work/d1/42838716c2d3b67c9ee021f4ff2b20/AX244966.1.fa
work/d1/42838716c2d3b67c9ee021f4ff2b20/AX244966.1.fa.small.fa
work/de/1ae23609379fce91839fe3246ab292/AX244968.1.fa
work/de/30386051a8d956814f8c00e0138269/AX244961.1.fa
work/de/30386051a8d956814f8c00e0138269/AX244961.1.fa.small.fa
work/de/89c23e643b0952d599bad01f5508e5/AX244965.1.fa
work/ac/889f489e5a8e37397e2d50d74d0c1d/AX244964.1.fa.small.fa
work/ac/889f489e5a8e37397e2d50d74d0c1d/AX244964.1.fa
work/92/f86f69193d412611265b9d9a9fe761/AX244963.1.fa
work/64/1e5dddc43d5fe7054a36c17bd3efbe/AF004836.1.fa
work/4a/d7f740e7e90a48f48ceb4b328f460c/AX244967.1.fa.small.fa
work/4a/d7f740e7e90a48f48ceb4b328f460c/AX244967.1.fa
work/4a/64ff0a9b55fbbc8f7473c014159adf/AX244964.1.fa
work/7c/53193bf132edea9e635735bea81e54/AX244961.1.fa
work/28/521a89d3b10249361ec342f399cb2b/AX244965.1.fa.small.fa
work/28/521a89d3b10249361ec342f399cb2b/AX244965.1.fa
work/e9/6843c17d8743345d1fea4f76a493eb/comm.txt
work/06/3bdcf61b16b938aa826bd6c1fb5c70/AF002816.1.fa
work/68/cf70d643cf2bc0fb6666fa7bc800ee/AX244968.1.fa
work/68/cf70d643cf2bc0fb6666fa7bc800ee/AX244968.1.fa.small.fa
work/fd/a2db2223b8de9cd6beac895b01f011/NM_017590.5.fa
work/fd/ec3b831cab3af7562a9526d67d73e6/comm.txt
work/53/2bc036761253ee8a82a74a4051b872/AX244963.1.fa
work/53/2bc036761253ee8a82a74a4051b872/AX244963.1.fa.small.fa
work/f1/385af9daa0fbb85533a2be494ae243/list1.acns.txt.sorted.txt
work/f1/385af9daa0fbb85533a2be494ae243/list1.acns.txt
work/dd/eb5b0def1dd8d333a774c762e44d2c/list3.acns.txt
work/dd/eb5b0def1dd8d333a774c762e44d2c/list3.acns.txt.sorted.txt
work/70/44e73797949c29a8d5247e91daed2d/AY116592.1.fa
work/b1/590f9c672357466707dcd17ab2a63a/AX244962.1.fa
work/3f/158524dfdec68cc9991fc474adf305/comm.txt
work/20/fd7a569ef8c5f7ed4e0c3feb256c55/table.csv
work/20/fd7a569ef8c5f7ed4e0c3feb256c55/distcint.acns.txt
work/b3/ef8b23870cd7bba18d8fa9eb79b97f/list2.acns.txt.sorted.txt
work/b3/ef8b23870cd7bba18d8fa9eb79b97f/list2.acns.txt
work/01/c8993c5e2a0346ec81092c20bbac9c/comm.txt
work/34/1ee48c91ac62a85f81b97b8ce2c46a/AF188126.1.fa
work/08/bff07a134f724caf43a4afb688ccaa/NM_017590.5.fa
```



## Workflow

![Workflow](flowchart.png)


## Trace

```
task_id	hash	native_id	name	status	exit	submit	duration	realtime	%cpu	rss	vmem	rchar	wchar
3	b3/ef8b23	7741	sortAcns (sorting list2.acns.txt)	COMPLETED	0	2018-11-02 16:11:40.192	441ms	38ms	0.0%	0	0	0	0
1	dd/eb5b0d	7731	sortAcns (sorting list3.acns.txt)	COMPLETED	0	2018-11-02 16:11:40.066	816ms	33ms	0.0%	0	0	0	0
2	93/b5c456	7855	sortAcns (sorting list4.acns.txt)	COMPLETED	0	2018-11-02 16:11:40.692	585ms	47ms	0.0%	0	0	0	0
4	f1/385af9	7886	sortAcns (sorting list1.acns.txt)	COMPLETED	0	2018-11-02 16:11:40.911	489ms	59ms	0.0%	0	0	0	0
5	01/c8993c	7977	commonAcns (comm list2.acns.txt vs list3.acns.txt)	COMPLETED	0	2018-11-02 16:11:41.315	457ms	53ms	0.0%	0	0	0	0
6	e9/6843c1	8102	commonAcns (comm list3.acns.txt vs list4.acns.txt)	COMPLETED	0	2018-11-02 16:11:41.803	124ms	52ms	-	-	-	-	-
7	3f/158524	8000	commonAcns (comm list2.acns.txt vs list4.acns.txt)	COMPLETED	0	2018-11-02 16:11:41.440	558ms	28ms	0.0%	0	0	0	0
9	ba/d943b9	8130	commonAcns (comm list1.acns.txt vs list2.acns.txt)	COMPLETED	0	2018-11-02 16:11:41.955	383ms	56ms	0.0%	0	0	0	0
10	02/f34d60	8148	commonAcns (comm list1.acns.txt vs list4.acns.txt)	COMPLETED	0	2018-11-02 16:11:42.040	389ms	43ms	0.0%	0	0	0	0
8	fd/ec3b83	8249	commonAcns (comm list1.acns.txt vs list3.acns.txt)	COMPLETED	0	2018-11-02 16:11:42.341	338ms	48ms	0.0%	0	0	0	0
11	20/fd7a56	8309	listCommons (common list size: 6)	COMPLETED	0	2018-11-02 16:11:42.693	395ms	63ms	0.0%	0	0	0	0
12	b0/298913	8450	eachAcn (dowloading AF002815.1)	COMPLETED	0	2018-11-02 16:11:43.122	612ms	530ms	0.0%	7 MB	13.6 MB	50.8 KB	1.2 KB
13	0e/c6a838	8587	filterSize (size for AF002815.1.fa)	COMPLETED	0	2018-11-02 16:11:43.761	388ms	37ms	0.0%	0	0	0	0
14	06/3bdcf6	8588	eachAcn (dowloading AF002816.1)	COMPLETED	0	2018-11-02 16:11:43.775	818ms	521ms	0.0%	7.4 MB	13.6 MB	45.9 KB	778 B
16	fb/70a72f	8797	filterSize (size for AF002816.1.fa)	COMPLETED	0	2018-11-02 16:11:44.658	324ms	30ms	0.0%	0	0	0	0
15	23/f783de	8789	eachAcn (dowloading AF004836.1)	COMPLETED	0	2018-11-02 16:11:44.606	636ms	519ms	0.0%	7.1 MB	13.6 MB	50.8 KB	1.2 KB
17	64/1e5ddd	8990	filterSize (size for AF004836.1.fa)	COMPLETED	0	2018-11-02 16:11:45.266	366ms	42ms	0.0%	0	0	0	0
18	5e/b0d808	9008	eachAcn (dowloading AF188126.1)	COMPLETED	0	2018-11-02 16:11:45.319	5.9s	944ms	0.0%	7.4 MB	13.6 MB	50.8 KB	1.2 KB
19	34/1ee48c	9249	filterSize (size for AF188126.1.fa)	COMPLETED	0	2018-11-02 16:11:51.263	359ms	42ms	0.0%	0	0	0	0
20	ef/9bc628	9250	eachAcn (dowloading AF188530.1)	COMPLETED	0	2018-11-02 16:11:51.266	577ms	482ms	0.0%	7.3 MB	13.6 MB	50.8 KB	1.2 KB
21	d7/6c060d	9461	filterSize (size for AF188530.1.fa)	COMPLETED	0	2018-11-02 16:11:51.870	302ms	30ms	0.0%	0	0	0	0
22	7c/53193b	9450	eachAcn (dowloading AX244961.1)	COMPLETED	0	2018-11-02 16:11:51.851	546ms	500ms	0.0%	7.3 MB	13.6 MB	50.8 KB	1.2 KB
24	de/303860	9651	filterSize (size for AX244961.1.fa)	COMPLETED	0	2018-11-02 16:11:52.403	378ms	42ms	0.0%	0	0	0	0
23	b1/590f9c	9652	eachAcn (dowloading AX244962.1)	COMPLETED	0	2018-11-02 16:11:52.420	523ms	464ms	0.0%	7.5 MB	13.6 MB	50.8 KB	1.2 KB
25	57/1daa35	9923	filterSize (size for AX244962.1.fa)	COMPLETED	0	2018-11-02 16:11:52.971	446ms	68ms	0.0%	0	0	0	0
26	92/f86f69	9922	eachAcn (dowloading AX244963.1)	COMPLETED	0	2018-11-02 16:11:52.951	882ms	532ms	0.0%	7.4 MB	13.6 MB	50.5 KB	904 B
28	4a/64ff0a	10208	eachAcn (dowloading AX244964.1)	COMPLETED	0	2018-11-02 16:11:53.843	639ms	486ms	0.0%	7.3 MB	13.6 MB	50.8 KB	1.2 KB
29	53/2bc036	10595	filterSize (size for AX244963.1.fa)	COMPLETED	0	2018-11-02 16:11:54.505	241ms	14ms	0.0%	0	0	0	0
27	3c/8d29bd	10066	pairwise_align (pairwise /home/lindenb/src/tuto-nextflow/0190_stdout/work/de/30386051a8d956814f8c00e0138269/AX244961.1.fa.small.fa vs /home/lindenb/src/tuto-nextflow/0190_stdout/work/57/1daa35cf86c04625bd03818a4b2ac0/AX244962.1.fa.small.fa)	COMPLETED	0	2018-11-02 16:11:53.434	6.2s	1.1s	21.2%	30 MB	90.1 MB	1.2 MB	666 B
31	ac/889f48	10885	filterSize (size for AX244964.1.fa)	COMPLETED	0	2018-11-02 16:11:59.606	224ms	27ms	0.0%	0	0	0	0
30	de/89c23e	10691	eachAcn (dowloading AX244965.1)	COMPLETED	0	2018-11-02 16:11:54.770	5.6s	501ms	0.0%	7.2 MB	13.6 MB	50.5 KB	904 B
32	44/3d1ad3	10950	pairwise_align (pairwise /home/lindenb/src/tuto-nextflow/0190_stdout/work/de/30386051a8d956814f8c00e0138269/AX244961.1.fa.small.fa vs /home/lindenb/src/tuto-nextflow/0190_stdout/work/53/2bc036761253ee8a82a74a4051b872/AX244963.1.fa.small.fa)	COMPLETED	0	2018-11-02 16:11:59.834	5.8s	590ms	68.4%	29.9 MB	90.1 MB	1.2 MB	1 KB
33	28/521a89	11483	filterSize (size for AX244965.1.fa)	COMPLETED	0	2018-11-02 16:12:05.625	246ms	45ms	0.0%	0	0	0	0
34	21/fb87fe	11165	eachAcn (dowloading AX244966.1)	COMPLETED	0	2018-11-02 16:12:00.374	5.6s	483ms	0.0%	7.3 MB	13.6 MB	50.5 KB	904 B
36	d1/428387	11550	filterSize (size for AX244966.1.fa)	COMPLETED	0	2018-11-02 16:12:05.964	109ms	19ms	-	-	-	-	-
35	a8/f0d264	11555	eachAcn (dowloading AX244967.1)	COMPLETED	0	2018-11-02 16:12:05.978	5.6s	1.8s	0.0%	7.3 MB	13.6 MB	45.9 KB	444 B
37	4a/d7f740	11775	filterSize (size for AX244967.1.fa)	COMPLETED	0	2018-11-02 16:12:11.558	320ms	81ms	0.0%	0	0	0	0
38	de/1ae236	11776	eachAcn (dowloading AX244968.1)	COMPLETED	0	2018-11-02 16:12:11.566	5.6s	504ms	0.0%	7.3 MB	13.6 MB	50.8 KB	1.2 KB
39	68/cf70d6	12009	filterSize (size for AX244968.1.fa)	COMPLETED	0	2018-11-02 16:12:17.164	235ms	43ms	0.0%	0	0	0	0
40	ef/1938ff	12010	eachAcn (dowloading AY116592.1)	COMPLETED	0	2018-11-02 16:12:17.166	5.5s	468ms	0.0%	7.4 MB	13.6 MB	50.8 KB	1.2 KB
41	70/44e737	12266	filterSize (size for AY116592.1.fa)	COMPLETED	0	2018-11-02 16:12:22.676	255ms	28ms	0.0%	0	0	0	0
42	08/bff07a	12267	eachAcn (dowloading NM_017590.5)	COMPLETED	0	2018-11-02 16:12:22.685	5.6s	573ms	0.0%	7.2 MB	13.6 MB	50.8 KB	1.2 KB
43	fd/a2db22	12523	filterSize (size for NM_017590.5.fa)	COMPLETED	0	2018-11-02 16:12:28.253	306ms	67ms	0.0%	0	0	0	0
```

