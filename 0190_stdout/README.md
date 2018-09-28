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
N E X T F L O W  ~  version 0.32.0
Launching `workflow.nf` [exotic_snyder] - revision: 5d1f992d42
[warm up] executor > local
[80/c25e36] Cached process > sortAcns (sorting list2.acns.txt)
[84/9240ae] Cached process > sortAcns (sorting list3.acns.txt)
[c7/57fc6e] Cached process > sortAcns (sorting list1.acns.txt)
[20/4c93a7] Cached process > sortAcns (sorting list4.acns.txt)
[b0/285256] Cached process > commonAcns (comm list1.acns.txt vs list4.acns.txt)
[d8/63d308] Cached process > commonAcns (comm list3.acns.txt vs list4.acns.txt)
[1b/687add] Cached process > commonAcns (comm list2.acns.txt vs list4.acns.txt)
[8c/39f042] Cached process > commonAcns (comm list1.acns.txt vs list2.acns.txt)
[f2/4271c8] Cached process > commonAcns (comm list2.acns.txt vs list3.acns.txt)
[6c/028942] Cached process > commonAcns (comm list1.acns.txt vs list3.acns.txt)
[f7/4683dc] Cached process > listCommons (common list size: 6)
[dc/383cf6] Cached process > eachAcn (dowloading AF002815.1)
[18/0a92a1] Cached process > filterSize (size for AF002815.1.fa)
[c1/077b3a] Cached process > eachAcn (dowloading AF002816.1)
[0e/5f7fc1] Cached process > filterSize (size for AF002816.1.fa)
[1e/dfc74a] Cached process > eachAcn (dowloading AF004836.1)
[fc/02bb98] Cached process > filterSize (size for AF004836.1.fa)
[65/6050ff] Cached process > eachAcn (dowloading AF188126.1)
[7e/2959b3] Cached process > eachAcn (dowloading AF188530.1)
[57/470ee9] Cached process > eachAcn (dowloading AX244961.1)
[d5/0648c1] Cached process > filterSize (size for AF188126.1.fa)
[53/5207bd] Cached process > eachAcn (dowloading AX244962.1)
[8a/393846] Cached process > eachAcn (dowloading AX244963.1)
[ca/de4d41] Cached process > eachAcn (dowloading AX244964.1)
[72/6650bd] Cached process > eachAcn (dowloading AX244965.1)
[cc/10b2de] Cached process > filterSize (size for AF188530.1.fa)
[9c/f2f4ff] Cached process > filterSize (size for AX244961.1.fa)
[10/cd2069] Cached process > filterSize (size for AX244963.1.fa)
[22/374b5b] Cached process > eachAcn (dowloading AX244966.1)
[4c/caeb92] Cached process > filterSize (size for AX244962.1.fa)
[8d/2ac532] Cached process > filterSize (size for AX244964.1.fa)
[cd/d93e41] Cached process > pairwise_align (pairwise /comptes/lindenbaum-p/src/tuto-nextflow/0190_stdout/work/9c/f2f4ff136ff6124d47b36eca93533c/AX244961.1.fa.small.fa vs /comptes/lindenbaum-p/src/tuto-nextflow/0190_stdout/work/10/cd20698679264eb9a6e081de9ea2e8/AX244963.1.fa.small.fa)
I say..  /comptes/lindenbaum-p/src/tuto-nextflow/0190_stdout/work/9c/f2f4ff136ff6124d47b36eca93533c/AX244961.1.fa.small.fa,/comptes/lindenbaum-p/src/tuto-nextflow/0190_stdout/work/10/cd20698679264eb9a6e081de9ea2e8/AX244963.1.fa.small.fa,1.6e-05
[b6/6bc422] Cached process > filterSize (size for AX244965.1.fa)
[25/2b7d91] Cached process > eachAcn (dowloading AX244967.1)
[05/926e5c] Cached process > eachAcn (dowloading AX244968.1)
[9a/c4d3e9] Cached process > filterSize (size for AX244967.1.fa)
[18/d5eb64] Cached process > filterSize (size for AX244968.1.fa)
[45/437480] Cached process > eachAcn (dowloading AY116592.1)
[70/2fc702] Cached process > filterSize (size for AX244966.1.fa)
[6a/8cb162] Cached process > filterSize (size for AY116592.1.fa)
[c9/2e16e6] Cached process > eachAcn (dowloading NM_017590.5)
[03/dbce07] Cached process > filterSize (size for NM_017590.5.fa)
[ad/5ec7b0] Submitted process > pairwise_align (pairwise /comptes/lindenbaum-p/src/tuto-nextflow/0190_stdout/work/4c/caeb92547cdacb5502e77307986987/AX244962.1.fa.small.fa vs /comptes/lindenbaum-p/src/tuto-nextflow/0190_stdout/work/10/cd20698679264eb9a6e081de9ea2e8/AX244963.1.fa.small.fa)
I say..  /comptes/lindenbaum-p/src/tuto-nextflow/0190_stdout/work/4c/caeb92547cdacb5502e77307986987/AX244962.1.fa.small.fa,/comptes/lindenbaum-p/src/tuto-nextflow/0190_stdout/work/10/cd20698679264eb9a6e081de9ea2e8/AX244963.1.fa.small.fa,0.022
```


## Files

```
work/c7/57fc6e6b9e30441fe5b87bbe058d0c/list1.acns.txt
work/c7/57fc6e6b9e30441fe5b87bbe058d0c/list1.acns.txt.sorted.txt
work/80/c25e3605248c55395539d78c976ab7/list2.acns.txt
work/80/c25e3605248c55395539d78c976ab7/list2.acns.txt.sorted.txt
work/20/4c93a7fc717e66fcf728adbd7d146d/list4.acns.txt
work/20/4c93a7fc717e66fcf728adbd7d146d/list4.acns.txt.sorted.txt
work/84/9240ae31bdcb6d91e1e37fec201565/list3.acns.txt
work/84/9240ae31bdcb6d91e1e37fec201565/list3.acns.txt.sorted.txt
work/1b/687add4b989ee70f3231145e7dbef9/comm.txt
work/b0/285256252ddac28d2495c8e4b567c2/comm.txt
work/d8/63d30874cf6f81410f8f7ad52ef507/comm.txt
work/8c/39f042116e3263704f2279fe22be31/comm.txt
work/f2/4271c87f6e5652934ee6f314eb6506/comm.txt
work/6c/028942ffc101d4e7bebf50e0a8411b/comm.txt
work/f7/4683dc3a66cf96a669cd14a5c18983/table.csv
work/f7/4683dc3a66cf96a669cd14a5c18983/distcint.acns.txt
work/dc/383cf6cf72aa931d5849e7f1bf4cfa/AF002815.1.fa
work/c1/077b3a5002a619ca7d238cec295127/AF002816.1.fa
work/18/0a92a12c129369e4b130991eba86fa/AF002815.1.fa
work/18/d5eb64e30adfb9a75a8d3989a93aef/AX244968.1.fa
work/18/d5eb64e30adfb9a75a8d3989a93aef/AX244968.1.fa.small.fa
work/1e/dfc74a517de10483762eba7bb4b5a1/AF004836.1.fa
work/0e/5f7fc17af2aac5098be34fde2add88/AF002816.1.fa
work/fc/02bb983c6faf953a283d1381d2369a/AF004836.1.fa
work/65/6050fffd725106ac3f2b11cc764aa9/AF188126.1.fa
work/d5/0648c1de89a249479c44a62490986e/AF188126.1.fa
work/7e/2959b3a5216e251fc7ee32667ff4fd/AF188530.1.fa
work/cc/10b2dec9132bea44ebb1b6acebb5c0/AF188530.1.fa
work/57/470ee99ba1f86448aa00c1fdb46d4c/AX244961.1.fa
work/53/5207bd0a14c9bd1c5ef63272b0d37c/AX244962.1.fa
work/9c/f2f4ff136ff6124d47b36eca93533c/AX244961.1.fa
work/9c/f2f4ff136ff6124d47b36eca93533c/AX244961.1.fa.small.fa
work/4c/caeb92547cdacb5502e77307986987/AX244962.1.fa
work/4c/caeb92547cdacb5502e77307986987/AX244962.1.fa.small.fa
work/8a/393846c4fd24100586490cfab61ad9/AX244963.1.fa
work/ca/de4d41892fe6e27b7ec4776964f9ba/AX244964.1.fa
work/10/cd20698679264eb9a6e081de9ea2e8/AX244963.1.fa
work/10/cd20698679264eb9a6e081de9ea2e8/AX244963.1.fa.small.fa
work/8d/2ac53247549d17f9fa2d47b04b4076/AX244964.1.fa
work/8d/2ac53247549d17f9fa2d47b04b4076/AX244964.1.fa.small.fa
work/72/6650bdbd0496f5d2c9590dbfc7b85a/AX244965.1.fa
work/22/374b5b7980c2406c25323243e4d159/AX244966.1.fa
work/b6/6bc4221c4e964a8de0190b5f416111/AX244965.1.fa
work/b6/6bc4221c4e964a8de0190b5f416111/AX244965.1.fa.small.fa
work/70/2fc7022b5c7d0fcd80a04af5c082c3/AX244966.1.fa
work/70/2fc7022b5c7d0fcd80a04af5c082c3/AX244966.1.fa.small.fa
work/25/2b7d915a4f873cd199c8beca8a825f/AX244967.1.fa
work/05/926e5caba179ef7da1e78d1e73c8a0/AX244968.1.fa
work/9a/c4d3e92787c6c57ab0ceea86ffc2c7/AX244967.1.fa
work/9a/c4d3e92787c6c57ab0ceea86ffc2c7/AX244967.1.fa.small.fa
work/45/437480545da28c4eeac9f186d2f455/AY116592.1.fa
work/c9/2e16e60503912b07ddac55dad4448c/NM_017590.5.fa
work/6a/8cb16277d68da1746565e3453af3a9/AY116592.1.fa
work/03/dbce073aea42d2150bde87788b52ee/NM_017590.5.fa
```



## Workflow

![Workflow](flowchart.png)


## Trace

```
task_id	hash	native_id	name	status	exit	submit	duration	realtime	%cpu	rss	vmem	rchar	wchar
1	c7/57fc6e	29913	sortAcns (sorting list1.acns.txt)	CACHED	0	2018-09-28 16:08:01.413	580ms	85ms	0.0%	0	0	0	0
3	80/c25e36	29898	sortAcns (sorting list2.acns.txt)	CACHED	0	2018-09-28 16:08:01.332	568ms	59ms	0.0%	0	0	0	0
4	20/4c93a7	29901	sortAcns (sorting list4.acns.txt)	CACHED	0	2018-09-28 16:08:01.373	580ms	50ms	0.0%	0	0	0	0
2	84/9240ae	29906	sortAcns (sorting list3.acns.txt)	CACHED	0	2018-09-28 16:08:01.389	596ms	88ms	0.0%	0	0	0	0
8	b0/285256	30205	commonAcns (comm list1.acns.txt vs list4.acns.txt)	CACHED	0	2018-09-28 16:08:02.018	475ms	30ms	0.0%	0	0	0	0
6	d8/63d308	30207	commonAcns (comm list3.acns.txt vs list4.acns.txt)	CACHED	0	2018-09-28 16:08:02.029	363ms	33ms	0.0%	0	0	0	0
5	1b/687add	30199	commonAcns (comm list2.acns.txt vs list4.acns.txt)	CACHED	0	2018-09-28 16:08:01.976	386ms	30ms	0.0%	0	0	0	0
7	8c/39f042	30216	commonAcns (comm list1.acns.txt vs list2.acns.txt)	CACHED	0	2018-09-28 16:08:02.066	335ms	24ms	0.0%	0	0	0	0
9	f2/4271c8	30461	commonAcns (comm list2.acns.txt vs list3.acns.txt)	CACHED	0	2018-09-28 16:08:02.378	388ms	19ms	0.0%	0	0	0	0
10	6c/028942	30464	commonAcns (comm list1.acns.txt vs list3.acns.txt)	CACHED	0	2018-09-28 16:08:02.411	317ms	15ms	0.0%	0	0	0	0
11	f7/4683dc	30603	listCommons (common list size: 6)	CACHED	0	2018-09-28 16:08:02.788	410ms	48ms	0.0%	0	0	0	0
12	dc/383cf6	30740	eachAcn (dowloading AF002815.1)	CACHED	0	2018-09-28 16:08:03.225	727ms	498ms	0.0%	8.6 MB	50 MB	83.9 KB	682 B
14	18/0a92a1	30879	filterSize (size for AF002815.1.fa)	CACHED	0	2018-09-28 16:08:03.981	390ms	23ms	0.0%	0	0	0	0
13	c1/077b3a	30878	eachAcn (dowloading AF002816.1)	CACHED	0	2018-09-28 16:08:03.975	696ms	478ms	0.0%	7.4 MB	50 MB	83.9 KB	682 B
16	0e/5f7fc1	31153	filterSize (size for AF002816.1.fa)	CACHED	0	2018-09-28 16:08:04.708	406ms	26ms	0.0%	0	0	0	0
15	1e/dfc74a	31151	eachAcn (dowloading AF004836.1)	CACHED	0	2018-09-28 16:08:04.687	672ms	475ms	0.0%	8.8 MB	50 MB	88.8 KB	1.1 KB
18	65/6050ff	31422	eachAcn (dowloading AF188126.1)	CACHED	0	2018-09-28 16:08:05.393	685ms	471ms	0.0%	8.7 MB	50 MB	83.9 KB	682 B
17	fc/02bb98	31421	filterSize (size for AF004836.1.fa)	CACHED	0	2018-09-28 16:08:05.385	299ms	25ms	0.0%	0	0	0	0
20	7e/2959b3	31623	eachAcn (dowloading AF188530.1)	CACHED	0	2018-09-28 16:08:06.107	682ms	487ms	0.0%	8.6 MB	50.1 MB	88.8 KB	1.1 KB
22	57/470ee9	31920	eachAcn (dowloading AX244961.1)	CACHED	0	2018-09-28 16:08:06.819	695ms	483ms	0.0%	8.6 MB	50 MB	83.9 KB	682 B
19	d5/0648c1	31622	filterSize (size for AF188126.1.fa)	CACHED	0	2018-09-28 16:08:06.098	435ms	35ms	0.0%	0	0	0	0
24	53/5207bd	32120	eachAcn (dowloading AX244962.1)	CACHED	0	2018-09-28 16:08:07.529	702ms	507ms	0.0%	8.7 MB	50 MB	88.8 KB	1.1 KB
25	8a/393846	32346	eachAcn (dowloading AX244963.1)	CACHED	0	2018-09-28 16:08:08.265	663ms	510ms	0.0%	8.6 MB	50 MB	88.8 KB	1.1 KB
28	ca/de4d41	32647	eachAcn (dowloading AX244964.1)	CACHED	0	2018-09-28 16:08:08.943	698ms	501ms	0.0%	8.6 MB	50.1 MB	88.8 KB	1.1 KB
32	72/6650bd	653	eachAcn (dowloading AX244965.1)	CACHED	0	2018-09-28 16:08:09.664	693ms	484ms	0.0%	8.7 MB	50 MB	88.8 KB	1.1 KB
21	cc/10b2de	31919	filterSize (size for AF188530.1.fa)	CACHED	0	2018-09-28 16:08:06.806	275ms	23ms	0.0%	0	0	0	0
23	9c/f2f4ff	32121	filterSize (size for AX244961.1.fa)	CACHED	0	2018-09-28 16:08:07.536	343ms	29ms	0.0%	0	0	0	0
29	10/cd2069	32649	filterSize (size for AX244963.1.fa)	CACHED	0	2018-09-28 16:08:08.950	316ms	39ms	0.0%	0	0	0	0
26	4c/caeb92	32345	filterSize (size for AX244962.1.fa)	CACHED	0	2018-09-28 16:08:08.255	353ms	27ms	0.0%	0	0	0	0
33	22/374b5b	1179	eachAcn (dowloading AX244966.1)	CACHED	0	2018-09-28 16:08:10.377	701ms	483ms	0.0%	8.5 MB	50 MB	83.9 KB	682 B
31	8d/2ac532	644	filterSize (size for AX244964.1.fa)	CACHED	0	2018-09-28 16:08:09.655	464ms	39ms	0.0%	0	0	0	0
30	cd/d93e41	513	pairwise_align (pairwise /comptes/lindenbaum-p/src/tuto-nextflow/0190_stdout/work/9c/f2f4ff136ff6124d47b36eca93533c/AX244961.1.fa.small.fa vs /comptes/lindenbaum-p/src/tuto-nextflow/0190_stdout/work/10/cd20698679264eb9a6e081de9ea2e8/AX244963.1.fa.small.fa)	CACHED	0	2018-09-28 16:08:09.450	887ms	394ms	0.0%	3 MB	16.6 MB	57.1 KB	366 B
34	b6/6bc422	1180	filterSize (size for AX244965.1.fa)	CACHED	0	2018-09-28 16:08:10.384	326ms	38ms	0.0%	0	0	0	0
36	25/2b7d91	1571	eachAcn (dowloading AX244967.1)	CACHED	0	2018-09-28 16:08:11.096	743ms	499ms	0.0%	8.7 MB	50 MB	83.9 KB	682 B
38	05/926e5c	1873	eachAcn (dowloading AX244968.1)	CACHED	0	2018-09-28 16:08:11.856	713ms	475ms	0.0%	7.4 MB	50 MB	83.9 KB	682 B
37	9a/c4d3e9	1875	filterSize (size for AX244967.1.fa)	CACHED	0	2018-09-28 16:08:11.865	287ms	36ms	0.0%	0	0	0	0
39	18/d5eb64	2082	filterSize (size for AX244968.1.fa)	CACHED	0	2018-09-28 16:08:12.583	463ms	49ms	0.0%	0	0	0	0
40	45/437480	2083	eachAcn (dowloading AY116592.1)	CACHED	0	2018-09-28 16:08:12.589	702ms	485ms	0.0%	8.9 MB	50 MB	83.9 KB	682 B
35	70/2fc702	1570	filterSize (size for AX244966.1.fa)	CACHED	0	2018-09-28 16:08:11.089	287ms	32ms	0.0%	0	0	0	0
42	6a/8cb162	2358	filterSize (size for AY116592.1.fa)	CACHED	0	2018-09-28 16:08:13.309	273ms	24ms	0.0%	0	0	0	0
41	c9/2e16e6	2357	eachAcn (dowloading NM_017590.5)	CACHED	0	2018-09-28 16:08:13.304	677ms	477ms	0.0%	8.7 MB	50 MB	83.9 KB	683 B
43	03/dbce07	2558	filterSize (size for NM_017590.5.fa)	CACHED	0	2018-09-28 16:08:13.998	263ms	21ms	0.0%	0	0	0	0
34	ad/5ec7b0	5773	pairwise_align (pairwise /comptes/lindenbaum-p/src/tuto-nextflow/0190_stdout/work/4c/caeb92547cdacb5502e77307986987/AX244962.1.fa.small.fa vs /comptes/lindenbaum-p/src/tuto-nextflow/0190_stdout/work/10/cd20698679264eb9a6e081de9ea2e8/AX244963.1.fa.small.fa)	COMPLETED	0	2018-09-28 16:10:34.467	803ms	445ms	8.8%	13.8 MB	255.3 MB	534.6 KB	1.8 KB
```

