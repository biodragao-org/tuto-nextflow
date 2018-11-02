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
Launching `workflow.nf` [elated_thompson] - revision: ce9cc7016c
[warm up] executor > local
[e4/9146a5] Submitted process > Accession_from_N_to_Z (NM_001293170.1 From N to Z)
[2a/3949be] Submitted process > Accession_from_A_to_M (AF188530.1 From A to M)
[6c/1708e3] Submitted process > Accession_from_N_to_Z (NM_001199860.1 From N to Z)
[c0/e42aaa] Submitted process > Accession_from_A_to_M (AF188126.1 From A to M)
[8c/760e1d] Submitted process > Accession_from_N_to_Z (NM_001199861.1 From N to Z)
[15/58ac15] Submitted process > Accession_from_A_to_M (AF004836.1 From A to M)
[f8/195d0e] Submitted process > Accession_from_N_to_Z (NM_001199862.1 From N to Z)
[85/d2a669] Submitted process > Accession_from_A_to_M (AF002816.1 From A to M)
[97/b432d5] Submitted process > Accession_from_N_to_Z (NM_001199863.1 From N to Z)
[c9/9834f0] Submitted process > Accession_from_A_to_M (AF002815.1 From A to M)
[0c/86bc16] Submitted process > Accession_from_N_to_Z (NM_003636.3 From N to Z)
[0e/632c62] Submitted process > Accession_from_A_to_M (CS172270.1 From A to M)
[1f/9a3a40] Submitted process > Accession_from_N_to_Z (NM_172130.2 From N to Z)
[3e/607669] Submitted process > Accession_from_N_to_Z (NM_001142703.1 From N to Z)
[23/111c10] Submitted process > Accession_from_A_to_M (CS172261.1 From A to M)
[50/ee469a] Submitted process > Accession_from_N_to_Z (NM_001142704.1 From N to Z)
[02/acd295] Submitted process > Accession_from_A_to_M (AF188126.1 From A to M)
[7f/8d446f] Submitted process > Accession_from_N_to_Z (NM_001220.4 From N to Z)
[3e/5d2fe4] Submitted process > Accession_from_A_to_M (M74217.1 From A to M)
[2e/4def86] Submitted process > Accession_from_N_to_Z (NM_172078.2 From N to Z)
[1b/1c575b] Submitted process > Accession_from_A_to_M (AY116592.1 From A to M)
[e3/c329f6] Submitted process > Accession_from_N_to_Z (NM_172079.2 From N to Z)
[92/73cecd] Submitted process > Accession_from_A_to_M (J04346.1 From A to M)
[59/122397] Submitted process > Accession_from_N_to_Z (NM_172080.2 From N to Z)
[6d/c6dac3] Submitted process > Accession_from_A_to_M (M74219.1 From A to M)
[a9/6d86c1] Submitted process > Accession_from_A_to_M (M74216.1 From A to M)
[e9/85cd26] Submitted process > Accession_from_N_to_Z (NM_172081.2 From N to Z)
[79/f84cdf] Submitted process > Accession_from_A_to_M (AY116593.1 From A to M)
[90/2649f4] Submitted process > Accession_from_N_to_Z (NM_172082.2 From N to Z)
[27/8ec407] Submitted process > Accession_from_A_to_M (K02254.1 From A to M)
[f7/f17a63] Submitted process > Accession_from_A_to_M (M22308.1 From A to M)
[26/258b1d] Submitted process > Accession_from_N_to_Z (NM_198947.3 From N to Z)
[d3/be3c16] Submitted process > Accession_from_A_to_M (M87502.1 From A to M)
[94/f75344] Submitted process > Accession_from_N_to_Z (NM_172083.2 From N to Z)
[f9/2baeda] Submitted process > Accession_from_A_to_M (M29287.1 From A to M)
[af/e1ac85] Submitted process > Accession_from_A_to_M (M74218.1 From A to M)
[16/2a0e48] Submitted process > Accession_from_N_to_Z (NM_172084.2 From N to Z)
[5d/832bc0] Submitted process > Accession_from_A_to_M (AF480296.1 From A to M)
[3c/62e7d8] Submitted process > Accession_from_N_to_Z (NM_001363989.1 From N to Z)
[52/323d09] Submitted process > Accession_from_A_to_M (AF480295.1 From A to M)
[fe/b56b0c] Submitted process > Accession_from_N_to_Z (NM_001363990.1 From N to Z)
[5e/315264] Submitted process > Accession_from_A_to_M (AF480294.1 From A to M)
[54/ca68f5] Submitted process > Accession_from_N_to_Z (NM_015981.3 From N to Z)
[93/5128da] Submitted process > Accession_from_N_to_Z (NM_171825.2 From N to Z)
[af/079265] Submitted process > Accession_from_A_to_M (AF480293.1 From A to M)
[da/bcf87a] Submitted process > Accession_from_N_to_Z (NM_001174053.1 From N to Z)
[da/35fe56] Submitted process > Accession_from_A_to_M (AF480292.1 From A to M)
[65/a4697b] Submitted process > Accession_from_N_to_Z (NM_001174054.1 From N to Z)
[e8/bde45c] Submitted process > Accession_from_A_to_M (AF480291.1 From A to M)
[73/547f1d] Submitted process > Accession_from_A_to_M (AF480290.1 From A to M)
[0e/957fd7] Submitted process > Accession_from_N_to_Z (NM_007595.5 From N to Z)
[b7/728d5e] Submitted process > Accession_from_A_to_M (AF480289.1 From A to M)
[bc/6a1de3] Submitted process > Accession_from_N_to_Z (NM_001164144.2 From N to Z)
[a4/6f4dca] Submitted process > Accession_from_N_to_Z (NM_001164145.2 From N to Z)
[fa/556e07] Submitted process > Accession_from_A_to_M (AF480288.1 From A to M)
[e6/0a5fc3] Submitted process > Accession_from_N_to_Z (NM_032436.3 From N to Z)
[26/db6a7c] Submitted process > Accession_from_A_to_M (AF480287.1 From A to M)
[58/6fc9bc] Submitted process > Accession_from_N_to_Z (NM_174910.2 From N to Z)
[80/44bd32] Submitted process > Accession_from_A_to_M (AF480286.1 From A to M)
[eb/037ffd] Submitted process > Accession_from_N_to_Z (NM_001122842.2 From N to Z)
[80/7da491] Submitted process > Accession_from_N_to_Z (NM_001199619.1 From N to Z)
[0f/020a57] Submitted process > Accession_from_A_to_M (AF480285.1 From A to M)
[50/f9f6b7] Submitted process > Accession_from_A_to_M (AF480284.1 From A to M)
[29/4f3ee5] Submitted process > Accession_from_N_to_Z (NM_001199620.1 From N to Z)
[d6/702e9b] Submitted process > Accession_from_N_to_Z (NM_001199621.1 From N to Z)
[2a/fdf207] Submitted process > Accession_from_A_to_M (AF480283.1 From A to M)
[e4/a25787] Submitted process > Accession_from_N_to_Z (NM_001199622.1 From N to Z)
[36/808881] Submitted process > Accession_from_A_to_M (AF480282.1 From A to M)
[26/004e67] Submitted process > Accession_from_N_to_Z (NM_017590.5 From N to Z)
[92/bd0864] Submitted process > Accession_from_A_to_M (AF480281.1 From A to M)
[9d/ddab13] Submitted process > Accession_from_N_to_Z (NM_181782.4 From N to Z)
[0a/def4c4] Submitted process > Accession_from_A_to_M (AF480280.1 From A to M)
[00/760498] Submitted process > Accession_from_N_to_Z (NR_138070.1 From N to Z)
[5c/0e81dc] Submitted process > Accession_from_A_to_M (AF480279.1 From A to M)
[77/618973] Submitted process > Accession_from_A_to_M (AF480278.1 From A to M)
[e1/e0edaa] Submitted process > Accession_from_N_to_Z (X65939.1 From N to Z)
[41/fd3edb] Submitted process > Accession_from_A_to_M (AF480277.1 From A to M)
[ce/1e77a2] Submitted process > Accession_from_A_to_M (AF480276.1 From A to M)
[b5/b6626b] Submitted process > Accession_from_N_to_Z (X65938.1 From N to Z)
[64/9f308f] Submitted process > Accession_from_A_to_M (AF480275.1 From A to M)
[52/59c8ab] Submitted process > Accession_from_N_to_Z (X65940.1 From N to Z)
[23/7dfb36] Submitted process > Accession_from_A_to_M (AF480274.1 From A to M)
[cd/f609f0] Submitted process > Accession_from_N_to_Z (X14057.1 From N to Z)
[31/6c18ae] Submitted process > Accession_from_A_to_M (AF480273.1 From A to M)
[10/3dfe4e] Submitted process > Accession_from_N_to_Z (X60546.1 From N to Z)
[45/59ba06] Submitted process > Accession_from_A_to_M (AF480272.1 From A to M)
[5b/9e9bf3] Submitted process > Accession_from_A_to_M (AF480271.1 From A to M)
[08/a08bbd] Submitted process > Accession_from_A_to_M (AF480270.1 From A to M)
[46/56ce9f] Submitted process > Accession_from_N_to_Z (U65924.1 From N to Z)
[93/a3128b] Submitted process > Accession_from_N_to_Z (Z21640.1 From N to Z)
[d2/1c857d] Submitted process > Accession_from_A_to_M (AF480269.1 From A to M)
[f9/3c4f55] Submitted process > Accession_from_N_to_Z (Z21639.1 From N to Z)
[ad/d76e0e] Submitted process > Accession_from_A_to_M (AF480268.1 From A to M)
[91/189d8b] Submitted process > Accession_from_N_to_Z (X00421.1 From N to Z)
[fb/2fb4f4] Submitted process > Accession_from_A_to_M (AF480267.1 From A to M)
[aa/75bd31] Submitted process > Accession_from_A_to_M (AF480266.1 From A to M)
[90/18a7ab] Submitted process > Accession_from_N_to_Z (U88717.1 From N to Z)
[b6/e47ec2] Submitted process > Accession_from_A_to_M (AF480265.1 From A to M)
[0f/094944] Submitted process > Accession_from_N_to_Z (NC_029006.1 From N to Z)
[27/f82297] Submitted process > Accession_from_A_to_M (AF480264.1 From A to M)
[b2/1efe65] Submitted process > Accession_from_N_to_Z (XM_001460179.1 From N to Z)
[ef/f1dcb0] Submitted process > Accession_from_A_to_M (AF480263.1 From A to M)
[af/b43208] Submitted process > Accession_from_N_to_Z (XM_001449677.1 From N to Z)
[7a/cfad66] Submitted process > Accession_from_A_to_M (CS172267.1 From A to M)
[72/94a250] Submitted process > Accession_from_N_to_Z (XM_001445002.1 From N to Z)
[57/06cb80] Submitted process > Accession_from_A_to_M (AF004836.1 From A to M)
[bd/2b4975] Submitted process > Accession_from_N_to_Z (XM_001441019.1 From N to Z)
[11/0918e8] Submitted process > Accession_from_A_to_M (AF002816.1 From A to M)
[94/d6ab39] Submitted process > Accession_from_A_to_M (AF002815.1 From A to M)
[26/b30fb5] Submitted process > Accession_from_N_to_Z (XM_001437902.1 From N to Z)
[1e/266ebc] Submitted process > Accession_from_A_to_M (CT868670.1 From A to M)
[60/ed7547] Submitted process > Accession_from_N_to_Z (XM_001424708.1 From N to Z)
[33/f87d1f] Submitted process > Accession_from_A_to_M (CT868429.1 From A to M)
[26/4e8e47] Submitted process > Accession_from_N_to_Z (XM_001424093.1 From N to Z)
[cb/7aebcf] Submitted process > Accession_from_A_to_M (CT868318.1 From A to M)
[37/af2fe9] Submitted process > Accession_from_N_to_Z (NM_017590.5 From N to Z)
[5b/fdfa7a] Submitted process > Accession_from_N_to_Z (NR_029944.1 From N to Z)
[64/b9d489] Submitted process > Accession_from_A_to_M (KM983332.1 From A to M)
[78/968c4a] Submitted process > Accession_from_A_to_M (CT868274.1 From A to M)
[51/6a1381] Submitted process > Accession_from_A_to_M (CT868085.1 From A to M)
[eb/9753d2] Submitted process > Accession_from_A_to_M (CT868068.1 From A to M)
[c0/0a2e7f] Submitted process > Accession_from_A_to_M (CT868030.1 From A to M)
[98/4bb5f7] Submitted process > Accession_from_A_to_M (CT867988.1 From A to M)
[e0/16a850] Submitted process > Accession_from_A_to_M (CT868163.1 From A to M)
[23/e579c8] Submitted process > Accession_from_A_to_M (CT867991.1 From A to M)
[94/f919de] Submitted process > Accession_from_A_to_M (AX244968.1 From A to M)
[a3/0b11cf] Submitted process > Accession_from_A_to_M (AX244967.1 From A to M)
[01/1474a0] Submitted process > Accession_from_A_to_M (AX244966.1 From A to M)
[0d/cc1b91] Submitted process > Accession_from_A_to_M (AX244965.1 From A to M)
[d2/55021a] Submitted process > Accession_from_A_to_M (AX244964.1 From A to M)
[19/eef74c] Submitted process > Accession_from_A_to_M (AX244963.1 From A to M)
[c2/9addb0] Submitted process > Accession_from_A_to_M (AX244962.1 From A to M)
[0d/91b518] Submitted process > Accession_from_A_to_M (AX244961.1 From A to M)
[b1/459b57] Submitted process > Accession_from_A_to_M (LP969861.1 From A to M)
[4f/9829aa] Submitted process > Accession_from_A_to_M (LP969860.1 From A to M)
[cc/a5d59c] Submitted process > Accession_from_A_to_M (LP969859.1 From A to M)
[f1/7984e8] Submitted process > Accession_from_A_to_M (LP969858.1 From A to M)
[07/f0e9d8] Submitted process > Accession_from_A_to_M (LP969857.1 From A to M)
[e2/15ab0f] Submitted process > Accession_from_A_to_M (LP969856.1 From A to M)
[fd/91a019] Submitted process > Accession_from_A_to_M (LP969855.1 From A to M)
[16/a0f443] Submitted process > Accession_from_A_to_M (LP969854.1 From A to M)
[c8/9b8a8d] Submitted process > Accession_from_A_to_M (LP969853.1 From A to M)
[39/2a6cc9] Submitted process > Accession_from_A_to_M (LP969852.1 From A to M)
[64/2cb0f8] Submitted process > Accession_from_A_to_M (LP969851.1 From A to M)
[42/176352] Submitted process > Accession_from_A_to_M (LP969850.1 From A to M)
[33/9492ca] Submitted process > Accession_from_A_to_M (LP969849.1 From A to M)
[ba/7fd16f] Submitted process > Accession_from_A_to_M (LP969848.1 From A to M)
[ce/c3864d] Submitted process > Accession_from_A_to_M (LP969847.1 From A to M)
[50/8eb259] Submitted process > Accession_from_A_to_M (LP969846.1 From A to M)
[1d/d1d958] Submitted process > Accession_from_A_to_M (LP969845.1 From A to M)
[59/15cfb4] Submitted process > Accession_from_A_to_M (LP969844.1 From A to M)
[fd/2c2e05] Submitted process > Accession_from_A_to_M (LP969843.1 From A to M)
[d2/2d2652] Submitted process > Accession_from_A_to_M (LP969842.1 From A to M)
[d0/0a8f0d] Submitted process > Accession_from_A_to_M (LP969841.1 From A to M)
[c4/bc5480] Submitted process > Accession_from_A_to_M (LP969840.1 From A to M)
[a7/ed69a7] Submitted process > Accession_from_A_to_M (LP969839.1 From A to M)
[f6/22367b] Submitted process > Accession_from_A_to_M (LP969838.1 From A to M)
[92/4db4f5] Submitted process > Accession_from_A_to_M (LP969837.1 From A to M)
[ef/aeeb57] Submitted process > Accession_from_A_to_M (LP969836.1 From A to M)
[ef/7de1e8] Submitted process > Accession_from_A_to_M (LP969834.1 From A to M)
[b2/18e287] Submitted process > Accession_from_A_to_M (LP969832.1 From A to M)
[1a/395465] Submitted process > Accession_from_A_to_M (AF338248.1 From A to M)
[79/3bfbad] Submitted process > Accession_from_A_to_M (AF338247.1 From A to M)
[25/a0ecdd] Submitted process > Accession_from_A_to_M (AF338246.1 From A to M)
[0c/306ee1] Submitted process > Accession_from_A_to_M (AF338245.1 From A to M)
[0e/285397] Submitted process > Accession_from_A_to_M (AF338244.1 From A to M)
[7a/f5df53] Submitted process > Accession_from_A_to_M (AF188530.1 From A to M)
[30/1162df] Submitted process > Accession_from_A_to_M (AF004836.1 From A to M)
[50/1b3641] Submitted process > Accession_from_A_to_M (AF002816.1 From A to M)
[d1/dcf4f6] Submitted process > Accession_from_A_to_M (AF002815.1 From A to M)
[93/c53078] Submitted process > Accession_from_A_to_M (FJ475056.1 From A to M)
[d0/38fc99] Submitted process > Accession_from_A_to_M (FJ475055.1 From A to M)
[74/e30f28] Submitted process > Accession_from_A_to_M (JX417182.1 From A to M)
[44/beeb18] Submitted process > Accession_from_A_to_M (JX417181.1 From A to M)
[c3/87db89] Submitted process > Accession_from_A_to_M (JX417180.1 From A to M)
[16/73b722] Submitted process > Accession_from_A_to_M (JQ687100.1 From A to M)
[87/f21ba4] Submitted process > Accession_from_A_to_M (JQ687099.1 From A to M)
[2d/85d69e] Submitted process > Accession_from_A_to_M (GU144588.1 From A to M)
[1d/5e1640] Submitted process > Accession_from_A_to_M (AY116592.1 From A to M)
[53/0fcf7f] Submitted process > Accession_from_A_to_M (AF188126.1 From A to M)
[ea/017662] Submitted process > Accession_from_A_to_M (AX244968.1 From A to M)
[f8/d273f0] Submitted process > Accession_from_A_to_M (AX244967.1 From A to M)
[02/f1bb0e] Submitted process > Accession_from_A_to_M (AX244966.1 From A to M)
[e9/58c4cd] Submitted process > Accession_from_A_to_M (AX244965.1 From A to M)
[ec/702ffe] Submitted process > Accession_from_A_to_M (AX244964.1 From A to M)
[eb/403baa] Submitted process > Accession_from_A_to_M (AX244963.1 From A to M)
[39/81a17e] Submitted process > Accession_from_A_to_M (AX244962.1 From A to M)
[e0/ad3ec5] Submitted process > Accession_from_A_to_M (AX244961.1 From A to M)
[75/cb5373] Submitted process > Accession_from_A_to_M (AJ279563.1 From A to M)
[c9/e17052] Submitted process > Accession_from_A_to_M (AJ279561.1 From A to M)
[b5/2df94a] Submitted process > Accession_from_A_to_M (AJ279560.1 From A to M)
[1b/48b594] Submitted process > Accession_from_A_to_M (AJ279559.1 From A to M)
[91/75c66b] Submitted process > Accession_from_A_to_M (AJ279558.1 From A to M)
[ac/e4f5c0] Submitted process > Accession_from_A_to_M (AJ279557.1 From A to M)
[4c/f7b16f] Submitted process > Accession_from_A_to_M (AJ279556.1 From A to M)
[bb/de9ca8] Submitted process > Accession_from_A_to_M (AJ279555.1 From A to M)
[84/5cd396] Submitted process > Accession_from_A_to_M (AJ279554.1 From A to M)
[1c/c24703] Submitted process > Accession_from_A_to_M (A12993.1 From A to M)
[2c/de3de8] Submitted process > Accession_from_A_to_M (A12992.1 From A to M)
[80/562542] Submitted process > Accession_from_A_to_M (A12991.1 From A to M)
[4e/fda408] Submitted process > Accession_from_A_to_M (A12990.1 From A to M)
[d7/425522] Submitted process > Accession_from_A_to_M (A12989.1 From A to M)
[1e/e6e5b8] Submitted process > Accession_from_A_to_M (A12988.1 From A to M)
[17/e47311] Submitted process > Accession_from_A_to_M (A12987.1 From A to M)
[96/28c567] Submitted process > Accession_from_A_to_M (A12986.1 From A to M)
[da/68ca78] Submitted process > Accession_from_A_to_M (A12985.1 From A to M)
[15/026a2a] Submitted process > Accession_from_A_to_M (A12997.1 From A to M)
[8c/49bee8] Submitted process > Accession_from_A_to_M (A12996.1 From A to M)
[7c/d5bf9a] Submitted process > Accession_from_A_to_M (A12995.1 From A to M)
[32/730767] Submitted process > Accession_from_A_to_M (A12994.1 From A to M)
```


## Files

```
work/98/4bb5f7fc2b0225d129b9ce18b35049/CT867988.1.am.txt
work/23/e579c84e02e02142260ee485066b7c/CT867991.1.am.txt
work/23/7dfb36d0451753f13c0e0310103489/AF480274.1.am.txt
work/23/111c104b92eda7425c6b6483636280/CS172261.1.am.txt
work/7f/8d446f4e6f0e75e329b0789ad3ef22/NM_001220.4.nz.txt
work/1c/c247032c72f9a022a2fdbba72914d7/A12993.1.am.txt
work/cb/7aebcff1f829a94ab9eea26f90a29c/CT868318.1.am.txt
work/57/06cb809f78548374940abe41f0925e/AF004836.1.am.txt
work/af/e1ac850456cbed9e98fc59b5564dc5/M74218.1.am.txt
work/af/079265aab4cb103d789eadd6516de3/AF480293.1.am.txt
work/af/b43208d8c42423d2b84e4644b271bc/XM_001449677.1.nz.txt
work/97/b432d5a3bbfb224b271c1f856efc54/NM_001199863.1.nz.txt
work/0d/91b5184ef805435498e55ec7a5b15d/AX244961.1.am.txt
work/0d/cc1b91fa00297191d0642a8092c7ed/AX244965.1.am.txt
work/58/6fc9bc0783a1423f30f2295936394c/NM_174910.2.nz.txt
work/f8/d273f0aa10b0ea63a3dced452f9d18/AX244967.1.am.txt
work/f8/195d0ebdd212fa6cff695fb8a02fe7/NM_001199862.1.nz.txt
work/6d/c6dac35120f99dee556664657a8e3b/M74219.1.am.txt
work/ec/702ffe7248a1a23a11e7beaf1b4776/AX244964.1.am.txt
work/c3/87db89847c93451980bc74300c202f/JX417180.1.am.txt
work/fb/2fb4f4ec71ec2cccd1339d3cf62a2d/AF480267.1.am.txt
work/b7/728d5ed0314f656c0b0fc24744410f/AF480289.1.am.txt
work/f9/2baeda816aaaf954f6c11ffd17e20e/M29287.1.am.txt
work/f9/3c4f55d5d295fb83fc4222367bcccf/Z21639.1.nz.txt
work/1e/e6e5b83946e233e089f886e3e95f0a/A12988.1.am.txt
work/1e/266ebca2dd62525b51a499cda71680/CT868670.1.am.txt
work/93/5128daa7a76b622c24db3fce84f1b7/NM_171825.2.nz.txt
work/93/a3128bac61e61be044e6ce7d30f637/Z21640.1.nz.txt
work/93/c5307890fe347eb2c10ecb691a10e2/FJ475056.1.am.txt
work/0a/def4c4467166ba61483ff5cf754888/AF480280.1.am.txt
work/07/f0e9d82c80dc32bfa5c0fc2ee2ae5e/LP969857.1.am.txt
work/59/15cfb49a6f217c2b3a9fedd882e77c/LP969844.1.am.txt
work/59/1223973004eb795a9683d6525e11cb/NM_172080.2.nz.txt
work/d7/42552213e43ba57c05179692a097bf/A12989.1.am.txt
work/5c/0e81dc9e63334418e781063e412406/AF480279.1.am.txt
work/ba/7fd16fb31c8dc52e5dec4c914a1f3e/LP969848.1.am.txt
work/44/beeb180dfc4eb8ae21833792f74fd7/JX417181.1.am.txt
work/31/6c18ae3ce5c044d32130f0498ab572/AF480273.1.am.txt
work/a3/0b11cf4e6d1306bea47c58822bb6ef/AX244967.1.am.txt
work/17/e473114a6e2d0397d9d7bdb5b2a8c2/A12987.1.am.txt
work/ef/f1dcb08d5b457615db053629c47811/AF480263.1.am.txt
work/ef/aeeb57373379c744dc12695946e0f8/LP969836.1.am.txt
work/ef/7de1e8296b00feb876dfc60adecc0d/LP969834.1.am.txt
work/39/2a6cc9d864bcf6dd8bc41b9b54d5c4/LP969852.1.am.txt
work/39/81a17ec9f4ee43d771df906894c7d5/AX244962.1.am.txt
work/a4/6f4dca7ecf2ce8291688d48b1fb13c/NM_001164145.2.nz.txt
work/32/730767c0a99776f38e70d45e207e9f/A12994.1.am.txt
work/b5/2df94a2c29b207238970285ca71053/AJ279560.1.am.txt
work/b5/b6626bb7750649492cabcdad9a4778/X65938.1.nz.txt
work/9d/ddab1359c60952d16d9403a4b864d1/NM_181782.4.nz.txt
work/cc/a5d59ccf13c93046d777f00c628336/LP969859.1.am.txt
work/e4/9146a5e6655d60f74131a3a17fbf98/NM_001293170.1.nz.txt
work/e4/a2578705ddddfe70bf5b8d53c5ac11/NM_001199622.1.nz.txt
work/c9/9834f0373aa6240c1432f0068df049/AF002815.1.am.txt
work/c9/e17052279af0e256288e458a6a48d2/AJ279561.1.am.txt
work/36/808881f8bffcd9032bac459b4f7eea/AF480282.1.am.txt
work/77/6189734c06ef5a9cf562032bca77aa/AF480278.1.am.txt
work/29/4f3ee563466648b8910ae7fef70cc7/NM_001199620.1.nz.txt
work/15/58ac1539f9cf9fa9639358563bc80f/AF004836.1.am.txt
work/15/026a2a7fe2ec7255576ccfcbfe93e6/A12997.1.am.txt
work/c0/e42aaad7575087be7a6132759bc204/AF188126.1.am.txt
work/c0/0a2e7f6f131d947e98ae749a3c9213/CT868030.1.am.txt
work/50/f9f6b760ebcffcbed83450b0ac0a33/AF480284.1.am.txt
work/50/8eb2591c176611412f358757630637/LP969846.1.am.txt
work/50/1b3641e9c899baac5ef181ab39e6da/AF002816.1.am.txt
work/50/ee469af29b560d79f7b5e547251e7a/NM_001142704.1.nz.txt
work/65/a4697b4a5605af0b2064b8f39fa155/NM_001174054.1.nz.txt
work/1a/395465445f3acfa7d9d7e691e4b86a/AF338248.1.am.txt
work/16/2a0e480d74c5658001230cf49e93d6/NM_172084.2.nz.txt
work/16/73b722fe87b87f43febc524f68067c/JQ687100.1.am.txt
work/16/a0f443df0c5112653eae6997f088a9/LP969854.1.am.txt
work/bb/de9ca82190752e81f1a8a8784e40d7/AJ279555.1.am.txt
work/bc/6a1de3b2146c4a9c32092ee23db237/NM_001164144.2.nz.txt
work/10/3dfe4e3eb5e1806a62b4346431ff7c/X60546.1.nz.txt
work/a7/ed69a77d9f0f872b8c9610fa730855/LP969839.1.am.txt
work/e6/0a5fc3701db37ea3b9f809908ed554/NM_032436.3.nz.txt
work/84/5cd396f7b8f924c0b6c923c665d370/AJ279554.1.am.txt
work/4c/f7b16f7f3246db1c9fa275d6aa500b/AJ279556.1.am.txt
work/c2/9addb0cd1e7013a19fbd3d904b613c/AX244962.1.am.txt
work/5e/315264b959a7540de6c677aa0df44f/AF480294.1.am.txt
work/73/547f1dc25cac3b61fc3efbe425e6d8/AF480290.1.am.txt
work/e8/bde45c35fe02e5f7fd1e8c33d20407/AF480291.1.am.txt
work/0f/0949441702d43f3a6d81fcb623e109/NC_029006.1.nz.txt
work/0f/020a57bb809e0e32b5eba473dbe232/AF480285.1.am.txt
work/7a/f5df533f4ed02dc6a999c602fd8aa9/AF188530.1.am.txt
work/7a/cfad66f8f1c7a32e89b9386ce252e0/CS172267.1.am.txt
work/02/acd29570f5910743db7310b9a00acc/AF188126.1.am.txt
work/02/f1bb0e5353f6cea082b5a42cbd9660/AX244966.1.am.txt
work/1f/9a3a401f1ed1458c95da8d7de4ea4e/NM_172130.2.nz.txt
work/0e/957fd7da9e52ae01991c1d8b54b813/NM_007595.5.nz.txt
work/0e/285397606da961ad09663140ec847a/AF338244.1.am.txt
work/0e/632c627b9ae5389a63728c451b4e19/CS172270.1.am.txt
work/75/cb53731c58139fd78875aa186292e4/AJ279563.1.am.txt
work/19/eef74c666996e911b1a69de16371c0/AX244963.1.am.txt
work/d1/dcf4f6ead194627d80017174d529ed/AF002815.1.am.txt
work/1b/1c575b1ab46b3740f2a85529e1c6ed/AY116592.1.am.txt
work/1b/48b59483ddce87ec9f9d28ec460ac6/AJ279559.1.am.txt
work/c8/9b8a8d8f9d1a341335722b6c7be0fa/LP969853.1.am.txt
work/96/28c567972ef45047f7051e8cda7634/A12986.1.am.txt
work/d2/55021aa5770e40de45ec157ced38b2/AX244964.1.am.txt
work/d2/2d2652bf9f0211ec00567da05a956e/LP969842.1.am.txt
work/d2/1c857d24696fe13bf71bd3816405c1/AF480269.1.am.txt
work/4e/fda4082f7147883f4805de03f7392a/A12990.1.am.txt
work/3e/5d2fe486ba58e39050bebb619477c6/M74217.1.am.txt
work/3e/607669f524f750900ab7533ede49b9/NM_001142703.1.nz.txt
work/5d/832bc0297ef0ea482b508112daefd9/AF480296.1.am.txt
work/37/af2fe94732756c1d57050593737889/NM_017590.5.nz.txt
work/b2/18e2872d2e56c70f93038f65a91c70/LP969832.1.am.txt
work/b2/1efe6587946a321274551022ae5fea/XM_001460179.1.nz.txt
work/2d/85d69e7649fcb4ffc2deb1b058c772/GU144588.1.am.txt
work/33/f87d1f15cdde088db8c8650f96476f/CT868429.1.am.txt
work/33/9492ca52729edf114850961ea59632/LP969849.1.am.txt
work/ac/e4f5c01b2e008bc235f463d3fc761c/AJ279557.1.am.txt
work/92/4db4f528bbdd95428547678a7d234d/LP969837.1.am.txt
work/92/bd08643a210adf6e06a31716f6e9c1/AF480281.1.am.txt
work/92/73cecde46cac1285e5bd7c1872002a/J04346.1.am.txt
work/e0/ad3ec5f31aa2b6661778e47a1a9d73/AX244961.1.am.txt
work/e0/16a85050c48d8e394b93a8b9adc664/CT868163.1.am.txt
work/3c/62e7d8ce56a878020b5d96d335161f/NM_001363989.1.nz.txt
work/00/760498c53eeb70c4e069337ff85dcc/NR_138070.1.nz.txt
work/2e/4def8625a89511dd09aa390ac17f21/NM_172078.2.nz.txt
work/64/2cb0f84e03ae2e096b9bad0556c4a5/LP969851.1.am.txt
work/64/b9d489ddb3058410d5f7d22d0c1190/KM983332.1.am.txt
work/64/9f308ff0e64a0669d51400ff24e12a/AF480275.1.am.txt
work/b6/e47ec243b34ab5c2912fe0905e1472/AF480265.1.am.txt
work/a9/6d86c13cb4268fd377be8000351af7/M74216.1.am.txt
work/d3/be3c166038a2c3eb98ce4bafe823d5/M87502.1.am.txt
work/da/68ca785ec0ba47592eb78471581478/A12985.1.am.txt
work/da/bcf87aa05afef6e0d2ad54cc50a4a6/NM_001174053.1.nz.txt
work/da/35fe569471e82616ab18e966b36f9e/AF480292.1.am.txt
work/11/0918e8f91bf762d5689f689cf9a7e7/AF002816.1.am.txt
work/e1/e0edaa9e5b333edfd4fa95172ea6b4/X65939.1.nz.txt
work/aa/75bd31ad058a0e068ac89eac853999/AF480266.1.am.txt
work/7c/d5bf9a22548682503a4c37b7a80f94/A12995.1.am.txt
work/60/ed75479841915b40bd9b1bea6580e8/XM_001424708.1.nz.txt
work/e2/15ab0f12fb07e4a02e764cd11363fb/LP969856.1.am.txt
work/eb/403baa784130b663c213c4f5f5cd4d/AX244963.1.am.txt
work/eb/037ffdb230b3a958d7e30fab3574d4/NM_001122842.2.nz.txt
work/eb/9753d2415ebaa296a0e44fa0dbea3d/CT868068.1.am.txt
work/51/6a138183da0e0cdb0fcb7b4aea1a22/CT868085.1.am.txt
work/42/176352eba62bddfa1becf0463a6804/LP969850.1.am.txt
work/e9/58c4cd4c47a55f21e8e318a527d71f/AX244965.1.am.txt
work/e9/85cd2694411ff7404b7ed8a193c7da/NM_172081.2.nz.txt
work/79/3bfbad5c278389c740695d0ed3c4ba/AF338247.1.am.txt
work/79/f84cdfe7ffeabf0e4f6b19b83f1b9b/AY116593.1.am.txt
work/e3/c329f63480833de86767e1adb79ff5/NM_172079.2.nz.txt
work/91/189d8ba1a575f530dc7d550dd4d25e/X00421.1.nz.txt
work/91/75c66b0920c31434b0fa44fea33dc3/AJ279558.1.am.txt
work/90/18a7abdd704cda60e95740228782bc/U88717.1.nz.txt
work/90/2649f49450bdd0345a8b7758f33d86/NM_172082.2.nz.txt
work/74/e30f28263d672d14699a90f09dddc4/JX417182.1.am.txt
work/c4/bc54802046649f69653cd2143a37db/LP969840.1.am.txt
work/41/fd3edbc54689dbe220acd98942de22/AF480277.1.am.txt
work/fd/91a01958080995432a60a61660624e/LP969855.1.am.txt
work/fd/2c2e05d114bf942d534e94fe6a5b4c/LP969843.1.am.txt
work/bd/2b497516616a4921f19a58ff3e94cd/XM_001441019.1.nz.txt
work/46/56ce9f7faea92f34545c32cc1d41c6/U65924.1.nz.txt
work/53/0fcf7fdbffd5746a2c4fcde7684b93/AF188126.1.am.txt
work/f1/7984e81045be83bca42cbdbb028246/LP969858.1.am.txt
work/72/94a2505d808ab0ae5856e1cb5376d4/XM_001445002.1.nz.txt
work/f7/f17a632c00aa3c5f84b4ed0a24a055/M22308.1.am.txt
work/85/d2a669d8be8c0716e7a5ee331dea78/AF002816.1.am.txt
work/1d/5e1640c6165edaee0ee3d7d5873f7d/AY116592.1.am.txt
work/1d/d1d95878e8053ae7a181693aa284c0/LP969845.1.am.txt
work/d6/702e9bf449305ab5df50bab875ad5e/NM_001199621.1.nz.txt
work/52/59c8ab3aadb19ec3b58fb247dea381/X65940.1.nz.txt
work/52/323d09fafe924d4e9ebdbf02f0986d/AF480295.1.am.txt
work/5b/fdfa7a4578e14e3058912a0672e98f/NR_029944.1.nz.txt
work/5b/9e9bf39ad453d6dd9689437fb3c57c/AF480271.1.am.txt
work/cd/f609f07ac7e23596541d58b9ad616c/X14057.1.nz.txt
work/8c/760e1dee2adb2411ef70581d8a7245/NM_001199861.1.nz.txt
work/8c/49bee85eaa5065e37b1dfe6fb01f81/A12996.1.am.txt
work/78/968c4a00b47fb400d78dfc59c77735/CT868274.1.am.txt
work/80/5625425b3246e4343f631930d92b9c/A12991.1.am.txt
work/80/7da49150cf0667021a1f1303b97ecf/NM_001199619.1.nz.txt
work/80/44bd3295d55f5cce5154d0f095228b/AF480286.1.am.txt
work/ad/d76e0e094ab0f841288c61bfb49208/AF480268.1.am.txt
work/ea/017662bd0f740fbe8e662108eb643d/AX244968.1.am.txt
work/6c/1708e36bc0bc5dc2fc6208b7282bfb/NM_001199860.1.nz.txt
work/26/b30fb557f7a5ddc7fa2570ce204c7b/XM_001437902.1.nz.txt
work/26/4e8e47e040134c52ccc139b6fbbccc/XM_001424093.1.nz.txt
work/26/004e6794d13018668f4e7da9a28d1e/NM_017590.5.nz.txt
work/26/db6a7c812bce24b859a4a7b2ef1eb6/AF480287.1.am.txt
work/26/258b1d696469ecad12c7de17f5053b/NM_198947.3.nz.txt
work/2c/de3de89a6a315cf3e7f71b1fc52e18/A12992.1.am.txt
work/b1/459b57d5b4bbc4893038d8a620c424/LP969861.1.am.txt
work/87/f21ba4399c9894270c5e64b70d7dcf/JQ687099.1.am.txt
work/27/f82297c32e957c7be9f8a1a28aaf5e/AF480264.1.am.txt
work/27/8ec4074f01ff03d9a8ac934be3c7f1/K02254.1.am.txt
work/0c/86bc1654436c60e4a3b27438a9eb7b/NM_003636.3.nz.txt
work/0c/306ee14d38eab60e6962b5d70c05fb/AF338245.1.am.txt
work/fa/556e07b23836d0fa5eac6ca2dd6529/AF480288.1.am.txt
work/2a/fdf207cdacaef614c51f7607799c77/AF480283.1.am.txt
work/2a/3949beab43f271187ae27c87c29db8/AF188530.1.am.txt
work/30/1162dfae7d750752386bdaff013b3e/AF004836.1.am.txt
work/45/59ba06cb50053aed63290db13f8ded/AF480272.1.am.txt
work/ce/1e77a2e92d3f6bdc9101cb8b6fe294/AF480276.1.am.txt
work/ce/c3864d5da00f0e292eedfe305e2357/LP969847.1.am.txt
work/54/ca68f535d998a700ebd95bd8808bf6/NM_015981.3.nz.txt
work/01/1474a0ac05b220aa18e4412dc9ec65/AX244966.1.am.txt
work/fe/b56b0c07bd36a2cb8fa39213ed4b88/NM_001363990.1.nz.txt
work/f6/22367b4a7ec8fdec516c7d8d7acf60/LP969838.1.am.txt
work/25/a0ecdd52685ebe75692b733f89433a/AF338246.1.am.txt
work/08/a08bbd9fd6cf65679b5ba0a053ca83/AF480270.1.am.txt
work/4f/9829aa5d71eb86fde86ab567df3c4e/LP969860.1.am.txt
work/94/f75344f317c31aa0c14748e0f2255e/NM_172083.2.nz.txt
work/94/f919de9ac1aad29923e7f114cdf72d/AX244968.1.am.txt
work/94/d6ab393156ad0b2d2f2bd5bae82622/AF002815.1.am.txt
work/d0/0a8f0d1c3d1aa08ee577b9db44cfcb/LP969841.1.am.txt
work/d0/38fc997828a73eefbbb858dccb9385/FJ475055.1.am.txt
```


