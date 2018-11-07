## Synopsis

> The `when` declaration allows you to define a condition that must be verified in order to execute the process. 

## nextflow

### ./workflow.nf

```groovy
  1   acn_file_channel = Channel.fromPath( "${params.acns}")
  2   
  3   /** copy acn_file_channel : https://www.nextflow.io/docs/latest/faq.html How do I use the same channel multiple times?  */
  4   acn_file_channel.into { copy1 ; copy2}
  5   
  6   process Accession_from_A_to_M {
  7   	tag "${acn} From A to M"
  8   	maxForks 1
  9   	input:
 10   		val acn from copy1.
 11   				splitCsv(sep:',',strip:true).
 12   				map{ARRAY->ARRAY[0]}
 13   	output:
 14   		file("${acn}.am.txt") into A_TO_M
 15   	
 16   	when:
 17   		acn =~ /^[A-M]/
 18   	
 19   	script:
 20   	 
 21   	"""
 22   	echo "${acn}" > "${acn}.am.txt"
 23   	"""
 24   	}
 25   
 26   process Accession_from_N_to_Z {
 27   	tag "${acn} From N to Z"
 28   	maxForks 1
 29   	input:
 30   		val acn from copy2.
 31   				splitCsv(sep:',',strip:true).
 32   				map{ARRAY->ARRAY[0]}
 33   	output:
 34   		file("${acn}.nz.txt") into N_TO_Z
 35   	
 36   	when:
 37   		acn =~ /^[N-Z]/
 38   	
 39   	script:
 40   	 
 41   	"""
 42   	echo "${acn}" > "${acn}.nz.txt"
 43   	"""
 44   	}
 45   
```


## Execute

