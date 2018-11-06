## Synopsis
> The `when` declaration allows you to define a condition that must be verified in order to execute the process. 

## nextflow

### ./workflow.nf

```groovy
acn_file_channel = Channel.fromPath( "${params.acns}")

/** copy acn_file_channel : https://www.nextflow.io/docs/latest/faq.html How do I use the same channel multiple times?  */
acn_file_channel.into { copy1 ; copy2}

process Accession_from_A_to_M {
	tag "${acn} From A to M"
	maxForks 1
	input:
		val acn from copy1.
				splitCsv(sep:',',strip:true).
				map{ARRAY->ARRAY[0]}
	output:
		file("${acn}.am.txt") into A_TO_M
	
	when:
		acn =~ /^[A-M]/
	
	script:
	 
	"""
	echo "${acn}" > "${acn}.am.txt"
	"""
	}

process Accession_from_N_to_Z {
	tag "${acn} From N to Z"
	maxForks 1
	input:
		val acn from copy2.
				splitCsv(sep:',',strip:true).
				map{ARRAY->ARRAY[0]}
	output:
		file("${acn}.nz.txt") into N_TO_Z
	
	when:
		acn =~ /^[N-Z]/
	
	script:
	 
	"""
	echo "${acn}" > "${acn}.nz.txt"
	"""
	}

```


## Execute

