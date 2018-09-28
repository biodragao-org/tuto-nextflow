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
N E X T F L O W  ~  version 0.32.0
Launching `workflow.nf` [goofy_picasso] - revision: 5a86ad5e38
[warm up] executor > local
[c7/57fc6e] Submitted process > sortAcns (sorting list1.acns.txt)
[80/c25e36] Submitted process > sortAcns (sorting list2.acns.txt)
[84/9240ae] Submitted process > sortAcns (sorting list3.acns.txt)
[20/4c93a7] Submitted process > sortAcns (sorting list4.acns.txt)
[ab/3f214f] Submitted process > commonAcns (comm list2.acns.txt vs list3.acns.txt)
[50/ecda9a] Submitted process > commonAcns (comm list1.acns.txt vs list3.acns.txt)
[b9/1378d7] Submitted process > commonAcns (comm list3.acns.txt vs list4.acns.txt)
[e6/369d1b] Submitted process > commonAcns (comm list1.acns.txt vs list2.acns.txt)
[7a/dc8a74] Submitted process > commonAcns (comm list1.acns.txt vs list4.acns.txt)
[07/65edf5] Submitted process > commonAcns (comm list2.acns.txt vs list4.acns.txt)
[47/58f0f2] Submitted process > listCommons (common list size: 6)
[dc/383cf6] Submitted process > eachAcn (dowloading AF002815.1)
[c1/077b3a] Submitted process > eachAcn (dowloading AF002816.1)
[77/8a0a91] Submitted process > filterSize (size for AF002815.1.fa)
[1e/dfc74a] Submitted process > eachAcn (dowloading AF004836.1)
[fc/ab9f71] Submitted process > filterSize (size for AF002816.1.fa)
[65/6050ff] Submitted process > eachAcn (dowloading AF188126.1)
[42/cbe5bf] Submitted process > filterSize (size for AF004836.1.fa)
[7e/2959b3] Submitted process > eachAcn (dowloading AF188530.1)
[e7/92bf2c] Submitted process > filterSize (size for AF188126.1.fa)
[57/470ee9] Submitted process > eachAcn (dowloading AX244961.1)
[67/942d69] Submitted process > filterSize (size for AF188530.1.fa)
[67/53b150] Submitted process > filterSize (size for AX244961.1.fa)
[53/5207bd] Submitted process > eachAcn (dowloading AX244962.1)
[8a/393846] Submitted process > eachAcn (dowloading AX244963.1)
[fb/22313e] Submitted process > filterSize (size for AX244962.1.fa)
[ca/de4d41] Submitted process > eachAcn (dowloading AX244964.1)
[ae/58fc6b] Submitted process > filterSize (size for AX244963.1.fa)
[d6/013e29] Submitted process > filterSize (size for AX244964.1.fa)
[72/6650bd] Submitted process > eachAcn (dowloading AX244965.1)
[22/374b5b] Submitted process > eachAcn (dowloading AX244966.1)
[2b/8761a6] Submitted process > filterSize (size for AX244965.1.fa)
[25/2b7d91] Submitted process > eachAcn (dowloading AX244967.1)
[52/4f8c94] Submitted process > filterSize (size for AX244966.1.fa)
[05/926e5c] Submitted process > eachAcn (dowloading AX244968.1)
[b9/81bfb7] Submitted process > filterSize (size for AX244967.1.fa)
[45/437480] Submitted process > eachAcn (dowloading AY116592.1)
[61/c07799] Submitted process > filterSize (size for AX244968.1.fa)
[c9/2e16e6] Submitted process > eachAcn (dowloading NM_017590.5)
[2a/4e0ec6] Submitted process > filterSize (size for AY116592.1.fa)
[5f/83a6b3] Submitted process > filterSize (size for NM_017590.5.fa)
```


## Files

```
work/20/4c93a7fc717e66fcf728adbd7d146d/list4.acns.txt
work/20/4c93a7fc717e66fcf728adbd7d146d/list4.acns.txt.sorted.txt
work/c7/57fc6e6b9e30441fe5b87bbe058d0c/list1.acns.txt
work/c7/57fc6e6b9e30441fe5b87bbe058d0c/list1.acns.txt.sorted.txt
work/80/c25e3605248c55395539d78c976ab7/list2.acns.txt
work/80/c25e3605248c55395539d78c976ab7/list2.acns.txt.sorted.txt
work/84/9240ae31bdcb6d91e1e37fec201565/list3.acns.txt
work/84/9240ae31bdcb6d91e1e37fec201565/list3.acns.txt.sorted.txt
work/ab/3f214f955d53bd03e2177520dad847/comm.txt
work/50/ecda9a4b3c025225d2fe787e8aa38c/comm.txt
work/b9/1378d72482787f56f1317eb829c1fb/comm.txt
work/b9/81bfb7de259070c4a8de2587869d99/AX244967.1.fa
work/b9/81bfb7de259070c4a8de2587869d99/AX244967.1.fa.small.fa
work/e6/369d1b88ba7e0feff4d27f4072fb64/comm.txt
work/7a/dc8a74d5a2fb8c8599a702189fab48/comm.txt
work/07/65edf54cb7f3ad7c1ef926053461d3/comm.txt
work/47/58f0f2899a349f154029dbbf573dae/table.csv
work/47/58f0f2899a349f154029dbbf573dae/distcint.acns.txt
work/dc/383cf6cf72aa931d5849e7f1bf4cfa/AF002815.1.fa
work/c1/077b3a5002a619ca7d238cec295127/AF002816.1.fa
work/77/8a0a914a5bfba0a1160df904c5363e/AF002815.1.fa
work/1e/dfc74a517de10483762eba7bb4b5a1/AF004836.1.fa
work/fc/ab9f7135e280cc24833c7c26025b65/AF002816.1.fa
work/65/6050fffd725106ac3f2b11cc764aa9/AF188126.1.fa
work/42/cbe5bf56fb03e0d208a5e824135243/AF004836.1.fa
work/7e/2959b3a5216e251fc7ee32667ff4fd/AF188530.1.fa
work/e7/92bf2cac6b7591dbd65bca3f99d28d/AF188126.1.fa
work/57/470ee99ba1f86448aa00c1fdb46d4c/AX244961.1.fa
work/67/942d69dd29fcee2a8e61a7f1997bdb/AF188530.1.fa
work/67/53b15034ac08204bdfac52fdfde673/AX244961.1.fa
work/67/53b15034ac08204bdfac52fdfde673/AX244961.1.fa.small.fa
work/53/5207bd0a14c9bd1c5ef63272b0d37c/AX244962.1.fa
work/8a/393846c4fd24100586490cfab61ad9/AX244963.1.fa
work/fb/22313e01eb4d66c7b5f81d0fc2e58f/AX244962.1.fa
work/fb/22313e01eb4d66c7b5f81d0fc2e58f/AX244962.1.fa.small.fa
work/ca/de4d41892fe6e27b7ec4776964f9ba/AX244964.1.fa
work/ae/58fc6bc488b023d149b2c87faa0c13/AX244963.1.fa
work/ae/58fc6bc488b023d149b2c87faa0c13/AX244963.1.fa.small.fa
work/d6/013e29afd4d483304ea5a83b76b9c6/AX244964.1.fa
work/d6/013e29afd4d483304ea5a83b76b9c6/AX244964.1.fa.small.fa
work/72/6650bdbd0496f5d2c9590dbfc7b85a/AX244965.1.fa
work/2b/8761a6017feb301ad886d130546eae/AX244965.1.fa
work/2b/8761a6017feb301ad886d130546eae/AX244965.1.fa.small.fa
work/22/374b5b7980c2406c25323243e4d159/AX244966.1.fa
work/25/2b7d915a4f873cd199c8beca8a825f/AX244967.1.fa
work/52/4f8c9480dee211c79649ab3b84faa4/AX244966.1.fa
work/52/4f8c9480dee211c79649ab3b84faa4/AX244966.1.fa.small.fa
work/05/926e5caba179ef7da1e78d1e73c8a0/AX244968.1.fa
work/45/437480545da28c4eeac9f186d2f455/AY116592.1.fa
work/61/c077998b3992b6cb16c8310bc0c363/AX244968.1.fa
work/61/c077998b3992b6cb16c8310bc0c363/AX244968.1.fa.small.fa
work/c9/2e16e60503912b07ddac55dad4448c/NM_017590.5.fa
work/2a/4e0ec63fcc82ffec28e976a278c4f7/AY116592.1.fa
work/5f/83a6b3b57042d99a9adc31ada6eede/NM_017590.5.fa
```



## Workflow

![Workflow](flowchart.png)


## Trace

```tsv
task_id	hash	native_id	name	status	exit	submit	duration	realtime	%cpu	rss	vmem	rchar	wchar
3	84/9240ae	14589	sortAcns (sorting list3.acns.txt)	COMPLETED	0	2018-09-28 13:21:24.429	405ms	47ms	0.0%	0	0	0	0
1	c7/57fc6e	14583	sortAcns (sorting list1.acns.txt)	COMPLETED	0	2018-09-28 13:21:24.361	555ms	27ms	0.0%	0	0	0	0
2	80/c25e36	14586	sortAcns (sorting list2.acns.txt)	COMPLETED	0	2018-09-28 13:21:24.397	530ms	43ms	0.0%	0	0	0	0
4	20/4c93a7	14595	sortAcns (sorting list4.acns.txt)	COMPLETED	0	2018-09-28 13:21:24.442	497ms	37ms	0.0%	0	0	0	0
6	e6/369d1b	14864	commonAcns (comm list1.acns.txt vs list2.acns.txt)	COMPLETED	0	2018-09-28 13:21:24.990	367ms	49ms	0.0%	0	0	0	0
7	ab/3f214f	14859	commonAcns (comm list2.acns.txt vs list3.acns.txt)	COMPLETED	0	2018-09-28 13:21:24.962	453ms	49ms	0.0%	0	0	0	0
5	50/ecda9a	14860	commonAcns (comm list1.acns.txt vs list3.acns.txt)	COMPLETED	0	2018-09-28 13:21:24.971	499ms	41ms	0.0%	0	0	0	0
8	b9/1378d7	14861	commonAcns (comm list3.acns.txt vs list4.acns.txt)	COMPLETED	0	2018-09-28 13:21:24.980	498ms	50ms	0.0%	0	0	0	0
9	7a/dc8a74	15139	commonAcns (comm list1.acns.txt vs list4.acns.txt)	COMPLETED	0	2018-09-28 13:21:25.376	393ms	27ms	0.0%	0	0	0	0
10	07/65edf5	15146	commonAcns (comm list2.acns.txt vs list4.acns.txt)	COMPLETED	0	2018-09-28 13:21:25.430	348ms	36ms	0.0%	0	0	0	0
11	47/58f0f2	15259	listCommons (common list size: 6)	COMPLETED	0	2018-09-28 13:21:25.808	512ms	71ms	0.0%	0	0	0	0
12	dc/383cf6	15396	eachAcn (dowloading AF002815.1)	COMPLETED	0	2018-09-28 13:21:26.349	662ms	488ms	0.0%	8.6 MB	50.1 MB	88.8 KB	1.1 KB
14	77/8a0a91	15539	filterSize (size for AF002815.1.fa)	COMPLETED	0	2018-09-28 13:21:27.053	444ms	28ms	0.0%	0	0	0	0
13	c1/077b3a	15537	eachAcn (dowloading AF002816.1)	COMPLETED	0	2018-09-28 13:21:27.041	731ms	486ms	0.0%	7.4 MB	50.1 MB	83.9 KB	682 B
16	fc/ab9f71	15833	filterSize (size for AF002816.1.fa)	COMPLETED	0	2018-09-28 13:21:27.802	290ms	23ms	0.0%	0	0	0	0
15	1e/dfc74a	15830	eachAcn (dowloading AF004836.1)	COMPLETED	0	2018-09-28 13:21:27.787	623ms	483ms	0.0%	8.7 MB	50.1 MB	88.8 KB	1.1 KB
17	42/cbe5bf	16032	filterSize (size for AF004836.1.fa)	COMPLETED	0	2018-09-28 13:21:28.438	400ms	21ms	0.0%	0	0	0	0
18	65/6050ff	16031	eachAcn (dowloading AF188126.1)	COMPLETED	0	2018-09-28 13:21:28.429	654ms	475ms	0.0%	8.7 MB	50.1 MB	88.8 KB	1.1 KB
19	e7/92bf2c	16306	filterSize (size for AF188126.1.fa)	COMPLETED	0	2018-09-28 13:21:29.116	303ms	25ms	0.0%	0	0	0	0
20	7e/2959b3	16305	eachAcn (dowloading AF188530.1)	COMPLETED	0	2018-09-28 13:21:29.105	763ms	488ms	0.0%	7.4 MB	50.1 MB	83.9 KB	682 B
21	67/942d69	16507	filterSize (size for AF188530.1.fa)	COMPLETED	0	2018-09-28 13:21:29.902	307ms	24ms	0.0%	0	0	0	0
22	57/470ee9	16506	eachAcn (dowloading AX244961.1)	COMPLETED	0	2018-09-28 13:21:29.890	726ms	480ms	0.0%	7.5 MB	50 MB	83.9 KB	682 B
23	67/53b150	16707	filterSize (size for AX244961.1.fa)	COMPLETED	0	2018-09-28 13:21:30.635	277ms	34ms	0.0%	0	0	0	0
24	53/5207bd	16708	eachAcn (dowloading AX244962.1)	COMPLETED	0	2018-09-28 13:21:30.645	653ms	481ms	0.0%	8.5 MB	50 MB	88.8 KB	1.1 KB
25	fb/22313e	16914	filterSize (size for AX244962.1.fa)	COMPLETED	0	2018-09-28 13:21:31.318	493ms	38ms	0.0%	0	0	0	0
26	8a/393846	16913	eachAcn (dowloading AX244963.1)	COMPLETED	0	2018-09-28 13:21:31.311	757ms	477ms	0.0%	7.3 MB	50.1 MB	83.9 KB	682 B
28	ae/58fc6b	17208	filterSize (size for AX244963.1.fa)	COMPLETED	0	2018-09-28 13:21:32.098	362ms	33ms	0.0%	0	0	0	0
27	ca/de4d41	17207	eachAcn (dowloading AX244964.1)	COMPLETED	0	2018-09-28 13:21:32.087	711ms	487ms	0.0%	8.6 MB	50.1 MB	88.8 KB	1.1 KB
29	d6/013e29	17432	filterSize (size for AX244964.1.fa)	COMPLETED	0	2018-09-28 13:21:32.819	355ms	28ms	0.0%	0	0	0	0
30	72/6650bd	17433	eachAcn (dowloading AX244965.1)	COMPLETED	0	2018-09-28 13:21:32.829	743ms	497ms	0.0%	7.4 MB	50.1 MB	83.9 KB	682 B
32	2b/8761a6	17662	filterSize (size for AX244965.1.fa)	COMPLETED	0	2018-09-28 13:21:33.596	286ms	32ms	0.0%	0	0	0	0
31	22/374b5b	17661	eachAcn (dowloading AX244966.1)	COMPLETED	0	2018-09-28 13:21:33.586	738ms	482ms	0.0%	7.3 MB	50.1 MB	83.9 KB	682 B
33	52/4f8c94	17864	filterSize (size for AX244966.1.fa)	COMPLETED	0	2018-09-28 13:21:34.355	385ms	32ms	0.0%	0	0	0	0
34	25/2b7d91	17863	eachAcn (dowloading AX244967.1)	COMPLETED	0	2018-09-28 13:21:34.344	744ms	482ms	0.0%	7.3 MB	50.1 MB	83.9 KB	682 B
35	b9/81bfb7	18089	filterSize (size for AX244967.1.fa)	COMPLETED	0	2018-09-28 13:21:35.118	323ms	35ms	0.0%	0	0	0	0
36	05/926e5c	18088	eachAcn (dowloading AX244968.1)	COMPLETED	0	2018-09-28 13:21:35.106	762ms	504ms	0.0%	7.4 MB	50.1 MB	83.9 KB	682 B
37	61/c07799	18295	filterSize (size for AX244968.1.fa)	COMPLETED	0	2018-09-28 13:21:35.883	332ms	36ms	0.0%	0	0	0	0
38	45/437480	18294	eachAcn (dowloading AY116592.1)	COMPLETED	0	2018-09-28 13:21:35.878	741ms	481ms	0.0%	7.5 MB	50.1 MB	83.9 KB	682 B
39	2a/4e0ec6	18520	filterSize (size for AY116592.1.fa)	COMPLETED	0	2018-09-28 13:21:36.648	304ms	24ms	0.0%	0	0	0	0
40	c9/2e16e6	18519	eachAcn (dowloading NM_017590.5)	COMPLETED	0	2018-09-28 13:21:36.637	757ms	485ms	0.0%	7.3 MB	50.1 MB	83.9 KB	683 B
41	5f/83a6b3	18720	filterSize (size for NM_017590.5.fa)	COMPLETED	0	2018-09-28 13:21:37.405	318ms	25ms	0.0%	0	0	0	0
```

