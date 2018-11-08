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
 59   	curl -o "${acn}.fa" -f -L  "https://www.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nucleotide&id=${acn}&rettype=fasta"
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
Launching `workflow.nf` [scruffy_allen] - revision: c7b2fa8679
[warm up] executor > local
[a4/6d0840] Submitted process > sortAcns (sorting list3.acns.txt)
[7f/2465f6] Submitted process > sortAcns (sorting list4.acns.txt)
[ba/347cb5] Submitted process > sortAcns (sorting list2.acns.txt)
[d1/c250c0] Submitted process > sortAcns (sorting list1.acns.txt)
[23/088e9c] Submitted process > commonAcns (comm list3.acns.txt vs list4.acns.txt)
[77/0d788b] Submitted process > commonAcns (comm list2.acns.txt vs list4.acns.txt)
[ff/a7a835] Submitted process > commonAcns (comm list2.acns.txt vs list3.acns.txt)
[66/ff7a9b] Submitted process > commonAcns (comm list1.acns.txt vs list3.acns.txt)
[ea/d6719f] Submitted process > commonAcns (comm list1.acns.txt vs list4.acns.txt)
[9d/d13742] Submitted process > commonAcns (comm list1.acns.txt vs list2.acns.txt)
[23/4e086f] Submitted process > listCommons (common list size: 6)
[38/ca31e5] Submitted process > eachAcn (dowloading AF002815.1)
[a1/5e3993] Submitted process > filterSize (size for AF002815.1.fa)
[26/7bae64] Submitted process > eachAcn (dowloading AF002816.1)
[3e/9b636c] Submitted process > eachAcn (dowloading AF004836.1)
[19/413e28] Submitted process > filterSize (size for AF002816.1.fa)
[9f/a2e3a3] Submitted process > eachAcn (dowloading AF188126.1)
[6b/445c6f] Submitted process > filterSize (size for AF004836.1.fa)
[a0/3cba56] Submitted process > filterSize (size for AF188126.1.fa)
[f0/f4827b] Submitted process > eachAcn (dowloading AF188530.1)
[de/40cdf7] Submitted process > eachAcn (dowloading AX244961.1)
[3c/b66586] Submitted process > filterSize (size for AF188530.1.fa)
[23/d3b682] Submitted process > filterSize (size for AX244961.1.fa)
[cc/c65965] Submitted process > eachAcn (dowloading AX244962.1)
[72/ecd248] Submitted process > eachAcn (dowloading AX244963.1)
[f8/130f04] Submitted process > filterSize (size for AX244962.1.fa)
[39/274af8] Submitted process > filterSize (size for AX244963.1.fa)
[fb/864606] Submitted process > eachAcn (dowloading AX244964.1)
[b3/bfb615] Submitted process > eachAcn (dowloading AX244965.1)
[4e/e565df] Submitted process > filterSize (size for AX244964.1.fa)
[36/50f1a4] Submitted process > filterSize (size for AX244965.1.fa)
[a1/f8ee8b] Submitted process > eachAcn (dowloading AX244966.1)
[51/4bbf4e] Submitted process > filterSize (size for AX244966.1.fa)
[53/dc19bd] Submitted process > eachAcn (dowloading AX244967.1)
[24/76984d] Submitted process > eachAcn (dowloading AX244968.1)
[68/069a64] Submitted process > filterSize (size for AX244967.1.fa)
[5b/530973] Submitted process > filterSize (size for AX244968.1.fa)
[5a/7837fd] Submitted process > eachAcn (dowloading AY116592.1)
[5a/135553] Submitted process > filterSize (size for AY116592.1.fa)
[6e/d0ec6c] Submitted process > eachAcn (dowloading NM_017590.5)
[ee/713854] Submitted process > filterSize (size for NM_017590.5.fa)
```


## Files

```
work/9f/a2e3a38d80bb0a44e652535aaae6cd/AF188126.1.fa
work/38/ca31e5627f1ea6ff242efee486fa02/AF002815.1.fa
work/23/088e9ca4b01c0b81d741d01ad345a9/comm.txt
work/23/4e086f5665053fb325fc143c26284b/distinct.acns.txt
work/23/4e086f5665053fb325fc143c26284b/table.csv
work/23/d3b6828d120e7350cc3d9cf29c1af2/AX244961.1.fa
work/23/d3b6828d120e7350cc3d9cf29c1af2/AX244961.1.fa.small.fa
work/7f/2465f687b48cc213eb7a15a5d418fe/list4.acns.txt.sorted.txt
work/7f/2465f687b48cc213eb7a15a5d418fe/list4.acns.txt
work/6b/445c6f367cf510b73109908266c432/AF004836.1.fa
work/f8/130f0405524269a51eb141f70b5966/AX244962.1.fa.small.fa
work/f8/130f0405524269a51eb141f70b5966/AX244962.1.fa
work/fb/864606807853ba8f81dc45a6234ccb/AX244964.1.fa
work/ee/713854a4292af2fc906927f5684ed4/NM_017590.5.fa
work/5a/1355534e3f0ffe7c3e96856bb8d8c0/AY116592.1.fa
work/5a/7837fda9dbac30acfbfd79080fe854/AY116592.1.fa
work/ba/347cb5e6ab777d478bda62b119b98b/list2.acns.txt.sorted.txt
work/ba/347cb5e6ab777d478bda62b119b98b/list2.acns.txt
work/39/274af8e79a3feb1628679341227b64/AX244963.1.fa
work/39/274af8e79a3feb1628679341227b64/AX244963.1.fa.small.fa
work/a4/6d0840269741787c8d390a45fe6778/list3.acns.txt
work/a4/6d0840269741787c8d390a45fe6778/list3.acns.txt.sorted.txt
work/9d/d13742e232a6ff171a8a6d57150908/comm.txt
work/cc/c65965b5f30678d7863fe643e149ea/AX244962.1.fa
work/ff/a7a835af0941fe87c0d9b554f2a5c7/comm.txt
work/36/50f1a409c7d0f241a997a5a33e22c6/AX244965.1.fa.small.fa
work/36/50f1a409c7d0f241a997a5a33e22c6/AX244965.1.fa
work/77/0d788be5aba4280715410282b888c5/comm.txt
work/6e/d0ec6cee082d9721374c9d86158bed/NM_017590.5.fa
work/19/413e2855ddbeabe00b57e286cff3e5/AF002816.1.fa
work/d1/c250c0cce5cb2e99813a346aea19a6/list1.acns.txt.sorted.txt
work/d1/c250c0cce5cb2e99813a346aea19a6/list1.acns.txt
work/4e/e565df7fae0b55d73341deae66bb68/AX244964.1.fa.small.fa
work/4e/e565df7fae0b55d73341deae66bb68/AX244964.1.fa
work/3e/9b636c9170f7ef86070780128d8b90/AF004836.1.fa
work/de/40cdf73f121036fe54dcfcd32d72f1/AX244961.1.fa
work/3c/b66586c41894d6f568e889ad1a8353/AF188530.1.fa
work/f0/f4827ba65ccc2ee3e592ca7989ed6c/AF188530.1.fa
work/51/4bbf4ef9d61ccf6115d541854999e0/AX244966.1.fa
work/51/4bbf4ef9d61ccf6115d541854999e0/AX244966.1.fa.small.fa
work/68/069a64cfc7c90c41f4f2830b1f5225/AX244967.1.fa.small.fa
work/68/069a64cfc7c90c41f4f2830b1f5225/AX244967.1.fa
work/53/dc19bdc10585eb2ff168d890133adb/AX244967.1.fa
work/72/ecd24844273b4bef04a6d083bbef2f/AX244963.1.fa
work/5b/5309730e1c85a1ae426df9e8e834f2/AX244968.1.fa
work/5b/5309730e1c85a1ae426df9e8e834f2/AX244968.1.fa.small.fa
work/66/ff7a9be79bac4cbeaadfd53979338c/comm.txt
work/a0/3cba563377a098491663d65ef7582a/AF188126.1.fa
work/ea/d6719fac85d5a22ec76e2f347d7980/comm.txt
work/26/7bae649cabd0e3cc21c549cbc6fbc4/AF002816.1.fa
work/a1/5e3993065aae9ffb615a28c3797d9d/AF002815.1.fa
work/a1/f8ee8b414e3df970bd541757a40de4/AX244966.1.fa
work/24/76984d89a4146d6b343787ed194f81/AX244968.1.fa
work/b3/bfb615d01270a4e5ac499b03022c8b/AX244965.1.fa
```



## Workflow

![Workflow](flowchart.png)


## Trace

```
task_id	hash	native_id	name	status	exit	submit	duration	realtime	%cpu	rss	vmem	rchar	wchar
1	a4/6d0840	16961	sortAcns (sorting list3.acns.txt)	COMPLETED	0	2018-11-08 15:30:31.369	414ms	51ms	0.0%	0	0	0	0
2	7f/2465f6	16965	sortAcns (sorting list4.acns.txt)	COMPLETED	0	2018-11-08 15:30:31.427	565ms	42ms	0.0%	0	0	0	0
3	ba/347cb5	17083	sortAcns (sorting list2.acns.txt)	COMPLETED	0	2018-11-08 15:30:31.823	510ms	67ms	0.0%	0	0	0	0
4	d1/c250c0	17107	sortAcns (sorting list1.acns.txt)	COMPLETED	0	2018-11-08 15:30:32.002	401ms	26ms	0.0%	0	0	0	0
5	23/088e9c	17207	commonAcns (comm list3.acns.txt vs list4.acns.txt)	COMPLETED	0	2018-11-08 15:30:32.354	399ms	78ms	0.0%	0	0	0	0
6	77/0d788b	17219	commonAcns (comm list2.acns.txt vs list4.acns.txt)	COMPLETED	0	2018-11-08 15:30:32.416	385ms	48ms	0.0%	0	0	0	0
7	ff/a7a835	17325	commonAcns (comm list2.acns.txt vs list3.acns.txt)	COMPLETED	0	2018-11-08 15:30:32.757	252ms	43ms	0.0%	0	0	0	0
8	66/ff7a9b	17356	commonAcns (comm list1.acns.txt vs list3.acns.txt)	COMPLETED	0	2018-11-08 15:30:32.819	220ms	19ms	0.0%	0	0	0	0
9	ea/d6719f	17443	commonAcns (comm list1.acns.txt vs list4.acns.txt)	COMPLETED	0	2018-11-08 15:30:33.022	217ms	27ms	0.0%	0	0	0	0
10	9d/d13742	17472	commonAcns (comm list1.acns.txt vs list2.acns.txt)	COMPLETED	0	2018-11-08 15:30:33.070	214ms	14ms	0.0%	0	0	0	0
11	23/4e086f	17562	listCommons (common list size: 6)	COMPLETED	0	2018-11-08 15:30:33.297	230ms	15ms	0.0%	0	0	0	0
12	38/ca31e5	17699	eachAcn (dowloading AF002815.1)	COMPLETED	0	2018-11-08 15:30:33.544	5.5s	568ms	61.5%	24.1 MB	44 MB	1.1 MB	237 B
13	a1/5e3993	17892	filterSize (size for AF002815.1.fa)	COMPLETED	0	2018-11-08 15:30:39.083	378ms	60ms	0.0%	0	0	0	0
14	26/7bae64	17893	eachAcn (dowloading AF002816.1)	COMPLETED	0	2018-11-08 15:30:39.101	812ms	640ms	34.5%	24.1 MB	44 MB	253.9 KB	237 B
16	19/413e28	18117	filterSize (size for AF002816.1.fa)	COMPLETED	0	2018-11-08 15:30:39.986	319ms	39ms	0.0%	0	0	0	0
15	3e/9b636c	18095	eachAcn (dowloading AF004836.1)	COMPLETED	0	2018-11-08 15:30:39.932	5.7s	648ms	18.5%	24.3 MB	44 MB	1.1 MB	316 B
17	6b/445c6f	18377	filterSize (size for AF004836.1.fa)	COMPLETED	0	2018-11-08 15:30:45.686	326ms	8ms	0.0%	0	0	0	0
18	9f/a2e3a3	18375	eachAcn (dowloading AF188126.1)	COMPLETED	0	2018-11-08 15:30:45.682	5.6s	704ms	39.3%	24.2 MB	44 MB	1.1 MB	237 B
19	a0/3cba56	18633	filterSize (size for AF188126.1.fa)	COMPLETED	0	2018-11-08 15:30:51.298	352ms	43ms	0.0%	0	0	0	0
20	f0/f4827b	18635	eachAcn (dowloading AF188530.1)	COMPLETED	0	2018-11-08 15:30:51.307	5.6s	636ms	41.7%	24.1 MB	44 MB	1.1 MB	237 B
21	3c/b66586	18892	filterSize (size for AF188530.1.fa)	COMPLETED	0	2018-11-08 15:30:56.953	234ms	27ms	0.0%	0	0	0	0
22	de/40cdf7	18891	eachAcn (dowloading AX244961.1)	COMPLETED	0	2018-11-08 15:30:56.949	5.6s	600ms	46.8%	24.3 MB	44 MB	1.1 MB	316 B
23	23/d3b682	19148	filterSize (size for AX244961.1.fa)	COMPLETED	0	2018-11-08 15:31:02.556	224ms	66ms	0.0%	2.7 MB	5.4 MB	73 B	41 B
24	cc/c65965	19151	eachAcn (dowloading AX244962.1)	COMPLETED	0	2018-11-08 15:31:02.560	5.8s	672ms	17.7%	24.1 MB	44 MB	1.1 MB	237 B
26	f8/130f04	19409	filterSize (size for AX244962.1.fa)	COMPLETED	0	2018-11-08 15:31:08.388	203ms	29ms	0.0%	0	0	0	0
25	72/ecd248	19408	eachAcn (dowloading AX244963.1)	COMPLETED	0	2018-11-08 15:31:08.385	5.5s	596ms	61.5%	24.3 MB	44 MB	1.1 MB	237 B
27	39/274af8	19666	filterSize (size for AX244963.1.fa)	COMPLETED	0	2018-11-08 15:31:13.929	389ms	38ms	0.0%	0	0	0	0
28	fb/864606	19667	eachAcn (dowloading AX244964.1)	COMPLETED	0	2018-11-08 15:31:13.943	5.9s	677ms	37.7%	24.1 MB	44 MB	1.1 MB	316 B
29	4e/e565df	20038	filterSize (size for AX244964.1.fa)	COMPLETED	0	2018-11-08 15:31:19.880	193ms	27ms	0.0%	0	0	0	0
30	b3/bfb615	20031	eachAcn (dowloading AX244965.1)	COMPLETED	0	2018-11-08 15:31:19.873	5.5s	695ms	92.3%	24.1 MB	44 MB	1.1 MB	316 B
32	36/50f1a4	20291	filterSize (size for AX244965.1.fa)	COMPLETED	0	2018-11-08 15:31:25.445	205ms	28ms	0.0%	0	0	0	0
31	a1/f8ee8b	20292	eachAcn (dowloading AX244966.1)	COMPLETED	0	2018-11-08 15:31:25.451	5.5s	581ms	59.5%	24.3 MB	44 MB	1.1 MB	237 B
33	51/4bbf4e	20551	filterSize (size for AX244966.1.fa)	COMPLETED	0	2018-11-08 15:31:30.980	432ms	32ms	0.0%	0	0	0	0
34	53/dc19bd	20552	eachAcn (dowloading AX244967.1)	COMPLETED	0	2018-11-08 15:31:30.983	5.7s	751ms	17.9%	24.2 MB	44 MB	1.1 MB	316 B
36	68/069a64	20817	filterSize (size for AX244967.1.fa)	COMPLETED	0	2018-11-08 15:31:36.687	303ms	49ms	0.0%	0	0	0	0
35	24/76984d	20811	eachAcn (dowloading AX244968.1)	COMPLETED	0	2018-11-08 15:31:36.679	5.7s	629ms	44.1%	24.1 MB	44 MB	1.1 MB	237 B
37	5b/530973	21073	filterSize (size for AX244968.1.fa)	COMPLETED	0	2018-11-08 15:31:42.353	459ms	74ms	0.0%	0	0	0	0
38	5a/7837fd	21074	eachAcn (dowloading AY116592.1)	COMPLETED	0	2018-11-08 15:31:42.356	5.9s	707ms	16.2%	24.4 MB	44 MB	1.1 MB	237 B
40	5a/135553	21309	filterSize (size for AY116592.1.fa)	COMPLETED	0	2018-11-08 15:31:48.241	202ms	7ms	0.0%	0	0	0	0
39	6e/d0ec6c	21310	eachAcn (dowloading NM_017590.5)	COMPLETED	0	2018-11-08 15:31:48.243	5.5s	602ms	84.2%	24.1 MB	44 MB	1.1 MB	316 B
41	ee/713854	21566	filterSize (size for NM_017590.5.fa)	COMPLETED	0	2018-11-08 15:31:53.754	220ms	15ms	0.0%	0	0	0	0
```

