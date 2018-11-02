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
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [mad_varahamihira] - revision: 5a86ad5e38
[warm up] executor > local
[a4/6d0840] Submitted process > sortAcns (sorting list3.acns.txt)
[7f/2465f6] Submitted process > sortAcns (sorting list4.acns.txt)
[ba/347cb5] Submitted process > sortAcns (sorting list2.acns.txt)
[d1/c250c0] Submitted process > sortAcns (sorting list1.acns.txt)
[89/c2c47b] Submitted process > commonAcns (comm list3.acns.txt vs list4.acns.txt)
[1d/c5e070] Submitted process > commonAcns (comm list2.acns.txt vs list4.acns.txt)
[ed/1f8854] Submitted process > commonAcns (comm list2.acns.txt vs list3.acns.txt)
[3e/af92a3] Submitted process > commonAcns (comm list1.acns.txt vs list4.acns.txt)
[e5/db3f35] Submitted process > commonAcns (comm list1.acns.txt vs list3.acns.txt)
[79/e99815] Submitted process > commonAcns (comm list1.acns.txt vs list2.acns.txt)
[55/ec9f8a] Submitted process > listCommons (common list size: 6)
[c9/b3d84f] Submitted process > eachAcn (dowloading AF002815.1)
[d8/ccff79] Submitted process > eachAcn (dowloading AF002816.1)
[ea/82d416] Submitted process > filterSize (size for AF002815.1.fa)
[cd/65f21e] Submitted process > eachAcn (dowloading AF004836.1)
[ff/fe5f1a] Submitted process > filterSize (size for AF002816.1.fa)
[56/e8e0ab] Submitted process > filterSize (size for AF004836.1.fa)
[a5/31b604] Submitted process > eachAcn (dowloading AF188126.1)
[3a/e7e385] Submitted process > filterSize (size for AF188126.1.fa)
[3e/2041a0] Submitted process > eachAcn (dowloading AF188530.1)
[1f/9ba560] Submitted process > eachAcn (dowloading AX244961.1)
[f4/68397a] Submitted process > filterSize (size for AF188530.1.fa)
[d3/ffb8d3] Submitted process > eachAcn (dowloading AX244962.1)
[55/3b96af] Submitted process > filterSize (size for AX244961.1.fa)
[cc/40329b] Submitted process > filterSize (size for AX244962.1.fa)
[7e/927154] Submitted process > eachAcn (dowloading AX244963.1)
[30/52fb15] Submitted process > filterSize (size for AX244963.1.fa)
[d0/30724f] Submitted process > eachAcn (dowloading AX244964.1)
[47/5a32f9] Submitted process > eachAcn (dowloading AX244965.1)
[1d/ad8e04] Submitted process > filterSize (size for AX244964.1.fa)
[3c/45fd4a] Submitted process > filterSize (size for AX244965.1.fa)
[ba/a00dae] Submitted process > eachAcn (dowloading AX244966.1)
[7d/098c89] Submitted process > eachAcn (dowloading AX244967.1)
[da/3c6003] Submitted process > filterSize (size for AX244966.1.fa)
[c1/04d309] Submitted process > filterSize (size for AX244967.1.fa)
[ec/ffd68c] Submitted process > eachAcn (dowloading AX244968.1)
[73/5868a3] Submitted process > eachAcn (dowloading AY116592.1)
[a4/ed7e74] Submitted process > filterSize (size for AX244968.1.fa)
[0d/fea75b] Submitted process > eachAcn (dowloading NM_017590.5)
[b0/34ef23] Submitted process > filterSize (size for AY116592.1.fa)
[a2/11017e] Submitted process > filterSize (size for NM_017590.5.fa)
```


## Files

```
work/7f/2465f687b48cc213eb7a15a5d418fe/list4.acns.txt.sorted.txt
work/7f/2465f687b48cc213eb7a15a5d418fe/list4.acns.txt
work/0d/fea75b360f24ed287b07dd222f7921/NM_017590.5.fa
work/ec/ffd68cb36add201dbc271461d891e9/AX244968.1.fa
work/d8/ccff7972f22429a896886bd0abe74d/AF002816.1.fa
work/ba/347cb5e6ab777d478bda62b119b98b/list2.acns.txt.sorted.txt
work/ba/347cb5e6ab777d478bda62b119b98b/list2.acns.txt
work/ba/a00daea586816166f1c071d65c6fb4/AX244966.1.fa
work/b0/34ef237873b8a17fcdf3f51fdd670b/AY116592.1.fa
work/a4/6d0840269741787c8d390a45fe6778/list3.acns.txt
work/a4/6d0840269741787c8d390a45fe6778/list3.acns.txt.sorted.txt
work/a4/ed7e749a9078be176e4b5484c06b1e/AX244968.1.fa
work/a4/ed7e749a9078be176e4b5484c06b1e/AX244968.1.fa.small.fa
work/cc/40329bcff8af3ace8f95405b02dafd/AX244962.1.fa.small.fa
work/cc/40329bcff8af3ace8f95405b02dafd/AX244962.1.fa
work/c9/b3d84ff6dab86a2e3b2abc7256653e/AF002815.1.fa
work/ff/fe5f1a8351bd9591ebbc3af99f4a8a/AF002816.1.fa
work/a2/11017e4b9accc376d6823ca2926a71/NM_017590.5.fa
work/f4/68397a201c1b8b9a6791da4c250b04/AF188530.1.fa
work/73/5868a3a6d16e4e5025cbc347e347b6/AY116592.1.fa
work/1f/9ba5607fd7e729290ec26a1dd745db/AX244961.1.fa
work/7e/927154a3369883b21e2863edd7020c/AX244963.1.fa
work/56/e8e0ab3ccd59973fa9de81f767cbbb/AF004836.1.fa
work/d1/c250c0cce5cb2e99813a346aea19a6/list1.acns.txt.sorted.txt
work/d1/c250c0cce5cb2e99813a346aea19a6/list1.acns.txt
work/3e/af92a3ecc54e66dd89845155060f93/comm.txt
work/3e/2041a087d6dd93b04faa19d7545e97/AF188530.1.fa
work/c1/04d3092bafd24cf3545d523b0b43a2/AX244967.1.fa.small.fa
work/c1/04d3092bafd24cf3545d523b0b43a2/AX244967.1.fa
work/3c/45fd4a9ede2d30628375d13dd534a8/AX244965.1.fa.small.fa
work/3c/45fd4a9ede2d30628375d13dd534a8/AX244965.1.fa
work/ed/1f8854518f5f145f975b0fda111068/comm.txt
work/d3/ffb8d31d32eacde499e393eba1ebba/AX244962.1.fa
work/da/3c60035bf22f63d128f50fc9311bfe/AX244966.1.fa
work/da/3c60035bf22f63d128f50fc9311bfe/AX244966.1.fa.small.fa
work/e5/db3f353438b43bf6a778971ef4e99b/comm.txt
work/89/c2c47bd01ec03e514f7387199119f3/comm.txt
work/7d/098c8990e8d050b14270e1540d421d/AX244967.1.fa
work/3a/e7e3857c1f99067ac9d2f2805235aa/AF188126.1.fa
work/79/e9981513490bb283f2f67ec6f42b3f/comm.txt
work/1d/c5e070fc4525efc43d501ea80e5584/comm.txt
work/1d/ad8e046f6bed21ee3d2fd46ba58a74/AX244964.1.fa.small.fa
work/1d/ad8e046f6bed21ee3d2fd46ba58a74/AX244964.1.fa
work/cd/65f21e18d5c4cd863a0ac0cbb4555a/AF004836.1.fa
work/ea/82d416949597b2643d99b5ff04a5f4/AF002815.1.fa
work/55/3b96af339ec49b0673de92533df0f0/AX244961.1.fa
work/55/3b96af339ec49b0673de92533df0f0/AX244961.1.fa.small.fa
work/55/ec9f8a4bf9db2e01ae145ea084a023/table.csv
work/55/ec9f8a4bf9db2e01ae145ea084a023/distcint.acns.txt
work/30/52fb15067e55c1279bfb5c2fb7daad/AX244963.1.fa
work/30/52fb15067e55c1279bfb5c2fb7daad/AX244963.1.fa.small.fa
work/a5/31b60436ddc43f87061d38eb36865a/AF188126.1.fa
work/47/5a32f951a540d3f3ae64d14e5ab845/AX244965.1.fa
work/d0/30724fc18828e6bcbafa3fb920d8d9/AX244964.1.fa
```



## Workflow

![Workflow](flowchart.png)


## Trace

```
task_id	hash	native_id	name	status	exit	submit	duration	realtime	%cpu	rss	vmem	rchar	wchar
1	a4/6d0840	3794	sortAcns (sorting list3.acns.txt)	COMPLETED	0	2018-11-02 16:11:05.683	393ms	27ms	0.0%	0	0	0	0
2	7f/2465f6	3801	sortAcns (sorting list4.acns.txt)	COMPLETED	0	2018-11-02 16:11:05.756	499ms	29ms	0.0%	0	0	0	0
4	ba/347cb5	3918	sortAcns (sorting list2.acns.txt)	COMPLETED	0	2018-11-02 16:11:06.119	568ms	40ms	0.0%	0	0	0	0
3	d1/c250c0	3947	sortAcns (sorting list1.acns.txt)	COMPLETED	0	2018-11-02 16:11:06.266	534ms	52ms	0.0%	0	0	0	0
5	89/c2c47b	4041	commonAcns (comm list3.acns.txt vs list4.acns.txt)	COMPLETED	0	2018-11-02 16:11:06.712	396ms	37ms	0.0%	0	0	0	0
7	1d/c5e070	4058	commonAcns (comm list2.acns.txt vs list4.acns.txt)	COMPLETED	0	2018-11-02 16:11:06.808	339ms	28ms	0.0%	0	0	0	0
6	ed/1f8854	4219	commonAcns (comm list2.acns.txt vs list3.acns.txt)	COMPLETED	0	2018-11-02 16:11:07.113	348ms	30ms	0.0%	0	0	0	0
9	3e/af92a3	4246	commonAcns (comm list1.acns.txt vs list4.acns.txt)	COMPLETED	0	2018-11-02 16:11:07.192	360ms	26ms	0.0%	0	0	0	0
8	e5/db3f35	4338	commonAcns (comm list1.acns.txt vs list3.acns.txt)	COMPLETED	0	2018-11-02 16:11:07.473	343ms	29ms	0.0%	0	0	0	0
10	79/e99815	4365	commonAcns (comm list1.acns.txt vs list2.acns.txt)	COMPLETED	0	2018-11-02 16:11:07.564	386ms	21ms	0.0%	0	0	0	0
11	55/ec9f8a	4457	listCommons (common list size: 6)	COMPLETED	0	2018-11-02 16:11:07.984	423ms	66ms	0.0%	0	0	0	0
12	c9/b3d84f	4603	eachAcn (dowloading AF002815.1)	COMPLETED	0	2018-11-02 16:11:08.439	624ms	506ms	0.0%	7.4 MB	13.6 MB	50.8 KB	1.2 KB
13	ea/82d416	4742	filterSize (size for AF002815.1.fa)	COMPLETED	0	2018-11-02 16:11:09.089	411ms	54ms	0.0%	0	0	0	0
14	d8/ccff79	4741	eachAcn (dowloading AF002816.1)	COMPLETED	0	2018-11-02 16:11:09.082	1s	526ms	0.0%	7.2 MB	13.6 MB	50.8 KB	1.2 KB
16	ff/fe5f1a	4957	filterSize (size for AF002816.1.fa)	COMPLETED	0	2018-11-02 16:11:10.203	492ms	55ms	0.0%	0	0	0	0
15	cd/65f21e	4952	eachAcn (dowloading AF004836.1)	COMPLETED	0	2018-11-02 16:11:10.134	709ms	501ms	0.0%	7.3 MB	13.6 MB	50.5 KB	904 B
17	56/e8e0ab	5101	filterSize (size for AF004836.1.fa)	COMPLETED	0	2018-11-02 16:11:10.870	311ms	47ms	0.0%	0	0	0	0
18	a5/31b604	5131	eachAcn (dowloading AF188126.1)	COMPLETED	0	2018-11-02 16:11:10.931	667ms	504ms	0.0%	7.2 MB	13.6 MB	50.8 KB	1.2 KB
19	3a/e7e385	5302	filterSize (size for AF188126.1.fa)	COMPLETED	0	2018-11-02 16:11:11.605	299ms	36ms	0.0%	0	0	0	0
20	3e/2041a0	5334	eachAcn (dowloading AF188530.1)	COMPLETED	0	2018-11-02 16:11:11.648	648ms	506ms	0.0%	7.4 MB	13.6 MB	50.8 KB	1.2 KB
22	f4/68397a	5504	filterSize (size for AF188530.1.fa)	COMPLETED	0	2018-11-02 16:11:12.335	402ms	37ms	0.0%	0	0	0	0
21	1f/9ba560	5503	eachAcn (dowloading AX244961.1)	COMPLETED	0	2018-11-02 16:11:12.313	687ms	535ms	0.0%	7.1 MB	13.6 MB	50.8 KB	1.2 KB
24	55/3b96af	5717	filterSize (size for AX244961.1.fa)	COMPLETED	0	2018-11-02 16:11:13.029	408ms	57ms	0.0%	0	0	0	0
23	d3/ffb8d3	5709	eachAcn (dowloading AX244962.1)	COMPLETED	0	2018-11-02 16:11:13.015	870ms	772ms	0.0%	7.2 MB	13.6 MB	50.8 KB	1.2 KB
25	cc/40329b	5912	filterSize (size for AX244962.1.fa)	COMPLETED	0	2018-11-02 16:11:13.897	421ms	96ms	0.0%	0	0	0	0
26	7e/927154	5914	eachAcn (dowloading AX244963.1)	COMPLETED	0	2018-11-02 16:11:13.917	1.1s	574ms	0.0%	7.4 MB	13.6 MB	50.8 KB	1.2 KB
28	30/52fb15	6114	filterSize (size for AX244963.1.fa)	COMPLETED	0	2018-11-02 16:11:14.999	446ms	86ms	0.0%	0	0	0	0
27	d0/30724f	6115	eachAcn (dowloading AX244964.1)	COMPLETED	0	2018-11-02 16:11:15.011	695ms	521ms	0.0%	7.3 MB	13.6 MB	50.8 KB	1.2 KB
30	1d/ad8e04	6317	filterSize (size for AX244964.1.fa)	COMPLETED	0	2018-11-02 16:11:15.731	338ms	39ms	0.0%	0	0	0	0
29	47/5a32f9	6316	eachAcn (dowloading AX244965.1)	COMPLETED	0	2018-11-02 16:11:15.715	5.6s	548ms	0.0%	7 MB	13.6 MB	50.8 KB	1.2 KB
32	3c/45fd4a	6573	filterSize (size for AX244965.1.fa)	COMPLETED	0	2018-11-02 16:11:21.366	346ms	21ms	0.0%	0	0	0	0
31	ba/a00dae	6574	eachAcn (dowloading AX244966.1)	COMPLETED	0	2018-11-02 16:11:21.378	612ms	497ms	0.0%	7.3 MB	13.6 MB	50.8 KB	1.2 KB
34	da/3c6003	6776	filterSize (size for AX244966.1.fa)	COMPLETED	0	2018-11-02 16:11:22.015	272ms	31ms	0.0%	0	0	0	0
33	7d/098c89	6775	eachAcn (dowloading AX244967.1)	COMPLETED	0	2018-11-02 16:11:21.998	5.6s	1.8s	0.0%	7.2 MB	13.6 MB	45.9 KB	444 B
36	c1/04d309	7087	filterSize (size for AX244967.1.fa)	COMPLETED	0	2018-11-02 16:11:27.585	476ms	53ms	0.0%	0	0	0	0
35	ec/ffd68c	7088	eachAcn (dowloading AX244968.1)	COMPLETED	0	2018-11-02 16:11:27.589	713ms	517ms	0.0%	7.4 MB	13.6 MB	50.8 KB	1.2 KB
38	a4/ed7e74	7293	filterSize (size for AX244968.1.fa)	COMPLETED	0	2018-11-02 16:11:28.321	418ms	62ms	0.0%	0	0	0	0
37	73/5868a3	7292	eachAcn (dowloading AY116592.1)	COMPLETED	0	2018-11-02 16:11:28.314	802ms	511ms	0.0%	7.1 MB	13.6 MB	45.9 KB	778 B
40	b0/34ef23	7440	filterSize (size for AY116592.1.fa)	COMPLETED	0	2018-11-02 16:11:29.127	643ms	32ms	0.0%	0	0	0	0
39	0d/fea75b	7439	eachAcn (dowloading NM_017590.5)	COMPLETED	0	2018-11-02 16:11:29.123	665ms	487ms	0.0%	7.3 MB	13.6 MB	45.9 KB	779 B
41	a2/11017e	7585	filterSize (size for NM_017590.5.fa)	COMPLETED	0	2018-11-02 16:11:29.795	348ms	23ms	0.0%	0	0	0	0
```