```
../bin/nextflow run workflow.nf --acns '../data/list*.acns.txt'
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [crazy_panini] - revision: ce9cc7016c
[warm up] executor > local
[08/0cd6f6] Submitted process > Accession_from_N_to_Z (NM_001293170.1 From N to Z)
[27/1e17f3] Submitted process > Accession_from_A_to_M (AF188530.1 From A to M)
[dc/1d3122] Submitted process > Accession_from_N_to_Z (NM_001199860.1 From N to Z)
[3d/008418] Submitted process > Accession_from_A_to_M (AF188126.1 From A to M)
[12/24a835] Submitted process > Accession_from_N_to_Z (NM_001199861.1 From N to Z)
[20/a2930e] Submitted process > Accession_from_A_to_M (AF004836.1 From A to M)
[c8/b3a7e1] Submitted process > Accession_from_N_to_Z (NM_001199862.1 From N to Z)
[07/2075a0] Submitted process > Accession_from_A_to_M (AF002816.1 From A to M)
[2b/c43bde] Submitted process > Accession_from_N_to_Z (NM_001199863.1 From N to Z)
[15/2fbd0e] Submitted process > Accession_from_A_to_M (AF002815.1 From A to M)
[8b/dfd408] Submitted process > Accession_from_N_to_Z (NM_003636.3 From N to Z)
[c5/020af5] Submitted process > Accession_from_A_to_M (CS172270.1 From A to M)
[23/226650] Submitted process > Accession_from_N_to_Z (NM_172130.2 From N to Z)
[42/fd50d9] Submitted process > Accession_from_A_to_M (CS172261.1 From A to M)
[c1/26b006] Submitted process > Accession_from_N_to_Z (NM_001142703.1 From N to Z)
[1b/71faec] Submitted process > Accession_from_A_to_M (AF188126.1 From A to M)
[3c/8484e3] Submitted process > Accession_from_N_to_Z (NM_001142704.1 From N to Z)
[a5/5687eb] Submitted process > Accession_from_N_to_Z (NM_001220.4 From N to Z)
[9b/eb58d4] Submitted process > Accession_from_A_to_M (M74217.1 From A to M)
[96/1b5921] Submitted process > Accession_from_N_to_Z (NM_172078.2 From N to Z)
[4a/d251f1] Submitted process > Accession_from_A_to_M (AY116592.1 From A to M)
[f8/6900bd] Submitted process > Accession_from_N_to_Z (NM_172079.2 From N to Z)
[42/1094ec] Submitted process > Accession_from_N_to_Z (NM_172080.2 From N to Z)
[af/88c8e2] Submitted process > Accession_from_A_to_M (J04346.1 From A to M)
[7b/c332a3] Submitted process > Accession_from_N_to_Z (NM_172081.2 From N to Z)
[47/12c17a] Submitted process > Accession_from_N_to_Z (NM_172082.2 From N to Z)
[95/a78871] Submitted process > Accession_from_A_to_M (M74219.1 From A to M)
[ee/ac4a46] Submitted process > Accession_from_N_to_Z (NM_198947.3 From N to Z)
[b1/a32355] Submitted process > Accession_from_N_to_Z (NM_172083.2 From N to Z)
[8e/b6aa19] Submitted process > Accession_from_N_to_Z (NM_172084.2 From N to Z)
[14/6f3692] Submitted process > Accession_from_N_to_Z (NM_001363989.1 From N to Z)
[21/bb545d] Submitted process > Accession_from_A_to_M (M74216.1 From A to M)
[d8/c4addc] Submitted process > Accession_from_N_to_Z (NM_001363990.1 From N to Z)
[05/8ac984] Submitted process > Accession_from_N_to_Z (NM_015981.3 From N to Z)
[5f/cd8842] Submitted process > Accession_from_N_to_Z (NM_171825.2 From N to Z)
[4e/97c804] Submitted process > Accession_from_A_to_M (AY116593.1 From A to M)
[23/e75a7b] Submitted process > Accession_from_A_to_M (K02254.1 From A to M)
[bf/6aae3a] Submitted process > Accession_from_A_to_M (M22308.1 From A to M)
[ad/ee9429] Submitted process > Accession_from_N_to_Z (NM_001174053.1 From N to Z)
[a5/3e5e2c] Submitted process > Accession_from_A_to_M (M87502.1 From A to M)
[e5/c0b7f9] Submitted process > Accession_from_N_to_Z (NM_001174054.1 From N to Z)
[8a/9e82c8] Submitted process > Accession_from_A_to_M (M29287.1 From A to M)
[25/fb0291] Submitted process > Accession_from_N_to_Z (NM_007595.5 From N to Z)
[2a/3e240f] Submitted process > Accession_from_N_to_Z (NM_001164144.2 From N to Z)
[eb/4cde2b] Submitted process > Accession_from_A_to_M (M74218.1 From A to M)
[43/558d04] Submitted process > Accession_from_A_to_M (AF480296.1 From A to M)
[82/126676] Submitted process > Accession_from_N_to_Z (NM_001164145.2 From N to Z)
[8e/78aa20] Submitted process > Accession_from_N_to_Z (NM_032436.3 From N to Z)
[c7/0078b3] Submitted process > Accession_from_A_to_M (AF480295.1 From A to M)
[cf/50186a] Submitted process > Accession_from_N_to_Z (NM_174910.2 From N to Z)
[5b/d6f873] Submitted process > Accession_from_N_to_Z (NM_001122842.2 From N to Z)
[04/8e5e33] Submitted process > Accession_from_A_to_M (AF480294.1 From A to M)
[50/876533] Submitted process > Accession_from_N_to_Z (NM_001199619.1 From N to Z)
[38/d3fbe6] Submitted process > Accession_from_A_to_M (AF480293.1 From A to M)
[8d/ad8cae] Submitted process > Accession_from_N_to_Z (NM_001199620.1 From N to Z)
[1b/a16cc2] Submitted process > Accession_from_A_to_M (AF480292.1 From A to M)
[aa/5f1ac8] Submitted process > Accession_from_A_to_M (AF480291.1 From A to M)
[15/202768] Submitted process > Accession_from_A_to_M (AF480290.1 From A to M)
[52/255730] Submitted process > Accession_from_A_to_M (AF480289.1 From A to M)
[6c/fa1a2a] Submitted process > Accession_from_N_to_Z (NM_001199621.1 From N to Z)
[05/c46210] Submitted process > Accession_from_A_to_M (AF480288.1 From A to M)
[99/8c7eab] Submitted process > Accession_from_N_to_Z (NM_001199622.1 From N to Z)
[4e/17c8a3] Submitted process > Accession_from_N_to_Z (NM_017590.5 From N to Z)
[2f/1986c6] Submitted process > Accession_from_A_to_M (AF480287.1 From A to M)
[a8/e5d622] Submitted process > Accession_from_A_to_M (AF480286.1 From A to M)
[95/eaf120] Submitted process > Accession_from_N_to_Z (NM_181782.4 From N to Z)
[89/c99b6c] Submitted process > Accession_from_A_to_M (AF480285.1 From A to M)
[90/b80783] Submitted process > Accession_from_A_to_M (AF480284.1 From A to M)
[78/90d4bf] Submitted process > Accession_from_N_to_Z (NR_138070.1 From N to Z)
[a3/b4ea01] Submitted process > Accession_from_A_to_M (AF480283.1 From A to M)
[e6/e8d8d0] Submitted process > Accession_from_A_to_M (AF480282.1 From A to M)
[03/4626b1] Submitted process > Accession_from_A_to_M (AF480281.1 From A to M)
[a0/7ead7f] Submitted process > Accession_from_N_to_Z (X65939.1 From N to Z)
[ed/fc7569] Submitted process > Accession_from_N_to_Z (X65938.1 From N to Z)
[3d/583290] Submitted process > Accession_from_A_to_M (AF480280.1 From A to M)
[14/c6493b] Submitted process > Accession_from_N_to_Z (X65940.1 From N to Z)
[9c/ac9fee] Submitted process > Accession_from_N_to_Z (X14057.1 From N to Z)
[0e/3c9a67] Submitted process > Accession_from_A_to_M (AF480279.1 From A to M)
[a6/7b75ac] Submitted process > Accession_from_N_to_Z (X60546.1 From N to Z)
[2c/3db399] Submitted process > Accession_from_N_to_Z (U65924.1 From N to Z)
[38/95b632] Submitted process > Accession_from_A_to_M (AF480278.1 From A to M)
[41/4936d6] Submitted process > Accession_from_N_to_Z (Z21640.1 From N to Z)
[3c/411562] Submitted process > Accession_from_A_to_M (AF480277.1 From A to M)
[b3/fce853] Submitted process > Accession_from_N_to_Z (Z21639.1 From N to Z)
[17/e3cf98] Submitted process > Accession_from_A_to_M (AF480276.1 From A to M)
[36/a2866b] Submitted process > Accession_from_N_to_Z (X00421.1 From N to Z)
[e4/54a6f7] Submitted process > Accession_from_A_to_M (AF480275.1 From A to M)
[fc/b90833] Submitted process > Accession_from_A_to_M (AF480274.1 From A to M)
[0c/2fb52c] Submitted process > Accession_from_N_to_Z (U88717.1 From N to Z)
[cb/d3b2c2] Submitted process > Accession_from_A_to_M (AF480273.1 From A to M)
[2c/e24826] Submitted process > Accession_from_A_to_M (AF480272.1 From A to M)
[21/a27c4e] Submitted process > Accession_from_A_to_M (AF480271.1 From A to M)
[5a/b4a6a8] Submitted process > Accession_from_N_to_Z (NC_029006.1 From N to Z)
[eb/97ca24] Submitted process > Accession_from_A_to_M (AF480270.1 From A to M)
[2b/a867ee] Submitted process > Accession_from_A_to_M (AF480269.1 From A to M)
[c3/2c60b2] Submitted process > Accession_from_N_to_Z (XM_001460179.1 From N to Z)
[9a/605d71] Submitted process > Accession_from_A_to_M (AF480268.1 From A to M)
[49/ba2128] Submitted process > Accession_from_A_to_M (AF480267.1 From A to M)
[04/09a66c] Submitted process > Accession_from_N_to_Z (XM_001449677.1 From N to Z)
[87/f23858] Submitted process > Accession_from_A_to_M (AF480266.1 From A to M)
[47/5e4f03] Submitted process > Accession_from_A_to_M (AF480265.1 From A to M)
[3e/fd7c0c] Submitted process > Accession_from_N_to_Z (XM_001445002.1 From N to Z)
[27/78f68b] Submitted process > Accession_from_N_to_Z (XM_001441019.1 From N to Z)
[4f/12ba4f] Submitted process > Accession_from_A_to_M (AF480264.1 From A to M)
[98/8a0dab] Submitted process > Accession_from_N_to_Z (XM_001437902.1 From N to Z)
[fb/171731] Submitted process > Accession_from_A_to_M (AF480263.1 From A to M)
[59/85a794] Submitted process > Accession_from_N_to_Z (XM_001424708.1 From N to Z)
[9d/444d68] Submitted process > Accession_from_A_to_M (CS172267.1 From A to M)
[47/90b5e7] Submitted process > Accession_from_N_to_Z (XM_001424093.1 From N to Z)
[99/564792] Submitted process > Accession_from_N_to_Z (NM_017590.5 From N to Z)
[4a/6cd4f0] Submitted process > Accession_from_A_to_M (AF004836.1 From A to M)
[20/9a72e1] Submitted process > Accession_from_A_to_M (AF002816.1 From A to M)
[e4/028762] Submitted process > Accession_from_N_to_Z (NR_029944.1 From N to Z)
[b8/dc4770] Submitted process > Accession_from_A_to_M (AF002815.1 From A to M)
[29/45aa49] Submitted process > Accession_from_A_to_M (CT868670.1 From A to M)
[1d/0dd6d0] Submitted process > Accession_from_A_to_M (CT868429.1 From A to M)
[a8/531edf] Submitted process > Accession_from_A_to_M (CT868318.1 From A to M)
[57/57b29f] Submitted process > Accession_from_A_to_M (KM983332.1 From A to M)
[2f/d65ce5] Submitted process > Accession_from_A_to_M (CT868274.1 From A to M)
[17/efe203] Submitted process > Accession_from_A_to_M (CT868085.1 From A to M)
[6a/fc7df4] Submitted process > Accession_from_A_to_M (CT868068.1 From A to M)
[c2/b0d06f] Submitted process > Accession_from_A_to_M (CT868030.1 From A to M)
[45/8a95e7] Submitted process > Accession_from_A_to_M (CT867988.1 From A to M)
[fc/f018bb] Submitted process > Accession_from_A_to_M (CT868163.1 From A to M)
[42/ed1d9e] Submitted process > Accession_from_A_to_M (CT867991.1 From A to M)
[6d/465da9] Submitted process > Accession_from_A_to_M (AX244968.1 From A to M)
[a9/72cfb6] Submitted process > Accession_from_A_to_M (AX244967.1 From A to M)
[31/417e4b] Submitted process > Accession_from_A_to_M (AX244966.1 From A to M)
[52/5669c1] Submitted process > Accession_from_A_to_M (AX244965.1 From A to M)
[6c/fbaf3b] Submitted process > Accession_from_A_to_M (AX244964.1 From A to M)
[ee/608763] Submitted process > Accession_from_A_to_M (AX244963.1 From A to M)
[b5/8291de] Submitted process > Accession_from_A_to_M (AX244962.1 From A to M)
[b6/b72dcf] Submitted process > Accession_from_A_to_M (AX244961.1 From A to M)
[80/a25941] Submitted process > Accession_from_A_to_M (LP969861.1 From A to M)
[34/f5ece3] Submitted process > Accession_from_A_to_M (LP969860.1 From A to M)
[44/76db2f] Submitted process > Accession_from_A_to_M (LP969859.1 From A to M)
[21/559a8b] Submitted process > Accession_from_A_to_M (LP969858.1 From A to M)
[66/d4730e] Submitted process > Accession_from_A_to_M (LP969857.1 From A to M)
[3d/e40b99] Submitted process > Accession_from_A_to_M (LP969856.1 From A to M)
[11/10d0f4] Submitted process > Accession_from_A_to_M (LP969855.1 From A to M)
[90/d82a77] Submitted process > Accession_from_A_to_M (LP969854.1 From A to M)
[24/a35070] Submitted process > Accession_from_A_to_M (LP969853.1 From A to M)
[1a/b09e6d] Submitted process > Accession_from_A_to_M (LP969852.1 From A to M)
[e7/d13185] Submitted process > Accession_from_A_to_M (LP969851.1 From A to M)
[da/777c9d] Submitted process > Accession_from_A_to_M (LP969850.1 From A to M)
[a9/83c99c] Submitted process > Accession_from_A_to_M (LP969849.1 From A to M)
[be/f45e5a] Submitted process > Accession_from_A_to_M (LP969848.1 From A to M)
[3d/416ae2] Submitted process > Accession_from_A_to_M (LP969847.1 From A to M)
[75/7bbbac] Submitted process > Accession_from_A_to_M (LP969846.1 From A to M)
[d6/77546d] Submitted process > Accession_from_A_to_M (LP969845.1 From A to M)
[2e/390f8c] Submitted process > Accession_from_A_to_M (LP969844.1 From A to M)
[39/998b52] Submitted process > Accession_from_A_to_M (LP969843.1 From A to M)
[3c/b7a332] Submitted process > Accession_from_A_to_M (LP969842.1 From A to M)
[09/bfa15f] Submitted process > Accession_from_A_to_M (LP969841.1 From A to M)
[ab/1b7fb7] Submitted process > Accession_from_A_to_M (LP969840.1 From A to M)
[46/379960] Submitted process > Accession_from_A_to_M (LP969839.1 From A to M)
[8a/87934d] Submitted process > Accession_from_A_to_M (LP969838.1 From A to M)
[49/992064] Submitted process > Accession_from_A_to_M (LP969837.1 From A to M)
[8c/d3cf3d] Submitted process > Accession_from_A_to_M (LP969836.1 From A to M)
[39/d89fab] Submitted process > Accession_from_A_to_M (LP969834.1 From A to M)
[30/ef4148] Submitted process > Accession_from_A_to_M (LP969832.1 From A to M)
[4b/3763a5] Submitted process > Accession_from_A_to_M (AF338248.1 From A to M)
[a2/438346] Submitted process > Accession_from_A_to_M (AF338247.1 From A to M)
[e0/66fb1b] Submitted process > Accession_from_A_to_M (AF338246.1 From A to M)
[2a/887fba] Submitted process > Accession_from_A_to_M (AF338245.1 From A to M)
[f6/54eea1] Submitted process > Accession_from_A_to_M (AF338244.1 From A to M)
[1a/cf2c87] Submitted process > Accession_from_A_to_M (AF188530.1 From A to M)
[21/e8ce3a] Submitted process > Accession_from_A_to_M (AF004836.1 From A to M)
[f6/8a9e95] Submitted process > Accession_from_A_to_M (AF002816.1 From A to M)
[96/61a11a] Submitted process > Accession_from_A_to_M (AF002815.1 From A to M)
[76/fd42d7] Submitted process > Accession_from_A_to_M (FJ475056.1 From A to M)
[37/6fe96f] Submitted process > Accession_from_A_to_M (FJ475055.1 From A to M)
[63/260028] Submitted process > Accession_from_A_to_M (JX417182.1 From A to M)
[4c/49dd1a] Submitted process > Accession_from_A_to_M (JX417181.1 From A to M)
[f7/9046a3] Submitted process > Accession_from_A_to_M (JX417180.1 From A to M)
[2e/bc03e1] Submitted process > Accession_from_A_to_M (JQ687100.1 From A to M)
[97/a45232] Submitted process > Accession_from_A_to_M (JQ687099.1 From A to M)
[6e/4e0914] Submitted process > Accession_from_A_to_M (GU144588.1 From A to M)
[3a/3d9f77] Submitted process > Accession_from_A_to_M (AY116592.1 From A to M)
[c5/a7c63f] Submitted process > Accession_from_A_to_M (AF188126.1 From A to M)
[bd/43a889] Submitted process > Accession_from_A_to_M (AX244968.1 From A to M)
[75/c9925c] Submitted process > Accession_from_A_to_M (AX244967.1 From A to M)
[6a/825260] Submitted process > Accession_from_A_to_M (AX244966.1 From A to M)
[72/ea8a7e] Submitted process > Accession_from_A_to_M (AX244965.1 From A to M)
[5a/648c5d] Submitted process > Accession_from_A_to_M (AX244964.1 From A to M)
[42/6402f7] Submitted process > Accession_from_A_to_M (AX244963.1 From A to M)
[ff/5fbf1f] Submitted process > Accession_from_A_to_M (AX244962.1 From A to M)
[19/a08406] Submitted process > Accession_from_A_to_M (AX244961.1 From A to M)
[32/031a58] Submitted process > Accession_from_A_to_M (AJ279563.1 From A to M)
[3a/a5fcd7] Submitted process > Accession_from_A_to_M (AJ279561.1 From A to M)
[fa/3ef7a3] Submitted process > Accession_from_A_to_M (AJ279560.1 From A to M)
[5e/061412] Submitted process > Accession_from_A_to_M (AJ279559.1 From A to M)
[c3/42975f] Submitted process > Accession_from_A_to_M (AJ279558.1 From A to M)
[24/3a3735] Submitted process > Accession_from_A_to_M (AJ279557.1 From A to M)
[f3/c54d82] Submitted process > Accession_from_A_to_M (AJ279556.1 From A to M)
[f6/9ca43a] Submitted process > Accession_from_A_to_M (AJ279555.1 From A to M)
[70/a440ef] Submitted process > Accession_from_A_to_M (AJ279554.1 From A to M)
[a9/17c835] Submitted process > Accession_from_A_to_M (A12993.1 From A to M)
[22/4cc396] Submitted process > Accession_from_A_to_M (A12992.1 From A to M)
[96/f5db2c] Submitted process > Accession_from_A_to_M (A12991.1 From A to M)
[aa/bee5d0] Submitted process > Accession_from_A_to_M (A12990.1 From A to M)
[f9/adfd1c] Submitted process > Accession_from_A_to_M (A12989.1 From A to M)
[ca/acccaa] Submitted process > Accession_from_A_to_M (A12988.1 From A to M)
[1e/5a9d02] Submitted process > Accession_from_A_to_M (A12987.1 From A to M)
[f3/814d66] Submitted process > Accession_from_A_to_M (A12986.1 From A to M)
[9f/731d66] Submitted process > Accession_from_A_to_M (A12985.1 From A to M)
[7e/28d8a1] Submitted process > Accession_from_A_to_M (A12997.1 From A to M)
[17/f54a75] Submitted process > Accession_from_A_to_M (A12996.1 From A to M)
[fd/9300ce] Submitted process > Accession_from_A_to_M (A12995.1 From A to M)
[8d/e5a356] Submitted process > Accession_from_A_to_M (A12994.1 From A to M)
```