```
../bin/nextflow run workflow.nf --acns '../data/list*.acns.txt'
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [pensive_sinoussi] - revision: ce9cc7016c
[warm up] executor > local
[cf/c829af] Submitted process > Accession_from_N_to_Z (NM_001293170.1 From N to Z)
[fe/8e69e8] Submitted process > Accession_from_A_to_M (AF188530.1 From A to M)
[0b/4a17d3] Submitted process > Accession_from_N_to_Z (NM_001199860.1 From N to Z)
[3b/443ab3] Submitted process > Accession_from_A_to_M (AF188126.1 From A to M)
[79/0417e0] Submitted process > Accession_from_N_to_Z (NM_001199861.1 From N to Z)
[5c/a4e797] Submitted process > Accession_from_A_to_M (AF004836.1 From A to M)
[b5/c01221] Submitted process > Accession_from_N_to_Z (NM_001199862.1 From N to Z)
[57/fb593f] Submitted process > Accession_from_A_to_M (AF002816.1 From A to M)
[9e/57bd24] Submitted process > Accession_from_N_to_Z (NM_001199863.1 From N to Z)
[93/ba541f] Submitted process > Accession_from_A_to_M (AF002815.1 From A to M)
[38/da9502] Submitted process > Accession_from_N_to_Z (NM_003636.3 From N to Z)
[c6/d4e5cf] Submitted process > Accession_from_N_to_Z (NM_172130.2 From N to Z)
[36/49ba2e] Submitted process > Accession_from_A_to_M (CS172270.1 From A to M)
[ca/eacc8c] Submitted process > Accession_from_N_to_Z (NM_001142703.1 From N to Z)
[86/b6a519] Submitted process > Accession_from_A_to_M (CS172261.1 From A to M)
[46/5691f3] Submitted process > Accession_from_N_to_Z (NM_001142704.1 From N to Z)
[0e/00e5ca] Submitted process > Accession_from_A_to_M (AF188126.1 From A to M)
[7a/e2042e] Submitted process > Accession_from_N_to_Z (NM_001220.4 From N to Z)
[c6/de36e9] Submitted process > Accession_from_A_to_M (M74217.1 From A to M)
[00/b43bff] Submitted process > Accession_from_A_to_M (AY116592.1 From A to M)
[49/7e8f76] Submitted process > Accession_from_N_to_Z (NM_172078.2 From N to Z)
[3b/a95b33] Submitted process > Accession_from_A_to_M (J04346.1 From A to M)
[22/658aea] Submitted process > Accession_from_A_to_M (M74219.1 From A to M)
[46/58119e] Submitted process > Accession_from_N_to_Z (NM_172079.2 From N to Z)
[58/4e268b] Submitted process > Accession_from_A_to_M (M74216.1 From A to M)
[de/3fc7a0] Submitted process > Accession_from_A_to_M (AY116593.1 From A to M)
[c4/06ebce] Submitted process > Accession_from_N_to_Z (NM_172080.2 From N to Z)
[67/815c8c] Submitted process > Accession_from_A_to_M (K02254.1 From A to M)
[b1/aae9db] Submitted process > Accession_from_N_to_Z (NM_172081.2 From N to Z)
[2c/cee5e6] Submitted process > Accession_from_A_to_M (M22308.1 From A to M)
[df/7fb1e5] Submitted process > Accession_from_N_to_Z (NM_172082.2 From N to Z)
[9d/1f6248] Submitted process > Accession_from_A_to_M (M87502.1 From A to M)
[74/4f7afa] Submitted process > Accession_from_N_to_Z (NM_198947.3 From N to Z)
[0b/0cf2ba] Submitted process > Accession_from_A_to_M (M29287.1 From A to M)
[9a/fcd65e] Submitted process > Accession_from_A_to_M (M74218.1 From A to M)
[50/c3cb58] Submitted process > Accession_from_N_to_Z (NM_172083.2 From N to Z)
[60/6e52a4] Submitted process > Accession_from_A_to_M (AF480296.1 From A to M)
[7d/04bcbd] Submitted process > Accession_from_N_to_Z (NM_172084.2 From N to Z)
[26/0c4993] Submitted process > Accession_from_A_to_M (AF480295.1 From A to M)
[87/d45f40] Submitted process > Accession_from_N_to_Z (NM_001363989.1 From N to Z)
[49/c1cbfb] Submitted process > Accession_from_A_to_M (AF480294.1 From A to M)
[84/21dd77] Submitted process > Accession_from_N_to_Z (NM_001363990.1 From N to Z)
[f8/226158] Submitted process > Accession_from_A_to_M (AF480293.1 From A to M)
[1f/2df001] Submitted process > Accession_from_N_to_Z (NM_015981.3 From N to Z)
[50/151d1e] Submitted process > Accession_from_N_to_Z (NM_171825.2 From N to Z)
[da/10f095] Submitted process > Accession_from_A_to_M (AF480292.1 From A to M)
[3d/c49a54] Submitted process > Accession_from_N_to_Z (NM_001174053.1 From N to Z)
[7a/61ba6d] Submitted process > Accession_from_N_to_Z (NM_001174054.1 From N to Z)
[da/072bd0] Submitted process > Accession_from_A_to_M (AF480291.1 From A to M)
[51/dd97b2] Submitted process > Accession_from_N_to_Z (NM_007595.5 From N to Z)
[59/d106ee] Submitted process > Accession_from_A_to_M (AF480290.1 From A to M)
[be/e9115f] Submitted process > Accession_from_N_to_Z (NM_001164144.2 From N to Z)
[9b/bc4944] Submitted process > Accession_from_A_to_M (AF480289.1 From A to M)
[50/62fb0f] Submitted process > Accession_from_N_to_Z (NM_001164145.2 From N to Z)
[72/ce80bb] Submitted process > Accession_from_A_to_M (AF480288.1 From A to M)
[69/c7630b] Submitted process > Accession_from_A_to_M (AF480287.1 From A to M)
[c3/feba25] Submitted process > Accession_from_N_to_Z (NM_032436.3 From N to Z)
[7e/420e6f] Submitted process > Accession_from_A_to_M (AF480286.1 From A to M)
[22/6eaf49] Submitted process > Accession_from_A_to_M (AF480285.1 From A to M)
[4e/0e50eb] Submitted process > Accession_from_N_to_Z (NM_174910.2 From N to Z)
[5e/9d27b9] Submitted process > Accession_from_N_to_Z (NM_001122842.2 From N to Z)
[4b/d5c401] Submitted process > Accession_from_A_to_M (AF480284.1 From A to M)
[2c/c0f4d2] Submitted process > Accession_from_N_to_Z (NM_001199619.1 From N to Z)
[9f/d46c70] Submitted process > Accession_from_A_to_M (AF480283.1 From A to M)
[58/1e8de5] Submitted process > Accession_from_N_to_Z (NM_001199620.1 From N to Z)
[c8/1669a8] Submitted process > Accession_from_A_to_M (AF480282.1 From A to M)
[f5/b30632] Submitted process > Accession_from_N_to_Z (NM_001199621.1 From N to Z)
[30/a622ba] Submitted process > Accession_from_A_to_M (AF480281.1 From A to M)
[38/a6aab0] Submitted process > Accession_from_N_to_Z (NM_001199622.1 From N to Z)
[7f/f8a6b6] Submitted process > Accession_from_A_to_M (AF480280.1 From A to M)
[12/0b72b6] Submitted process > Accession_from_N_to_Z (NM_017590.5 From N to Z)
[32/745687] Submitted process > Accession_from_A_to_M (AF480279.1 From A to M)
[b4/96b0f9] Submitted process > Accession_from_N_to_Z (NM_181782.4 From N to Z)
[94/00994d] Submitted process > Accession_from_A_to_M (AF480278.1 From A to M)
[09/26caf8] Submitted process > Accession_from_N_to_Z (NR_138070.1 From N to Z)
[20/f1b946] Submitted process > Accession_from_A_to_M (AF480277.1 From A to M)
[28/339478] Submitted process > Accession_from_A_to_M (AF480276.1 From A to M)
[ac/10682e] Submitted process > Accession_from_N_to_Z (X65939.1 From N to Z)
[db/e2cf9a] Submitted process > Accession_from_A_to_M (AF480275.1 From A to M)
[6e/709495] Submitted process > Accession_from_N_to_Z (X65938.1 From N to Z)
[6c/6c3684] Submitted process > Accession_from_A_to_M (AF480274.1 From A to M)
[be/92d4ec] Submitted process > Accession_from_N_to_Z (X65940.1 From N to Z)
[bb/9825e0] Submitted process > Accession_from_A_to_M (AF480273.1 From A to M)
[7d/967328] Submitted process > Accession_from_A_to_M (AF480272.1 From A to M)
[53/998e31] Submitted process > Accession_from_A_to_M (AF480271.1 From A to M)
[a6/707189] Submitted process > Accession_from_N_to_Z (X14057.1 From N to Z)
[90/e64f77] Submitted process > Accession_from_A_to_M (AF480270.1 From A to M)
[99/83ba02] Submitted process > Accession_from_N_to_Z (X60546.1 From N to Z)
[2b/c9436d] Submitted process > Accession_from_A_to_M (AF480269.1 From A to M)
[1f/99e802] Submitted process > Accession_from_N_to_Z (U65924.1 From N to Z)
[f2/8c0872] Submitted process > Accession_from_A_to_M (AF480268.1 From A to M)
[a9/330eaf] Submitted process > Accession_from_N_to_Z (Z21640.1 From N to Z)
[73/bb0e5d] Submitted process > Accession_from_A_to_M (AF480267.1 From A to M)
[10/700bb4] Submitted process > Accession_from_A_to_M (AF480266.1 From A to M)
[15/10a997] Submitted process > Accession_from_N_to_Z (Z21639.1 From N to Z)
[13/49f816] Submitted process > Accession_from_A_to_M (AF480265.1 From A to M)
[16/119ba7] Submitted process > Accession_from_N_to_Z (X00421.1 From N to Z)
[07/4c9929] Submitted process > Accession_from_A_to_M (AF480264.1 From A to M)
[36/943431] Submitted process > Accession_from_N_to_Z (U88717.1 From N to Z)
[0a/057db9] Submitted process > Accession_from_A_to_M (AF480263.1 From A to M)
[11/29306c] Submitted process > Accession_from_A_to_M (CS172267.1 From A to M)
[83/3e72d7] Submitted process > Accession_from_N_to_Z (NC_029006.1 From N to Z)
[ea/60dd61] Submitted process > Accession_from_A_to_M (AF004836.1 From A to M)
[90/e3ec39] Submitted process > Accession_from_N_to_Z (XM_001460179.1 From N to Z)
[a7/c7cad2] Submitted process > Accession_from_A_to_M (AF002816.1 From A to M)
[18/36feec] Submitted process > Accession_from_N_to_Z (XM_001449677.1 From N to Z)
[b0/8d8ad8] Submitted process > Accession_from_A_to_M (AF002815.1 From A to M)
[ef/9cff73] Submitted process > Accession_from_N_to_Z (XM_001445002.1 From N to Z)
[50/7f01b9] Submitted process > Accession_from_A_to_M (CT868670.1 From A to M)
[76/2283ea] Submitted process > Accession_from_N_to_Z (XM_001441019.1 From N to Z)
[78/9dc09d] Submitted process > Accession_from_A_to_M (CT868429.1 From A to M)
[b0/c3c3d8] Submitted process > Accession_from_N_to_Z (XM_001437902.1 From N to Z)
[4c/a7cad3] Submitted process > Accession_from_A_to_M (CT868318.1 From A to M)
[96/0fbddd] Submitted process > Accession_from_N_to_Z (XM_001424708.1 From N to Z)
[2d/815285] Submitted process > Accession_from_A_to_M (KM983332.1 From A to M)
[a9/c7e846] Submitted process > Accession_from_N_to_Z (XM_001424093.1 From N to Z)
[e0/ef0a84] Submitted process > Accession_from_A_to_M (CT868274.1 From A to M)
[f1/ff76b8] Submitted process > Accession_from_N_to_Z (NM_017590.5 From N to Z)
[79/c59bfd] Submitted process > Accession_from_A_to_M (CT868085.1 From A to M)
[96/91aec0] Submitted process > Accession_from_A_to_M (CT868068.1 From A to M)
[aa/e88108] Submitted process > Accession_from_N_to_Z (NR_029944.1 From N to Z)
[45/1c8b6f] Submitted process > Accession_from_A_to_M (CT868030.1 From A to M)
[c4/44809e] Submitted process > Accession_from_A_to_M (CT867988.1 From A to M)
[82/051ab2] Submitted process > Accession_from_A_to_M (CT868163.1 From A to M)
[aa/25f70c] Submitted process > Accession_from_A_to_M (CT867991.1 From A to M)
[50/3bfbfd] Submitted process > Accession_from_A_to_M (AX244968.1 From A to M)
[c2/a154d7] Submitted process > Accession_from_A_to_M (AX244967.1 From A to M)
[81/8fdaea] Submitted process > Accession_from_A_to_M (AX244966.1 From A to M)
[b6/a8ec70] Submitted process > Accession_from_A_to_M (AX244965.1 From A to M)
[84/7dcc00] Submitted process > Accession_from_A_to_M (AX244964.1 From A to M)
[b8/a38ed0] Submitted process > Accession_from_A_to_M (AX244963.1 From A to M)
[fa/5037ac] Submitted process > Accession_from_A_to_M (AX244962.1 From A to M)
[ef/eaf3c0] Submitted process > Accession_from_A_to_M (AX244961.1 From A to M)
[1e/993429] Submitted process > Accession_from_A_to_M (LP969861.1 From A to M)
[42/54bc1f] Submitted process > Accession_from_A_to_M (LP969860.1 From A to M)
[32/71df61] Submitted process > Accession_from_A_to_M (LP969859.1 From A to M)
[9d/90c28b] Submitted process > Accession_from_A_to_M (LP969858.1 From A to M)
[a4/d07c3d] Submitted process > Accession_from_A_to_M (LP969857.1 From A to M)
[3f/52ce60] Submitted process > Accession_from_A_to_M (LP969856.1 From A to M)
[42/0c2da1] Submitted process > Accession_from_A_to_M (LP969855.1 From A to M)
[3c/2c7475] Submitted process > Accession_from_A_to_M (LP969854.1 From A to M)
[35/b9d48e] Submitted process > Accession_from_A_to_M (LP969853.1 From A to M)
[6b/8e2ac5] Submitted process > Accession_from_A_to_M (LP969852.1 From A to M)
[ca/a348fe] Submitted process > Accession_from_A_to_M (LP969851.1 From A to M)
[84/8111cf] Submitted process > Accession_from_A_to_M (LP969850.1 From A to M)
[c4/6cd11c] Submitted process > Accession_from_A_to_M (LP969849.1 From A to M)
[f4/a8978b] Submitted process > Accession_from_A_to_M (LP969848.1 From A to M)
[c4/a3c597] Submitted process > Accession_from_A_to_M (LP969847.1 From A to M)
[b0/f3f714] Submitted process > Accession_from_A_to_M (LP969846.1 From A to M)
[3c/068a27] Submitted process > Accession_from_A_to_M (LP969845.1 From A to M)
[bf/1abfa3] Submitted process > Accession_from_A_to_M (LP969844.1 From A to M)
[d7/64d546] Submitted process > Accession_from_A_to_M (LP969843.1 From A to M)
[81/9bb2a8] Submitted process > Accession_from_A_to_M (LP969842.1 From A to M)
[f8/5c3027] Submitted process > Accession_from_A_to_M (LP969841.1 From A to M)
[e3/d17474] Submitted process > Accession_from_A_to_M (LP969840.1 From A to M)
[93/a56b85] Submitted process > Accession_from_A_to_M (LP969839.1 From A to M)
[7e/0b6a98] Submitted process > Accession_from_A_to_M (LP969838.1 From A to M)
[b0/86028f] Submitted process > Accession_from_A_to_M (LP969837.1 From A to M)
[59/b0e373] Submitted process > Accession_from_A_to_M (LP969836.1 From A to M)
[f7/c4ec38] Submitted process > Accession_from_A_to_M (LP969834.1 From A to M)
[16/fdb882] Submitted process > Accession_from_A_to_M (LP969832.1 From A to M)
[64/a2656a] Submitted process > Accession_from_A_to_M (AF338248.1 From A to M)
[f1/d7a7e1] Submitted process > Accession_from_A_to_M (AF338247.1 From A to M)
[2b/ee2b50] Submitted process > Accession_from_A_to_M (AF338246.1 From A to M)
[6b/972c96] Submitted process > Accession_from_A_to_M (AF338245.1 From A to M)
[24/bf2ef1] Submitted process > Accession_from_A_to_M (AF338244.1 From A to M)
[e0/b906bd] Submitted process > Accession_from_A_to_M (AF188530.1 From A to M)
[2b/7fb543] Submitted process > Accession_from_A_to_M (AF004836.1 From A to M)
[fc/e4837c] Submitted process > Accession_from_A_to_M (AF002816.1 From A to M)
[a9/4d189d] Submitted process > Accession_from_A_to_M (AF002815.1 From A to M)
[73/6a68d9] Submitted process > Accession_from_A_to_M (FJ475056.1 From A to M)
[0d/1f194a] Submitted process > Accession_from_A_to_M (FJ475055.1 From A to M)
[c2/ae2fd4] Submitted process > Accession_from_A_to_M (JX417182.1 From A to M)
[75/160184] Submitted process > Accession_from_A_to_M (JX417181.1 From A to M)
[f5/041d3b] Submitted process > Accession_from_A_to_M (JX417180.1 From A to M)
[f8/00a141] Submitted process > Accession_from_A_to_M (JQ687100.1 From A to M)
[0d/fa5dee] Submitted process > Accession_from_A_to_M (JQ687099.1 From A to M)
[70/eff49c] Submitted process > Accession_from_A_to_M (GU144588.1 From A to M)
[41/a37961] Submitted process > Accession_from_A_to_M (AY116592.1 From A to M)
[20/50b7da] Submitted process > Accession_from_A_to_M (AF188126.1 From A to M)
[55/2f5cee] Submitted process > Accession_from_A_to_M (AX244968.1 From A to M)
[ff/efc0b4] Submitted process > Accession_from_A_to_M (AX244967.1 From A to M)
[c0/4b3928] Submitted process > Accession_from_A_to_M (AX244966.1 From A to M)
[e5/f4e5f9] Submitted process > Accession_from_A_to_M (AX244965.1 From A to M)
[e4/4e3d48] Submitted process > Accession_from_A_to_M (AX244964.1 From A to M)
[e6/c81f39] Submitted process > Accession_from_A_to_M (AX244963.1 From A to M)
[96/e40f8d] Submitted process > Accession_from_A_to_M (AX244962.1 From A to M)
[d2/f0fc28] Submitted process > Accession_from_A_to_M (AX244961.1 From A to M)
[e5/1d9df4] Submitted process > Accession_from_A_to_M (AJ279563.1 From A to M)
[57/874654] Submitted process > Accession_from_A_to_M (AJ279561.1 From A to M)
[d8/b31af5] Submitted process > Accession_from_A_to_M (AJ279560.1 From A to M)
[ea/eb0cc0] Submitted process > Accession_from_A_to_M (AJ279559.1 From A to M)
[b5/b8605d] Submitted process > Accession_from_A_to_M (AJ279558.1 From A to M)
[13/6d9aa6] Submitted process > Accession_from_A_to_M (AJ279557.1 From A to M)
[24/64b2ac] Submitted process > Accession_from_A_to_M (AJ279556.1 From A to M)
[e1/3d43a1] Submitted process > Accession_from_A_to_M (AJ279555.1 From A to M)
[ce/04e7f9] Submitted process > Accession_from_A_to_M (AJ279554.1 From A to M)
[e9/ccaffd] Submitted process > Accession_from_A_to_M (A12993.1 From A to M)
[f1/f3b590] Submitted process > Accession_from_A_to_M (A12992.1 From A to M)
[f5/a2e0e7] Submitted process > Accession_from_A_to_M (A12991.1 From A to M)
[f6/c4f199] Submitted process > Accession_from_A_to_M (A12990.1 From A to M)
[37/0b48bb] Submitted process > Accession_from_A_to_M (A12989.1 From A to M)
[2e/f7ffbc] Submitted process > Accession_from_A_to_M (A12988.1 From A to M)
[d2/178900] Submitted process > Accession_from_A_to_M (A12987.1 From A to M)
[68/e7e386] Submitted process > Accession_from_A_to_M (A12986.1 From A to M)
[38/fa9dc9] Submitted process > Accession_from_A_to_M (A12985.1 From A to M)
[99/bd96a9] Submitted process > Accession_from_A_to_M (A12997.1 From A to M)
[cc/01da50] Submitted process > Accession_from_A_to_M (A12996.1 From A to M)
[b9/a17d5a] Submitted process > Accession_from_A_to_M (A12995.1 From A to M)
[6b/a56850] Submitted process > Accession_from_A_to_M (A12994.1 From A to M)
```


