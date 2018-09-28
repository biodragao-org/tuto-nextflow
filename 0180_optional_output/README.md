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
../bin/nextflow run -with-trace trace.tsv -with-report report.html -with-timeline timeline.html -with-dag flowchart.png workflow.nf --acns '../data/list*.acns.txt'
N E X T F L O W  ~  version 0.32.0
Launching `workflow.nf` [festering_shirley] - revision: 5a86ad5e38
[warm up] executor > local
[80/c25e36] Submitted process > sortAcns (sorting list2.acns.txt)
[84/9240ae] Submitted process > sortAcns (sorting list3.acns.txt)
[20/4c93a7] Submitted process > sortAcns (sorting list4.acns.txt)
[c7/57fc6e] Submitted process > sortAcns (sorting list1.acns.txt)
[51/8e9396] Submitted process > commonAcns (comm list2.acns.txt vs list3.acns.txt)
[a0/40f384] Submitted process > commonAcns (comm list3.acns.txt vs list4.acns.txt)
[9f/ea7cfe] Submitted process > commonAcns (comm list2.acns.txt vs list4.acns.txt)
[2e/5caa83] Submitted process > commonAcns (comm list1.acns.txt vs list4.acns.txt)
[e7/9538d1] Submitted process > commonAcns (comm list1.acns.txt vs list2.acns.txt)
[fc/dcb89b] Submitted process > commonAcns (comm list1.acns.txt vs list3.acns.txt)
[1b/dc99c8] Submitted process > listCommons (common list size: 6)
[dc/383cf6] Submitted process > eachAcn (dowloading AF002815.1)
[c1/077b3a] Submitted process > eachAcn (dowloading AF002816.1)
[5a/5ea9c5] Submitted process > filterSize (size for AF002815.1.fa)
[28/d8c8b4] Submitted process > filterSize (size for AF002816.1.fa)
[1e/dfc74a] Submitted process > eachAcn (dowloading AF004836.1)
[a8/3a107f] Submitted process > filterSize (size for AF004836.1.fa)
[65/6050ff] Submitted process > eachAcn (dowloading AF188126.1)
[7e/2959b3] Submitted process > eachAcn (dowloading AF188530.1)
[47/85de93] Submitted process > filterSize (size for AF188126.1.fa)
[57/470ee9] Submitted process > eachAcn (dowloading AX244961.1)
[b4/62e26f] Submitted process > filterSize (size for AF188530.1.fa)
[09/36b7b4] Submitted process > filterSize (size for AX244961.1.fa)
[53/5207bd] Submitted process > eachAcn (dowloading AX244962.1)
[8a/393846] Submitted process > eachAcn (dowloading AX244963.1)
[33/46eafd] Submitted process > filterSize (size for AX244962.1.fa)
[69/56928d] Submitted process > filterSize (size for AX244963.1.fa)
[ca/de4d41] Submitted process > eachAcn (dowloading AX244964.1)
[96/488f32] Submitted process > filterSize (size for AX244964.1.fa)
[72/6650bd] Submitted process > eachAcn (dowloading AX244965.1)
[22/374b5b] Submitted process > eachAcn (dowloading AX244966.1)
[6e/d42e07] Submitted process > filterSize (size for AX244965.1.fa)
[35/7482ed] Submitted process > filterSize (size for AX244966.1.fa)
[25/2b7d91] Submitted process > eachAcn (dowloading AX244967.1)
[05/926e5c] Submitted process > eachAcn (dowloading AX244968.1)
[11/7ca914] Submitted process > filterSize (size for AX244967.1.fa)
[45/437480] Submitted process > eachAcn (dowloading AY116592.1)
[15/0ac9e8] Submitted process > filterSize (size for AX244968.1.fa)
[c9/2e16e6] Submitted process > eachAcn (dowloading NM_017590.5)
[f3/41f268] Submitted process > filterSize (size for AY116592.1.fa)
[9d/003927] Submitted process > filterSize (size for NM_017590.5.fa)
```


## Files

```
work/80/c25e3605248c55395539d78c976ab7/list2.acns.txt
work/80/c25e3605248c55395539d78c976ab7/list2.acns.txt.sorted.txt
work/84/9240ae31bdcb6d91e1e37fec201565/list3.acns.txt
work/84/9240ae31bdcb6d91e1e37fec201565/list3.acns.txt.sorted.txt
work/20/4c93a7fc717e66fcf728adbd7d146d/list4.acns.txt
work/20/4c93a7fc717e66fcf728adbd7d146d/list4.acns.txt.sorted.txt
work/c7/57fc6e6b9e30441fe5b87bbe058d0c/list1.acns.txt
work/c7/57fc6e6b9e30441fe5b87bbe058d0c/list1.acns.txt.sorted.txt
work/51/8e9396799ff36496f674e2f1822840/comm.txt
work/a0/40f3847b15f9f8aaf267f83e0c100c/comm.txt
work/9f/ea7cfe5774ff7690e5e3df41831475/comm.txt
work/2e/5caa8372c5b8b4495eda3cdb5267de/comm.txt
work/e7/9538d1eedc63bf827e0f7592f880ed/comm.txt
work/fc/dcb89becf04ef9a0426279c0959ad8/comm.txt
work/1b/dc99c82de0678cf68e45d2c2ee04a3/table.csv
work/1b/dc99c82de0678cf68e45d2c2ee04a3/distcint.acns.txt
work/dc/383cf6cf72aa931d5849e7f1bf4cfa/AF002815.1.fa
work/c1/077b3a5002a619ca7d238cec295127/AF002816.1.fa
work/5a/5ea9c5ab294b150042414d4f47e735/AF002815.1.fa
work/28/d8c8b40ca9bfd0c845abe26c78129c/AF002816.1.fa
work/1e/dfc74a517de10483762eba7bb4b5a1/AF004836.1.fa
work/a8/3a107f900596b867282592b083a68d/AF004836.1.fa
work/65/6050fffd725106ac3f2b11cc764aa9/AF188126.1.fa
work/7e/2959b3a5216e251fc7ee32667ff4fd/AF188530.1.fa
work/47/85de9325ce2dabae214c8ad4993114/AF188126.1.fa
work/57/470ee99ba1f86448aa00c1fdb46d4c/AX244961.1.fa
work/b4/62e26f97f67b6926f00ebc9e399441/AF188530.1.fa
work/09/36b7b4052a1b0795c3c3e07d2491a6/AX244961.1.fa
work/09/36b7b4052a1b0795c3c3e07d2491a6/AX244961.1.fa.small.fa
work/53/5207bd0a14c9bd1c5ef63272b0d37c/AX244962.1.fa
work/8a/393846c4fd24100586490cfab61ad9/AX244963.1.fa
work/33/46eafd0f32a294e35e183caba84ae9/AX244962.1.fa
work/33/46eafd0f32a294e35e183caba84ae9/AX244962.1.fa.small.fa
work/69/56928dc919b61f311fd4b02d3f6ad8/AX244963.1.fa
work/69/56928dc919b61f311fd4b02d3f6ad8/AX244963.1.fa.small.fa
work/ca/de4d41892fe6e27b7ec4776964f9ba/AX244964.1.fa
work/96/488f32ef356fcc531f619eea9568d4/AX244964.1.fa
work/96/488f32ef356fcc531f619eea9568d4/AX244964.1.fa.small.fa
work/72/6650bdbd0496f5d2c9590dbfc7b85a/AX244965.1.fa
work/22/374b5b7980c2406c25323243e4d159/AX244966.1.fa
work/6e/d42e07d5f406c88a02b236d6746041/AX244965.1.fa
work/6e/d42e07d5f406c88a02b236d6746041/AX244965.1.fa.small.fa
work/35/7482edb16344bc818a179521e4c9f7/AX244966.1.fa
work/35/7482edb16344bc818a179521e4c9f7/AX244966.1.fa.small.fa
work/25/2b7d915a4f873cd199c8beca8a825f/AX244967.1.fa
work/05/926e5caba179ef7da1e78d1e73c8a0/AX244968.1.fa
work/11/7ca9147ccc3c156736893520bc72d6/AX244967.1.fa
work/11/7ca9147ccc3c156736893520bc72d6/AX244967.1.fa.small.fa
work/45/437480545da28c4eeac9f186d2f455/AY116592.1.fa
work/15/0ac9e8767704de5d4e6521acc69464/AX244968.1.fa
work/15/0ac9e8767704de5d4e6521acc69464/AX244968.1.fa.small.fa
work/c9/2e16e60503912b07ddac55dad4448c/NM_017590.5.fa
work/f3/41f2685c1c67844fbcde3c9e2cdad5/AY116592.1.fa
work/9d/00392718752a78ce6f05a51b89e57f/NM_017590.5.fa
```



## Workflow

![Workflow](flowchart.png)


## Trace

```
task_id	hash	native_id	name	status	exit	submit	duration	realtime	%cpu	rss	vmem	rchar	wchar
2	80/c25e36	3840	sortAcns (sorting list2.acns.txt)	COMPLETED	0	2018-09-28 13:15:17.667	421ms	31ms	0.0%	0	0	0	0
3	84/9240ae	3843	sortAcns (sorting list3.acns.txt)	COMPLETED	0	2018-09-28 13:15:17.695	444ms	31ms	0.0%	0	0	0	0
4	20/4c93a7	3849	sortAcns (sorting list4.acns.txt)	COMPLETED	0	2018-09-28 13:15:17.714	452ms	45ms	0.0%	0	0	0	0
1	c7/57fc6e	3855	sortAcns (sorting list1.acns.txt)	COMPLETED	0	2018-09-28 13:15:17.731	459ms	27ms	0.0%	0	0	0	0
5	51/8e9396	4091	commonAcns (comm list2.acns.txt vs list3.acns.txt)	COMPLETED	0	2018-09-28 13:15:18.168	478ms	38ms	0.0%	0	0	0	0
9	2e/5caa83	4101	commonAcns (comm list1.acns.txt vs list4.acns.txt)	COMPLETED	0	2018-09-28 13:15:18.246	432ms	51ms	0.0%	0	0	0	0
6	9f/ea7cfe	4098	commonAcns (comm list2.acns.txt vs list4.acns.txt)	COMPLETED	0	2018-09-28 13:15:18.227	472ms	46ms	0.0%	0	0	0	0
7	a0/40f384	4093	commonAcns (comm list3.acns.txt vs list4.acns.txt)	COMPLETED	0	2018-09-28 13:15:18.191	520ms	53ms	0.0%	0	0	0	0
8	e7/9538d1	4329	commonAcns (comm list1.acns.txt vs list2.acns.txt)	COMPLETED	0	2018-09-28 13:15:18.653	296ms	21ms	0.0%	0	0	0	0
10	fc/dcb89b	4338	commonAcns (comm list1.acns.txt vs list3.acns.txt)	COMPLETED	0	2018-09-28 13:15:18.690	285ms	19ms	0.0%	0	0	0	0
11	1b/dc99c8	4450	listCommons (common list size: 6)	COMPLETED	0	2018-09-28 13:15:19.009	470ms	64ms	0.0%	0	0	0	0
12	dc/383cf6	4587	eachAcn (dowloading AF002815.1)	COMPLETED	0	2018-09-28 13:15:19.510	723ms	482ms	0.0%	7.4 MB	50.2 MB	83.9 KB	682 B
13	5a/5ea9c5	4725	filterSize (size for AF002815.1.fa)	COMPLETED	0	2018-09-28 13:15:20.268	363ms	25ms	0.0%	0	0	0	0
14	c1/077b3a	4724	eachAcn (dowloading AF002816.1)	COMPLETED	0	2018-09-28 13:15:20.254	822ms	495ms	0.0%	7.4 MB	50.1 MB	83.9 KB	682 B
15	28/d8c8b4	4975	filterSize (size for AF002816.1.fa)	COMPLETED	0	2018-09-28 13:15:21.091	291ms	34ms	0.0%	0	0	0	0
16	1e/dfc74a	4977	eachAcn (dowloading AF004836.1)	COMPLETED	0	2018-09-28 13:15:21.105	619ms	470ms	0.0%	8.7 MB	50.1 MB	88.8 KB	1.1 KB
17	a8/3a107f	5176	filterSize (size for AF004836.1.fa)	COMPLETED	0	2018-09-28 13:15:21.744	426ms	28ms	0.0%	0	0	0	0
18	65/6050ff	5177	eachAcn (dowloading AF188126.1)	COMPLETED	0	2018-09-28 13:15:21.753	776ms	492ms	0.0%	7.3 MB	50.1 MB	83.9 KB	682 B
20	47/85de93	5448	filterSize (size for AF188126.1.fa)	COMPLETED	0	2018-09-28 13:15:22.568	349ms	28ms	0.0%	0	0	0	0
19	7e/2959b3	5447	eachAcn (dowloading AF188530.1)	COMPLETED	0	2018-09-28 13:15:22.557	791ms	478ms	0.0%	7.4 MB	50.1 MB	88.5 KB	808 B
21	b4/62e26f	5653	filterSize (size for AF188530.1.fa)	COMPLETED	0	2018-09-28 13:15:23.377	461ms	29ms	0.0%	0	0	0	0
22	57/470ee9	5652	eachAcn (dowloading AX244961.1)	COMPLETED	0	2018-09-28 13:15:23.365	756ms	501ms	0.0%	8.7 MB	50.1 MB	88.8 KB	1.1 KB
24	09/36b7b4	5877	filterSize (size for AX244961.1.fa)	COMPLETED	0	2018-09-28 13:15:24.146	353ms	28ms	0.0%	0	0	0	0
23	53/5207bd	5878	eachAcn (dowloading AX244962.1)	COMPLETED	0	2018-09-28 13:15:24.162	774ms	484ms	0.0%	7.5 MB	50.1 MB	83.9 KB	682 B
25	33/46eafd	6103	filterSize (size for AX244962.1.fa)	COMPLETED	0	2018-09-28 13:15:24.968	297ms	34ms	0.0%	0	0	0	0
26	8a/393846	6102	eachAcn (dowloading AX244963.1)	COMPLETED	0	2018-09-28 13:15:24.956	723ms	490ms	0.0%	7.3 MB	50.1 MB	83.9 KB	682 B
28	69/56928d	6308	filterSize (size for AX244963.1.fa)	COMPLETED	0	2018-09-28 13:15:25.692	479ms	48ms	0.0%	0	0	0	0
27	ca/de4d41	6310	eachAcn (dowloading AX244964.1)	COMPLETED	0	2018-09-28 13:15:25.707	742ms	495ms	0.0%	7.3 MB	50.1 MB	83.9 KB	682 B
29	96/488f32	6602	filterSize (size for AX244964.1.fa)	COMPLETED	0	2018-09-28 13:15:26.472	441ms	44ms	0.0%	0	0	0	0
30	72/6650bd	6604	eachAcn (dowloading AX244965.1)	COMPLETED	0	2018-09-28 13:15:26.483	738ms	541ms	0.0%	8.7 MB	50 MB	88.8 KB	1.1 KB
31	6e/d42e07	6875	filterSize (size for AX244965.1.fa)	COMPLETED	0	2018-09-28 13:15:27.256	331ms	31ms	0.0%	0	0	0	0
32	22/374b5b	6873	eachAcn (dowloading AX244966.1)	COMPLETED	0	2018-09-28 13:15:27.240	702ms	485ms	0.0%	8.6 MB	50.1 MB	83.9 KB	682 B
33	35/7482ed	7191	filterSize (size for AX244966.1.fa)	COMPLETED	0	2018-09-28 13:15:27.953	338ms	40ms	0.0%	0	0	0	0
34	25/2b7d91	7193	eachAcn (dowloading AX244967.1)	COMPLETED	0	2018-09-28 13:15:27.963	756ms	495ms	0.0%	7.4 MB	50.1 MB	83.9 KB	682 B
35	11/7ca914	7422	filterSize (size for AX244967.1.fa)	COMPLETED	0	2018-09-28 13:15:28.752	311ms	43ms	0.0%	0	0	0	0
36	05/926e5c	7421	eachAcn (dowloading AX244968.1)	COMPLETED	0	2018-09-28 13:15:28.739	784ms	489ms	0.0%	7.4 MB	50 MB	83.9 KB	682 B
37	15/0ac9e8	7657	filterSize (size for AX244968.1.fa)	COMPLETED	0	2018-09-28 13:15:29.551	493ms	41ms	0.0%	0	0	0	0
38	45/437480	7656	eachAcn (dowloading AY116592.1)	COMPLETED	0	2018-09-28 13:15:29.542	754ms	501ms	0.0%	7.4 MB	50.1 MB	83.9 KB	682 B
39	f3/41f268	7965	filterSize (size for AY116592.1.fa)	COMPLETED	0	2018-09-28 13:15:30.316	322ms	28ms	0.0%	0	0	0	0
40	c9/2e16e6	7963	eachAcn (dowloading NM_017590.5)	COMPLETED	0	2018-09-28 13:15:30.306	751ms	498ms	0.0%	7.3 MB	50.1 MB	83.9 KB	683 B
41	9d/003927	8165	filterSize (size for NM_017590.5.fa)	COMPLETED	0	2018-09-28 13:15:31.077	332ms	25ms	0.0%	0	0	0	0
```