## Files

```
work/9f/731d66d43348d16da2464f683bce27/A12985.1.am.txt
work/63/2600286205b806a309f92606d6981e/JX417182.1.am.txt
work/98/8a0dabf4ada7e36f3bdd6b5c9f6727/XM_001437902.1.nz.txt
work/38/d3fbe6d938462b54aece98ddbe9ef5/AF480293.1.am.txt
work/38/95b6325e9c85a45fbc543786be50dc/AF480278.1.am.txt
work/23/e75a7bc68afa141918f02fcfd0ab4e/K02254.1.am.txt
work/23/2266509c9d90e4f6e30ab7ca8a99bb/NM_172130.2.nz.txt
work/9a/605d71af233843b82f2795c41d55a6/AF480268.1.am.txt
work/cb/d3b2c25e3c6a589531dddd62f4a16b/AF480273.1.am.txt
work/57/57b29f4d5bcc742f825c19af0d43f3/KM983332.1.am.txt
work/af/88c8e2bffdd3b612bc8e7ee5a995ff/J04346.1.am.txt
work/97/a4523275097d6be2debcd426d71238/JQ687099.1.am.txt
work/a8/531edf3f5e403bbb477cb844bac519/CT868318.1.am.txt
work/a8/e5d622c7fc56257d27dd01f13a7795/AF480286.1.am.txt
work/f8/6900bdf1d3ab9d1baf6aec3aeac136/NM_172079.2.nz.txt
work/6d/465da9bc9c74f87d2f53645d95312c/AX244968.1.am.txt
work/c3/42975fda70b9a3a917f86a57a636e3/AJ279558.1.am.txt
work/c3/2c60b21ae88616f212743e043bb468/XM_001460179.1.nz.txt
work/fb/171731d26d7e4a5edc62df78aa58b0/AF480263.1.am.txt
work/f3/814d66b15d794ce4f16b5dd8b9a817/A12986.1.am.txt
work/f3/c54d82711d257b78f90bba7dfa6cf5/AJ279556.1.am.txt
work/f9/adfd1c6a0c82e7743af6fbe43bc136/A12989.1.am.txt
work/1e/5a9d02709ef6e343a181b60b41e275/A12987.1.am.txt
work/21/a27c4e34a2d4f705c4b1cb4c545b3e/AF480271.1.am.txt
work/21/559a8b4f831d8c313a589f27830df5/LP969858.1.am.txt
work/21/bb545d397ec05038d4a24a805b2c70/M74216.1.am.txt
work/21/e8ce3a294f82c1d4ea69507f3896d1/AF004836.1.am.txt
work/ee/ac4a469d85368d57ced8593926f37e/NM_198947.3.nz.txt
work/ee/608763778224e671c6af68adcf7ff0/AX244963.1.am.txt
work/07/2075a014bbf36c5727fa6e917d00c1/AF002816.1.am.txt
work/5a/648c5d4275f09438f8a10d691c2677/AX244964.1.am.txt
work/5a/b4a6a81a1bfd17b9804a2557bcd8d5/NC_029006.1.nz.txt
work/59/85a79467b9b608c56d37cc19f84b91/XM_001424708.1.nz.txt
work/d8/c4addcdc140fe3d50d163c132cd328/NM_001363990.1.nz.txt
work/9c/ac9fee5aa689fea22e581878a912e0/X14057.1.nz.txt
work/44/76db2f1b5b9c01628a4b2297971c75/LP969859.1.am.txt
work/31/417e4bf02ba0694a864b551763b1ec/AX244966.1.am.txt
work/43/558d04f65a2c6916a50108067d6288/AF480296.1.am.txt
work/a3/b4ea01c0cb6ec140f830d02fddb61b/AF480283.1.am.txt
work/82/126676e00183fa6e0146da5c42b944/NM_001164145.2.nz.txt
work/17/efe2038b71057ca7007e2964988504/CT868085.1.am.txt
work/17/f54a75f61cc6d8a60777afa08043b3/A12996.1.am.txt
work/17/e3cf98ef7b853d7794557c08f8d940/AF480276.1.am.txt
work/22/4cc396482b97b371562e92ad66c49b/A12992.1.am.txt
work/39/998b52475c1a27c89c6582e250a389/LP969843.1.am.txt
work/39/d89fabad93228e8ab9dd5f871358f0/LP969834.1.am.txt
work/fc/f018bbffc441e877d9a93b623d1e54/CT868163.1.am.txt
work/fc/b90833eb866cb134b89e38441069ae/AF480274.1.am.txt
work/6a/fc7df4895893821cf60c4d518b7214/CT868068.1.am.txt
work/6a/82526013b1fb82be33ee1410fdb1cf/AX244966.1.am.txt
work/32/031a5847e041e681f48ccf4c96d8a8/AJ279563.1.am.txt
work/3d/0084183ef203b74a1e22235231df22/AF188126.1.am.txt
work/3d/e40b9915d74ef3e34cd7893aeb25be/LP969856.1.am.txt
work/3d/416ae23534d943a78c2b8ad18e4f52/LP969847.1.am.txt
work/3d/58329037d1b4a894ede9e732c7b4a8/AF480280.1.am.txt
work/b5/8291ded11d0e0b2353c1d79b45809e/AX244962.1.am.txt
work/e7/d131856f4d16f8defcdf5417a846b9/LP969851.1.am.txt
work/9d/444d68927775fc1394078056f2be72/CS172267.1.am.txt
work/95/a788712aa5ccb2cd4d5f761d700966/M74219.1.am.txt
work/95/eaf120bcee78e723747eab57b6b4f5/NM_181782.4.nz.txt
work/e4/54a6f76213e0317411a46805db399e/AF480275.1.am.txt
work/e4/02876227a9744563872f7098f45b48/NR_029944.1.nz.txt
work/8e/78aa20f957b8a0866900023f072946/NM_032436.3.nz.txt
work/8e/b6aa19504b3b05bd0debef6b8a1833/NM_172084.2.nz.txt
work/ff/5fbf1f3027414f4e3ed8709a42e7d3/AX244962.1.am.txt
work/36/a2866bad3437990800096cf425ea52/X00421.1.nz.txt
work/29/45aa49b57ba36e9a19daa7e3ce2978/CT868670.1.am.txt
work/15/2fbd0e0e537019aa49bd35549c2ee8/AF002815.1.am.txt
work/15/202768ef25cad7f230f9a7afac5583/AF480290.1.am.txt
work/4b/3763a56f3fb7318e81d9fffb39991b/AF338248.1.am.txt
work/50/8765336d4a625dca4ec020f6a6df61/NM_001199619.1.nz.txt
work/1a/b09e6d7396cb40583b8c92b360e949/LP969852.1.am.txt
work/1a/cf2c8775a4ae1be77eeb7a01a30e2d/AF188530.1.am.txt
work/a2/43834685a47d39b8df02100f0e1544/AF338247.1.am.txt
work/e6/e8d8d0ce5053926aecb62ea5a74865/AF480282.1.am.txt
work/4c/49dd1a8ec60272b64b5fe0bc90b7ab/JX417181.1.am.txt
work/c2/b0d06f6e1013245aa8a22950b81ad1/CT868030.1.am.txt
work/5e/0614122299c3a65bbd758038125355/AJ279559.1.am.txt
work/cf/50186aff387855264706b8ee4568ad/NM_174910.2.nz.txt
work/05/8ac984bf1cd9a8c082f81b2d89e408/NM_015981.3.nz.txt
work/05/c462102e6c74655b6340e822d2cf48/AF480288.1.am.txt
work/0e/3c9a67c677b7eefd27153d34045ba5/AF480279.1.am.txt
work/75/c9925cac8d1e84262ce7e834894a0e/AX244967.1.am.txt
work/75/7bbbac20ccc36c32307dbf87dda374/LP969846.1.am.txt
work/7e/28d8a1e4bfeb115264324a72affcf8/A12997.1.am.txt
work/6e/4e091499d6fd6b3a7efd73f807e3ff/GU144588.1.am.txt
work/8b/dfd40881a09e6e94fd6c0116f70305/NM_003636.3.nz.txt
work/19/a08406d2d0fee76efa9d01bd0d932f/AX244961.1.am.txt
work/ca/acccaa06e39e1a43ffc9d791fcddfa/A12988.1.am.txt
work/1b/a16cc2f6cd8a016d658fcdb520a360/AF480292.1.am.txt
work/1b/71faeca7c8e0b39cccaa82cadb9836/AF188126.1.am.txt
work/09/bfa15f102fa084c29710c352e20241/LP969841.1.am.txt
work/c8/b3a7e14adae4bbf69a11dbd609bfaf/NM_001199862.1.nz.txt
work/96/61a11ab487a9a68c23e7e3527e2e48/AF002815.1.am.txt
work/96/f5db2c225f181448488a82cae14595/A12991.1.am.txt
work/96/1b5921954023e3801a54d9abc9c141/NM_172078.2.nz.txt
work/76/fd42d7ac75e98f50a84a770b5d236c/FJ475056.1.am.txt
work/4e/97c804cf0e8e1e57807f21df0b381a/AY116593.1.am.txt
work/4e/17c8a3c02561b23799cc87aaac4e1c/NM_017590.5.nz.txt
work/3e/fd7c0ca53764e7aed5b2fa33642dbb/XM_001445002.1.nz.txt
work/37/6fe96f8f632cabae61aa8e1537749d/FJ475055.1.am.txt
work/a6/7b75acc88cbe69def74a0ad96857a5/X60546.1.nz.txt
work/dc/1d3122d3dae16385dbbef53a52de0a/NM_001199860.1.nz.txt
work/12/24a83535a6ce397e0784005297b1ba/NM_001199861.1.nz.txt
work/2b/a867ee0d4275fbfaf174fbbddc589f/AF480269.1.am.txt
work/2b/c43bdedb059bb4821f87b9cf825d64/NM_001199863.1.nz.txt
work/e0/66fb1bc276f1b7a5f6f8a86eea25df/AF338246.1.am.txt
work/c1/26b006f85dcb044305d33c24a57560/NM_001142703.1.nz.txt
work/49/992064df854ef4b79f061128f99d00/LP969837.1.am.txt
work/49/ba212869284c57bf1b38c322e9823b/AF480267.1.am.txt
work/3c/4115623a6aa1140014c79a6c5af3e1/AF480277.1.am.txt
work/3c/b7a3328ca2149ab6a3fa8206688635/LP969842.1.am.txt
work/3c/8484e3d7a70098675de4895aa583b5/NM_001142704.1.nz.txt
work/2e/390f8c3641775548afb50f6f6dfa1d/LP969844.1.am.txt
work/2e/bc03e172750e7d287784f09fbe8f58/JQ687100.1.am.txt
work/b6/b72dcf0c0efe77e548e603ccfa409c/AX244961.1.am.txt
work/4a/6cd4f0e2b702397872cd7199f654e2/AF004836.1.am.txt
work/4a/d251f1b5a04c0f31fbb1f9390825ea/AY116592.1.am.txt
work/a9/17c835fd6c24f43dc9290ee4696384/A12993.1.am.txt
work/a9/83c99c217c0f12ff940281304cf409/LP969849.1.am.txt
work/a9/72cfb68b9a62e8190f5c7939e1d188/AX244967.1.am.txt
work/ed/fc7569cecf54a201db8b18add0f470/X65938.1.nz.txt
work/da/777c9db6a0a02f294af105af0ca563/LP969850.1.am.txt
work/e5/c0b7f97a65927ae3f9f98e598a218c/NM_001174054.1.nz.txt
work/89/c99b6ce5a176ea3c957432f0592c88/AF480285.1.am.txt
work/11/10d0f45ad267571a40eb5ed0972b6b/LP969855.1.am.txt
work/aa/bee5d01361bac5fefb283026f57caf/A12990.1.am.txt
work/aa/5f1ac88b0c6d11d2a4ac371d653ee5/AF480291.1.am.txt
work/eb/97ca246213469c4c1dc3d57e3e01a3/AF480270.1.am.txt
work/eb/4cde2b2a4976d904e56ab46cacebf3/M74218.1.am.txt
work/3a/3d9f77497f0151f85d8743f1aabb10/AY116592.1.am.txt
work/3a/a5fcd757a756af7273b3b84143f8ab/AJ279561.1.am.txt
work/03/4626b1d0cb39df928a1b067c3d9e6c/AF480281.1.am.txt
work/8a/87934deaed3d6dd22d039f86a876c7/LP969838.1.am.txt
work/8a/9e82c832f95ba6e0eadabfe5cf58d5/M29287.1.am.txt
work/9b/eb58d4a3a6b3b02c226726950b03e3/M74217.1.am.txt
work/42/ed1d9e96f559504a8490ee3cb5b475/CT867991.1.am.txt
work/42/fd50d9a8ae71a6d9a52135090c7bae/CS172261.1.am.txt
work/42/6402f712b1a2514e04933713ab9c59/AX244963.1.am.txt
work/42/1094ecbe18dd06c8a5212a2820c30d/NM_172080.2.nz.txt
work/c5/a7c63fb1f7d22664549b195edf4a9a/AF188126.1.am.txt
work/c5/020af5b7a30cf9c311586181289817/CS172270.1.am.txt
work/90/b80783884feac9f07f3a0519cde026/AF480284.1.am.txt
work/90/d82a7796569005db578faa058500af/LP969854.1.am.txt
work/41/4936d61a1dbfdc09d4a62edcfa5f98/Z21640.1.nz.txt
work/fd/9300ceede96c4f285dc94a68e99e61/A12995.1.am.txt
work/bd/43a889997ec27adf7768c9c189a64a/AX244968.1.am.txt
work/bf/6aae3a0bcdc45e32bb1e622ff5abe7/M22308.1.am.txt
work/46/379960c0bd442adc8289e413e7c527/LP969839.1.am.txt
work/72/ea8a7e4e63eb5495a7fdf3444656f0/AX244965.1.am.txt
work/f7/9046a37f74ce4d9e681d1c2380ec4b/JX417180.1.am.txt
work/14/6f36929c88db645e6c5bd5edfbb0d5/NM_001363989.1.nz.txt
work/14/c6493b95ad0cc59623dce29f51a7b0/X65940.1.nz.txt
work/1d/0dd6d012762578ea5e8eefd1cca94e/CT868429.1.am.txt
work/d6/77546d3491d710700729600b35213f/LP969845.1.am.txt
work/52/2557301792d94b87e1054e3e28dd90/AF480289.1.am.txt
work/52/5669c19d6ab3e4bf32fca4f24fe734/AX244965.1.am.txt
work/5b/d6f8735aeece8bee9942de32ace801/NM_001122842.2.nz.txt
work/8c/d3cf3dd335e112fa2d145ba7954a4d/LP969836.1.am.txt
work/04/8e5e3369d2c569945f24f81bf4da57/AF480294.1.am.txt
work/04/09a66c95d9a643ca9892e38e1e770a/XM_001449677.1.nz.txt
work/78/90d4bfeeea49f34e47d9f4411d39be/NR_138070.1.nz.txt
work/80/a25941ca57c92ed04e5e5222368ae0/LP969861.1.am.txt
work/ad/ee94294bf9c91a0966999f5e2c4e53/NM_001174053.1.nz.txt
work/be/f45e5a2cf44d9333a30d492ebdfecc/LP969848.1.am.txt
work/66/d4730ee7b044130c2b799423481182/LP969857.1.am.txt
work/a0/7ead7f8893c8c0373e98b9949b3b27/X65939.1.nz.txt
work/70/a440efa2a98c6a3178099dd7779037/AJ279554.1.am.txt
work/6c/fa1a2a4ba8cfc64af9dabba82196cb/NM_001199621.1.nz.txt
work/6c/fbaf3b40b3dfa6d85710d490658fe5/AX244964.1.am.txt
work/ab/1b7fb7ffcf6c3ae853cd31b6f0ee4c/LP969840.1.am.txt
work/7b/c332a3bb884e589efc4d9b79572838/NM_172081.2.nz.txt
work/2c/3db3992609dd6cc101b31fed3379ae/U65924.1.nz.txt
work/2c/e24826f603a8f42dd5b2433be9e6dd/AF480272.1.am.txt
work/b1/a323556201ba1a1b62a056b681b780/NM_172083.2.nz.txt
work/87/f23858683598e51521f74481f66cc6/AF480266.1.am.txt
work/27/78f68b34f33c3570780c8264516834/XM_001441019.1.nz.txt
work/27/1e17f31a8a303174bf289d8589017e/AF188530.1.am.txt
work/0c/2fb52cf514f853c7b2afeeecb051fc/U88717.1.nz.txt
work/fa/3ef7a39aaf9aef18ad0208e649f186/AJ279560.1.am.txt
work/2a/3e240f4e8b9d3a079cbe973ebd2fa3/NM_001164144.2.nz.txt
work/2a/887fba3df270e17f43f09bde2b52bb/AF338245.1.am.txt
work/30/ef4148afdb830ee7546d45cf151b12/LP969832.1.am.txt
work/8d/ad8caef81fff66d58d5ba7fb7f4f66/NM_001199620.1.nz.txt
work/8d/e5a3567709d9e19c46e0f3f1232331/A12994.1.am.txt
work/45/8a95e76e04215490327d0b1c46e4b3/CT867988.1.am.txt
work/20/a2930e552217c95696a2ea18545c5d/AF004836.1.am.txt
work/20/9a72e16c94b78ef809e23928bcbdc8/AF002816.1.am.txt
work/2f/1986c6c728b6fe9d21c62f420f0e35/AF480287.1.am.txt
work/2f/d65ce575ca71dd9dfd2064344b3b66/CT868274.1.am.txt
work/24/3a3735b3744f3bbdd28172102cff48/AJ279557.1.am.txt
work/24/a350700f618ca66cba9e6056be6c9a/LP969853.1.am.txt
work/b3/fce85344d5fcb666cc38d0df2cbc40/Z21639.1.nz.txt
work/5f/cd8842b3682109f493da295dea6c99/NM_171825.2.nz.txt
work/34/f5ece3bb9eef356d012ebdec503df6/LP969860.1.am.txt
work/a5/5687eb0bf324718847d90da9f6685b/NM_001220.4.nz.txt
work/a5/3e5e2cab61cf080b3dc90611537380/M87502.1.am.txt
work/b8/dc47702bac926d10d5880c40ef618a/AF002815.1.am.txt
work/f6/9ca43a00fc258dea1591d350003e9b/AJ279555.1.am.txt
work/f6/54eea1f4fa606f1907f63a5a2c235b/AF338244.1.am.txt
work/f6/8a9e955c8438756d9239fd58a8d5e9/AF002816.1.am.txt
work/c7/0078b3c0b6e3e04fa2ec82bd1164fc/AF480295.1.am.txt
work/25/fb02915a3584826f5e05cb1d9750b8/NM_007595.5.nz.txt
work/08/0cd6f6368e23bbb4c70a50b673dce6/NM_001293170.1.nz.txt
work/4f/12ba4f11dd390870faacbaf56aa9b2/AF480264.1.am.txt
work/47/5e4f03bf01b036297e78ffe825a7f9/AF480265.1.am.txt
work/47/12c17a782e595d4f7ba9eb84b257aa/NM_172082.2.nz.txt
work/47/90b5e764f101455c8e5c424d6de71a/XM_001424093.1.nz.txt
work/99/8c7eab7e78b558f01e06b83452ece1/NM_001199622.1.nz.txt
work/99/564792040110d4ce42fb591e7f244e/NM_017590.5.nz.txt
```