## Files

```
work/9f/d46c70c48cb7d05427c24fbfbbf8fb/AF480283.1.am.txt
work/38/a6aab032b4aca0fb5c3127926d5520/NM_001199622.1.nz.txt
work/38/da95025d91936b27d117f868410395/NM_003636.3.nz.txt
work/38/fa9dc95de6630f4d0f32d418880729/A12985.1.am.txt
work/7f/f8a6b6acd25ee455ba53cb79725510/AF480280.1.am.txt
work/9a/fcd65e92f698d586afdd5e68064869/M74218.1.am.txt
work/57/874654194f9306ce999d935d36e775/AJ279561.1.am.txt
work/57/fb593fb60aa9dd37d990ae564df997/AF002816.1.am.txt
work/0d/1f194a965bfc24592534d0172a39a5/FJ475055.1.am.txt
work/0d/fa5deec4988e9af3f83a8c72b706cb/JQ687099.1.am.txt
work/58/1e8de55daf7c7147fb03ebbe108148/NM_001199620.1.nz.txt
work/58/4e268bd3df85d2e203409ca9c1bf24/M74216.1.am.txt
work/6b/a568504ca7817f2c9de745650ec3b4/A12994.1.am.txt
work/6b/8e2ac5500ad6e0bc6f0d3c999dbfdc/LP969852.1.am.txt
work/6b/972c968454b14ed4bcd85223b1af57/AF338245.1.am.txt
work/18/36feeccc8c5eb5894e9705e128f8d4/XM_001449677.1.nz.txt
work/f8/00a1414b82e41bbe7845fb393fae1b/JQ687100.1.am.txt
work/f8/226158b29279ebbcb7c9645b15af65/AF480293.1.am.txt
work/f8/5c3027e04bdccf06ec904d8fb398ff/LP969841.1.am.txt
work/c3/feba2575503877070435e520394b41/NM_032436.3.nz.txt
work/1e/99342973460c5b5e1048d530541bcf/LP969861.1.am.txt
work/93/ba541f3fb43411ceb562ce6e07cfa6/AF002815.1.am.txt
work/93/a56b858510cd57f9c207c57ff93f9b/LP969839.1.am.txt
work/0a/057db9d008f697d44caa2fe1151b6e/AF480263.1.am.txt
work/07/4c992993230643a9fcd75dfc3366ad/AF480264.1.am.txt
work/59/d106ee165e071e6c916d1cac5651d4/AF480290.1.am.txt
work/59/b0e37340652615f2938980ee5038b2/LP969836.1.am.txt
work/d8/b31af55633211ff0fb5efb3222a39e/AJ279560.1.am.txt
work/d7/64d546bb48c8c42d03a8caf9a83c17/LP969843.1.am.txt
work/5c/a4e797dd51fb51899fb9913a95f18e/AF004836.1.am.txt
work/b0/8d8ad80ee5e2f9e3ef0df09e9962e4/AF002815.1.am.txt
work/b0/86028f09a6c6df0fda7325ebf95711/LP969837.1.am.txt
work/b0/f3f714100013b5c86ab7698a229a39/LP969846.1.am.txt
work/b0/c3c3d86b581e292503b8a0ba97f801/XM_001437902.1.nz.txt
work/82/051ab21320032909abd18de2b19a30/CT868163.1.am.txt
work/22/6eaf4929c5a73bb50b94b0944fa65f/AF480285.1.am.txt
work/22/658aea2a6141649d5f9e7c3629961b/M74219.1.am.txt
work/ef/9cff7331db92bcde0334d94b91fa17/XM_001445002.1.nz.txt
work/ef/eaf3c0da64ddc1ac68841fd7a98f4c/AX244961.1.am.txt
work/fc/e4837c9bc2fcc5793bcebdba921aca/AF002816.1.am.txt
work/a4/d07c3dea29283bdcbcad9b215bacc2/LP969857.1.am.txt
work/32/7456876ae3d0a26f98f631f31616ae/AF480279.1.am.txt
work/32/71df61ba27049a2ab75061951435ac/LP969859.1.am.txt
work/13/49f81659f01bab38ef8a2710239739/AF480265.1.am.txt
work/13/6d9aa61775592df2ccdb27d7568633/AJ279557.1.am.txt
work/3d/c49a549c99b9a221b44552ea3fae5a/NM_001174053.1.nz.txt
work/b5/b8605d7235bfcb33f1b6a66dcb45d6/AJ279558.1.am.txt
work/b5/c01221f0136660f8974ddf2472d1c5/NM_001199862.1.nz.txt
work/69/c7630b16c1902f8a72304e088f5d8e/AF480287.1.am.txt
work/9d/1f6248afb6c6b59cf833afec23f093/M87502.1.am.txt
work/9d/90c28b9bdc6af56897b2a0148220d1/LP969858.1.am.txt
work/f2/8c0872f2b654a233c39e75c88d2959/AF480268.1.am.txt
work/cc/01da5069766ca90c3cf52b7dc62dcf/A12996.1.am.txt
work/e4/4e3d4870d98281b49d36a1952f9bc1/AX244964.1.am.txt
work/ff/efc0b42ca7b2acade19b2c7998f369/AX244967.1.am.txt
work/36/943431e1f66df8d1c5abd4e737e901/U88717.1.nz.txt
work/36/49ba2e63d078c993317c275806e82e/CS172270.1.am.txt
work/15/10a9971cdb609c9f9dbd0f2b35313e/Z21639.1.nz.txt
work/4b/d5c401122eab3fa0f1df8903119144/AF480284.1.am.txt
work/c0/4b39284837d95ba221ad608d9c2329/AX244966.1.am.txt
work/50/62fb0fb0a04f03338b12b741d2944b/NM_001164145.2.nz.txt
work/50/7f01b977ada07ce9f3a5b787ed1a62/CT868670.1.am.txt
work/50/c3cb588465d1b3b66af3e7b2369583/NM_172083.2.nz.txt
work/50/151d1ea8cedd672b69033573f887c3/NM_171825.2.nz.txt
work/50/3bfbfd5520fbc8b8f120da18eab2df/AX244968.1.am.txt
work/16/fdb88231eeffacd174efaff879d403/LP969832.1.am.txt
work/16/119ba7b8124ef51cd51a446f1e111c/X00421.1.nz.txt
work/bb/9825e048699eb130fafe6100e078d3/AF480273.1.am.txt
work/f4/a8978b6e9a89fbbcb1c721ed00feac/LP969848.1.am.txt
work/10/700bb4e94c2fb1a5b5cc68319c227b/AF480266.1.am.txt
work/a7/c7cad2abef086fa314e15f634c9502/AF002816.1.am.txt
work/9e/57bd24c2038ec41af94e38e3f0c8b0/NM_001199863.1.nz.txt
work/e6/c81f395f394db2a13f381ea332496a/AX244963.1.am.txt
work/84/7dcc003070c4445d95a027fe72eb71/AX244964.1.am.txt
work/84/21dd7778c0bd75677f051670ea796e/NM_001363990.1.nz.txt
work/84/8111cf9d923f95eb9b958ee81bf760/LP969850.1.am.txt
work/4c/a7cad38af10938e77aa4e39cde6104/CT868318.1.am.txt
work/c2/a154d74602c0c92303c0dc3e2f63b6/AX244967.1.am.txt
work/c2/ae2fd4ce04db5f86219c2913607d6f/JX417182.1.am.txt
work/5e/9d27b932f378f88c10291158e4c25c/NM_001122842.2.nz.txt
work/73/6a68d9bd57bf1f337661d40dd89a37/FJ475056.1.am.txt
work/73/bb0e5d19f10aa5a70a2900914454ed/AF480267.1.am.txt
work/cf/c829af1dd7c6ad26c0b52cf3f0f425/NM_001293170.1.nz.txt
work/67/815c8c568afe1e0bb2a9d907cbce7c/K02254.1.am.txt
work/7a/e2042e7e524f71ea3dab3eb7f8e911/NM_001220.4.nz.txt
work/7a/61ba6d4c7f6f1232d3485becf4c577/NM_001174054.1.nz.txt
work/1f/99e80228ffcb3e01195af686d52969/U65924.1.nz.txt
work/1f/2df001d5954a7d646df11406a33294/NM_015981.3.nz.txt
work/0e/00e5ca995a72c08d4155149a9e2751/AF188126.1.am.txt
work/75/160184bf0f0085722aabf6c57328c8/JX417181.1.am.txt
work/7e/420e6f3276765afb156ae7ab3d9c99/AF480286.1.am.txt
work/7e/0b6a986dfa76113285448189d18d82/LP969838.1.am.txt
work/6e/709495b607fc886e2c84c367b830fa/X65938.1.nz.txt
work/ca/eacc8c4d34f90eb622c384a93c2023/NM_001142703.1.nz.txt
work/ca/a348fed1894835f3650d504c6dfd72/LP969851.1.am.txt
work/09/26caf80bf4895d52ffc806ec6fa6c1/NR_138070.1.nz.txt
work/c8/1669a8f61c54403f5b868c8f1e0e06/AF480282.1.am.txt
work/96/0fbddda9d9ce113d7461c92d655e14/XM_001424708.1.nz.txt
work/96/91aec004a0fd2be9606618117e3d2c/CT868068.1.am.txt
work/96/e40f8d219e0cd5da15fb14b050133b/AX244962.1.am.txt
work/76/2283ea4256a6baa3407e1243e11fe5/XM_001441019.1.nz.txt
work/d2/f0fc284606a4d6963a5146e393ace5/AX244961.1.am.txt
work/d2/178900352cbf5dc741dc03961b4970/A12987.1.am.txt
work/4e/0e50eb7beae75b0a91dbd778812961/NM_174910.2.nz.txt
work/37/0b48bb77ee5bcf22f4eca4eef9d819/A12989.1.am.txt
work/2d/8152852f930f6b9724f6ad2fc91899/KM983332.1.am.txt
work/f5/b30632e42a2a3791d6319daf3be22c/NM_001199621.1.nz.txt
work/f5/041d3beb689ccc6db8b81665c1f983/JX417180.1.am.txt
work/f5/a2e0e7c048c5a71f02a49db7cfa9eb/A12991.1.am.txt
work/de/3fc7a0accb91d7bd58b8be6767dc4a/AY116593.1.am.txt
work/a6/707189f644bbf08264b26befd59975/X14057.1.nz.txt
work/ac/10682e67f1f137095cf88d8d4ce060/X65939.1.nz.txt
work/12/0b72b69d6c529d0a3a8b4727375bef/NM_017590.5.nz.txt
work/2b/7fb543d95ebb496c8d85693b94b723/AF004836.1.am.txt
work/2b/ee2b509a66c6ca3f94a2f482532ceb/AF338246.1.am.txt
work/2b/c9436d08c4b6af30e9a5d8b241da37/AF480269.1.am.txt
work/e0/b906bd0f867a0c45cdc2b1cfc78905/AF188530.1.am.txt
work/e0/ef0a84831e2a210c6ad6ffb786c413/CT868274.1.am.txt
work/c6/d4e5cf64437c75fac5d040fc5a6921/NM_172130.2.nz.txt
work/c6/de36e9464db44e7272105a7ed6327d/M74217.1.am.txt
work/49/7e8f767156f6c604040379c2255ab1/NM_172078.2.nz.txt
work/49/c1cbfb097b1b62df4bdc6859ed3dc8/AF480294.1.am.txt
work/3c/2c7475757e1451c8b43049f2661fec/LP969854.1.am.txt
work/3c/068a27c7a08527f4f5f013f6ee102d/LP969845.1.am.txt
work/00/b43bfff72af2e04c19fe6b8c3c02ca/AY116592.1.am.txt
work/2e/f7ffbc1b32c2ae9be3108465723670/A12988.1.am.txt
work/64/a2656a4bff19e684da424777765d30/AF338248.1.am.txt
work/b6/a8ec70c0ed37a2dcf5ae6d77c571d3/AX244965.1.am.txt
work/a9/4d189d3f798daad72fe6e76519e1bc/AF002815.1.am.txt
work/a9/c7e84605eea5cfdad2703cd8d33785/XM_001424093.1.nz.txt
work/a9/330eafd64a1a23512694805b271c4e/Z21640.1.nz.txt
work/da/10f095afe062f65286561b9efb3d57/AF480292.1.am.txt
work/da/072bd09fc29bd893affd3f99bf2f0e/AF480291.1.am.txt
work/b4/96b0f9e1b67c1c027cbde66fd893c2/NM_181782.4.nz.txt
work/e5/1d9df44f5a241a9f6ac20b3c3c4d86/AJ279563.1.am.txt
work/e5/f4e5f9e3e50fed7a7db68d875d8de3/AX244965.1.am.txt
work/11/29306c557ba3ae4120de6d5356c316/CS172267.1.am.txt
work/e1/3d43a11f4db87a9c27d2561fd3550d/AJ279555.1.am.txt
work/aa/25f70c3f833ef45e2845ef4588b0fe/CT867991.1.am.txt
work/aa/e881081b393cf32b03a05bf5f23c22/NR_029944.1.nz.txt
work/60/6e52a4292bd432660b0676587d937f/AF480296.1.am.txt
work/7d/9673287f97471927ff2ca120c0ca31/AF480272.1.am.txt
work/7d/04bcbdf7f58101a670f2d5e947b35c/NM_172084.2.nz.txt
work/51/dd97b27ec0a4ffe775b72fd76ecc71/NM_007595.5.nz.txt
work/28/339478f255abe8304250804af3dc7a/AF480276.1.am.txt
work/9b/bc49443ec49d1d21c2e7d9ae44c215/AF480289.1.am.txt
work/42/0c2da13afdc64e499f5440921e4dd7/LP969855.1.am.txt
work/42/54bc1fb3592d28373d5613d6c3b437/LP969860.1.am.txt
work/e9/ccaffd101d15e036dcea8f22eb09e9/A12993.1.am.txt
work/79/c59bfd00de14f94aca7afc05566c00/CT868085.1.am.txt
work/79/0417e0b44dd4ebbe4034cb41e42c83/NM_001199861.1.nz.txt
work/83/3e72d7c34e1dad85a29bc3c40de376/NC_029006.1.nz.txt
work/81/9bb2a838cb31a25a363f3490012636/LP969842.1.am.txt
work/81/8fdaeab723c666144047af145ecf61/AX244966.1.am.txt
work/68/e7e386baca887c7e2a02a08856076c/A12986.1.am.txt
work/e3/d17474b1749d9d377ec16d065b6ced/LP969840.1.am.txt
work/90/e64f779222f6d1859abdfd044eaf81/AF480270.1.am.txt
work/90/e3ec392074c80af80e0cb2a4b70bdb/XM_001460179.1.nz.txt
work/74/4f7afa136dcd0824fce541a50f332e/NM_198947.3.nz.txt
work/c4/06ebcee446144e6f73e65318bcd16c/NM_172080.2.nz.txt
work/c4/6cd11c0f46aa45524357a390bbb069/LP969849.1.am.txt
work/c4/44809e74f00639ed04f265003ec885/CT867988.1.am.txt
work/c4/a3c597d314f85e0f0232550e029660/LP969847.1.am.txt
work/41/a37961a4644f31830a94523dcfc38c/AY116592.1.am.txt
work/bf/1abfa31f4484c6d958eb1e3009d9ea/LP969844.1.am.txt
work/46/5691f37619d1a1264f3b35b9379ff0/NM_001142704.1.nz.txt
work/46/58119e07c2db0b9a15f54e66511e95/NM_172079.2.nz.txt
work/53/998e31416b10e7ae310d2aa07aef9e/AF480271.1.am.txt
work/f1/d7a7e1c4da8478ed47cd6a829c74fa/AF338247.1.am.txt
work/f1/ff76b8c929a28d2451f18b717ef395/NM_017590.5.nz.txt
work/f1/f3b5902d1e39a1015c7558805b405f/A12992.1.am.txt
work/df/7fb1e54c7fab694bf3d0ca49d7d206/NM_172082.2.nz.txt
work/72/ce80bb945752bf224a73ebbbf1d473/AF480288.1.am.txt
work/f7/c4ec3872cafd80d1026a4b668170bf/LP969834.1.am.txt
work/3b/443ab37b33a319087fcb2e0e17340c/AF188126.1.am.txt
work/3b/a95b330cf9ebb0563360897e1f5ab9/J04346.1.am.txt
work/78/9dc09d597a9a6d8b4a62d567f67ce2/CT868429.1.am.txt
work/86/b6a51956a716a2d45932c9e7a1e973/CS172261.1.am.txt
work/be/92d4ec0004d0e8378892d7e7ca2286/X65940.1.nz.txt
work/be/e9115fba10dd61b173eab50ea3d471/NM_001164144.2.nz.txt
work/70/eff49cfc559d74aa3b4b08b4b7eb67/GU144588.1.am.txt
work/ea/eb0cc08b2fedf5be667a4dab5145d4/AJ279559.1.am.txt
work/ea/60dd61edb301a037b57fc8974fc4c2/AF004836.1.am.txt
work/6c/6c36846b28fd7cd44e173255bde726/AF480274.1.am.txt
work/35/b9d48e90a5aa4af26fd512e85a4e07/LP969853.1.am.txt
work/26/0c4993f2a528301720273895dda048/AF480295.1.am.txt
work/2c/cee5e60365ed1cb7de9d267675ff10/M22308.1.am.txt
work/2c/c0f4d280f974c7399bf7889f2efb24/NM_001199619.1.nz.txt
work/b1/aae9db240556af90d389fa037a15fa/NM_172081.2.nz.txt
work/55/2f5cee977b1da4d0f2f19813e1f6bf/AX244968.1.am.txt
work/87/d45f4079f6ebb835e0fa53e2234d34/NM_001363989.1.nz.txt
work/0b/0cf2ba4b3d71fb216b4f803393a7d3/M29287.1.am.txt
work/0b/4a17d33799d0dc038bbb1e72f01c61/NM_001199860.1.nz.txt
work/fa/5037ac161434e3187427f14de42618/AX244962.1.am.txt
work/db/e2cf9af1209eea19641734d9838963/AF480275.1.am.txt
work/30/a622bac9830991b079433ccf76d931/AF480281.1.am.txt
work/45/1c8b6f61767803f9db6a098e04920a/CT868030.1.am.txt
work/3f/52ce6050b30b6f75360128375a7aa7/LP969856.1.am.txt
work/20/f1b94673b2a8f40584f8de31162bb0/AF480277.1.am.txt
work/20/50b7da68a5b2aa90efe766ed75b16a/AF188126.1.am.txt
work/24/bf2ef1a9ea30ab8ad84e762f173e8b/AF338244.1.am.txt
work/24/64b2ac68814aefcd6aed33cd4166e8/AJ279556.1.am.txt
work/ce/04e7f9040868e9e4c9ff5822f94781/AJ279554.1.am.txt
work/b9/a17d5a71d536d69be545e7d8ab9fef/A12995.1.am.txt
work/fe/8e69e8f7dd3616841698e1e8aa545c/AF188530.1.am.txt
work/b8/a38ed00c73695e8b31e34e71c6c183/AX244963.1.am.txt
work/f6/c4f199e41323908ea8de01b80db32f/A12990.1.am.txt
work/99/83ba02897923d349049aced4e408e1/X60546.1.nz.txt
work/99/bd96a9d78a603ad057c533c10ff002/A12997.1.am.txt
work/94/00994d274e4490fe3a9665836431fa/AF480278.1.am.txt
```


