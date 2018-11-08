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
Launching `workflow.nf` [deadly_minsky] - revision: ce9cc7016c
[warm up] executor > local
[2f/d47291] Submitted process > Accession_from_N_to_Z (NM_001293170.1 From N to Z)
[a9/d4bdf3] Submitted process > Accession_from_A_to_M (AF188530.1 From A to M)
[a5/cb72fb] Submitted process > Accession_from_N_to_Z (NM_001199860.1 From N to Z)
[eb/80a0f5] Submitted process > Accession_from_A_to_M (AF188126.1 From A to M)
[a4/8658aa] Submitted process > Accession_from_N_to_Z (NM_001199861.1 From N to Z)
[40/81aff1] Submitted process > Accession_from_A_to_M (AF004836.1 From A to M)
[f1/42d99c] Submitted process > Accession_from_N_to_Z (NM_001199862.1 From N to Z)
[84/91e30d] Submitted process > Accession_from_A_to_M (AF002816.1 From A to M)
[29/a57564] Submitted process > Accession_from_N_to_Z (NM_001199863.1 From N to Z)
[b7/b4efe6] Submitted process > Accession_from_A_to_M (AF002815.1 From A to M)
[3d/29b342] Submitted process > Accession_from_N_to_Z (NM_003636.3 From N to Z)
[24/f42a72] Submitted process > Accession_from_A_to_M (CS172270.1 From A to M)
[c4/da21e8] Submitted process > Accession_from_N_to_Z (NM_172130.2 From N to Z)
[18/52e93f] Submitted process > Accession_from_A_to_M (CS172261.1 From A to M)
[f9/8adf4b] Submitted process > Accession_from_N_to_Z (NM_001142703.1 From N to Z)
[c4/2e7145] Submitted process > Accession_from_N_to_Z (NM_001142704.1 From N to Z)
[ae/743c51] Submitted process > Accession_from_A_to_M (AF188126.1 From A to M)
[65/1bea5b] Submitted process > Accession_from_N_to_Z (NM_001220.4 From N to Z)
[11/2c7532] Submitted process > Accession_from_A_to_M (M74217.1 From A to M)
[fc/21704b] Submitted process > Accession_from_A_to_M (AY116592.1 From A to M)
[15/8e6b6b] Submitted process > Accession_from_N_to_Z (NM_172078.2 From N to Z)
[56/8b1361] Submitted process > Accession_from_N_to_Z (NM_172079.2 From N to Z)
[60/566e5e] Submitted process > Accession_from_A_to_M (J04346.1 From A to M)
[5c/9c113a] Submitted process > Accession_from_A_to_M (M74219.1 From A to M)
[df/deefdf] Submitted process > Accession_from_N_to_Z (NM_172080.2 From N to Z)
[8a/8c80f6] Submitted process > Accession_from_A_to_M (M74216.1 From A to M)
[0c/574cb4] Submitted process > Accession_from_N_to_Z (NM_172081.2 From N to Z)
[32/0cacbd] Submitted process > Accession_from_A_to_M (AY116593.1 From A to M)
[24/b6fcf3] Submitted process > Accession_from_N_to_Z (NM_172082.2 From N to Z)
[1e/c28f91] Submitted process > Accession_from_A_to_M (K02254.1 From A to M)
[c3/e187b8] Submitted process > Accession_from_N_to_Z (NM_198947.3 From N to Z)
[f8/be3590] Submitted process > Accession_from_A_to_M (M22308.1 From A to M)
[9e/433e2d] Submitted process > Accession_from_N_to_Z (NM_172083.2 From N to Z)
[db/d91b76] Submitted process > Accession_from_A_to_M (M87502.1 From A to M)
[1a/de036f] Submitted process > Accession_from_N_to_Z (NM_172084.2 From N to Z)
[1b/5b4ee0] Submitted process > Accession_from_A_to_M (M29287.1 From A to M)
[66/4b092f] Submitted process > Accession_from_N_to_Z (NM_001363989.1 From N to Z)
[a6/5129e4] Submitted process > Accession_from_A_to_M (M74218.1 From A to M)
[17/d0388c] Submitted process > Accession_from_N_to_Z (NM_001363990.1 From N to Z)
[be/ba4a8c] Submitted process > Accession_from_A_to_M (AF480296.1 From A to M)
[6a/278758] Submitted process > Accession_from_N_to_Z (NM_015981.3 From N to Z)
[ea/08473f] Submitted process > Accession_from_A_to_M (AF480295.1 From A to M)
[b5/dc9734] Submitted process > Accession_from_N_to_Z (NM_171825.2 From N to Z)
[aa/fddf21] Submitted process > Accession_from_N_to_Z (NM_001174053.1 From N to Z)
[31/c50a1f] Submitted process > Accession_from_A_to_M (AF480294.1 From A to M)
[f8/9da7b3] Submitted process > Accession_from_N_to_Z (NM_001174054.1 From N to Z)
[a8/dada41] Submitted process > Accession_from_A_to_M (AF480293.1 From A to M)
[ea/0b8e89] Submitted process > Accession_from_N_to_Z (NM_007595.5 From N to Z)
[96/20e57c] Submitted process > Accession_from_A_to_M (AF480292.1 From A to M)
[ad/c6659c] Submitted process > Accession_from_N_to_Z (NM_001164144.2 From N to Z)
[a2/bb997d] Submitted process > Accession_from_A_to_M (AF480291.1 From A to M)
[35/183893] Submitted process > Accession_from_N_to_Z (NM_001164145.2 From N to Z)
[b3/b75e38] Submitted process > Accession_from_A_to_M (AF480290.1 From A to M)
[5e/2bdfd1] Submitted process > Accession_from_N_to_Z (NM_032436.3 From N to Z)
[eb/4b5df5] Submitted process > Accession_from_A_to_M (AF480289.1 From A to M)
[95/c21549] Submitted process > Accession_from_N_to_Z (NM_174910.2 From N to Z)
[cb/0b4cf1] Submitted process > Accession_from_A_to_M (AF480288.1 From A to M)
[cb/51fad6] Submitted process > Accession_from_N_to_Z (NM_001122842.2 From N to Z)
[b2/4cfd3c] Submitted process > Accession_from_A_to_M (AF480287.1 From A to M)
[1d/e9c4c7] Submitted process > Accession_from_N_to_Z (NM_001199619.1 From N to Z)
[30/52360f] Submitted process > Accession_from_A_to_M (AF480286.1 From A to M)
[74/18f2d1] Submitted process > Accession_from_N_to_Z (NM_001199620.1 From N to Z)
[d9/d5e183] Submitted process > Accession_from_A_to_M (AF480285.1 From A to M)
[f2/ca80c5] Submitted process > Accession_from_N_to_Z (NM_001199621.1 From N to Z)
[4f/72f6fb] Submitted process > Accession_from_A_to_M (AF480284.1 From A to M)
[a6/9debfa] Submitted process > Accession_from_A_to_M (AF480283.1 From A to M)
[6e/dabcf9] Submitted process > Accession_from_N_to_Z (NM_001199622.1 From N to Z)
[f3/778496] Submitted process > Accession_from_N_to_Z (NM_017590.5 From N to Z)
[04/df9e4d] Submitted process > Accession_from_A_to_M (AF480282.1 From A to M)
[36/aa11c6] Submitted process > Accession_from_N_to_Z (NM_181782.4 From N to Z)
[6e/5168f7] Submitted process > Accession_from_A_to_M (AF480281.1 From A to M)
[d5/d86068] Submitted process > Accession_from_N_to_Z (NR_138070.1 From N to Z)
[d0/c27cba] Submitted process > Accession_from_A_to_M (AF480280.1 From A to M)
[d2/b7ba64] Submitted process > Accession_from_N_to_Z (X65939.1 From N to Z)
[4a/e16862] Submitted process > Accession_from_A_to_M (AF480279.1 From A to M)
[45/f67fa7] Submitted process > Accession_from_N_to_Z (X65938.1 From N to Z)
[f0/45101f] Submitted process > Accession_from_A_to_M (AF480278.1 From A to M)
[bc/2a8b97] Submitted process > Accession_from_N_to_Z (X65940.1 From N to Z)
[4b/376ca3] Submitted process > Accession_from_A_to_M (AF480277.1 From A to M)
[aa/c62be2] Submitted process > Accession_from_A_to_M (AF480276.1 From A to M)
[d7/9cb16f] Submitted process > Accession_from_A_to_M (AF480275.1 From A to M)
[67/52c365] Submitted process > Accession_from_N_to_Z (X14057.1 From N to Z)
[53/196516] Submitted process > Accession_from_N_to_Z (X60546.1 From N to Z)
[a6/d0000d] Submitted process > Accession_from_A_to_M (AF480274.1 From A to M)
[bb/0214a5] Submitted process > Accession_from_A_to_M (AF480273.1 From A to M)
[27/d42b56] Submitted process > Accession_from_N_to_Z (U65924.1 From N to Z)
[df/3733cb] Submitted process > Accession_from_A_to_M (AF480272.1 From A to M)
[98/c16c9e] Submitted process > Accession_from_A_to_M (AF480271.1 From A to M)
[23/825bc8] Submitted process > Accession_from_N_to_Z (Z21640.1 From N to Z)
[b0/af53ba] Submitted process > Accession_from_A_to_M (AF480270.1 From A to M)
[b6/ea0eb7] Submitted process > Accession_from_N_to_Z (Z21639.1 From N to Z)
[a4/b26107] Submitted process > Accession_from_A_to_M (AF480269.1 From A to M)
[85/9422e0] Submitted process > Accession_from_N_to_Z (X00421.1 From N to Z)
[6e/78e65c] Submitted process > Accession_from_A_to_M (AF480268.1 From A to M)
[19/5ae688] Submitted process > Accession_from_N_to_Z (U88717.1 From N to Z)
[02/520c63] Submitted process > Accession_from_A_to_M (AF480267.1 From A to M)
[8d/07236b] Submitted process > Accession_from_N_to_Z (NC_029006.1 From N to Z)
[a8/e8f21c] Submitted process > Accession_from_A_to_M (AF480266.1 From A to M)
[c4/4af49b] Submitted process > Accession_from_A_to_M (AF480265.1 From A to M)
[02/f99b29] Submitted process > Accession_from_N_to_Z (XM_001460179.1 From N to Z)
[9a/608741] Submitted process > Accession_from_N_to_Z (XM_001449677.1 From N to Z)
[35/ffe678] Submitted process > Accession_from_N_to_Z (XM_001445002.1 From N to Z)
[84/90425a] Submitted process > Accession_from_A_to_M (AF480264.1 From A to M)
[5a/dc26df] Submitted process > Accession_from_N_to_Z (XM_001441019.1 From N to Z)
[65/94e14b] Submitted process > Accession_from_A_to_M (AF480263.1 From A to M)
[07/8e1c83] Submitted process > Accession_from_A_to_M (CS172267.1 From A to M)
[97/732cce] Submitted process > Accession_from_N_to_Z (XM_001437902.1 From N to Z)
[4c/ce08ec] Submitted process > Accession_from_A_to_M (AF004836.1 From A to M)
[85/0c1fb2] Submitted process > Accession_from_A_to_M (AF002816.1 From A to M)
[ba/78b7a7] Submitted process > Accession_from_N_to_Z (XM_001424708.1 From N to Z)
[e8/eb5e1d] Submitted process > Accession_from_A_to_M (AF002815.1 From A to M)
[a0/d390ae] Submitted process > Accession_from_N_to_Z (XM_001424093.1 From N to Z)
[8d/7b4ca6] Submitted process > Accession_from_A_to_M (CT868670.1 From A to M)
[46/409ab7] Submitted process > Accession_from_A_to_M (CT868429.1 From A to M)
[cc/f3cc3b] Submitted process > Accession_from_N_to_Z (NM_017590.5 From N to Z)
[61/05ac25] Submitted process > Accession_from_A_to_M (CT868318.1 From A to M)
[55/bdae7e] Submitted process > Accession_from_A_to_M (KM983332.1 From A to M)
[a0/47f363] Submitted process > Accession_from_N_to_Z (NR_029944.1 From N to Z)
[e0/5fc6c2] Submitted process > Accession_from_A_to_M (CT868274.1 From A to M)
[76/4f2dde] Submitted process > Accession_from_A_to_M (CT868085.1 From A to M)
[23/47c932] Submitted process > Accession_from_A_to_M (CT868068.1 From A to M)
[72/05a642] Submitted process > Accession_from_A_to_M (CT868030.1 From A to M)
[c0/c74f28] Submitted process > Accession_from_A_to_M (CT867988.1 From A to M)
[c0/5fa5d1] Submitted process > Accession_from_A_to_M (CT868163.1 From A to M)
[0e/4030f7] Submitted process > Accession_from_A_to_M (CT867991.1 From A to M)
[72/9d1ff5] Submitted process > Accession_from_A_to_M (AX244968.1 From A to M)
[8a/8a7aad] Submitted process > Accession_from_A_to_M (AX244967.1 From A to M)
[17/844b48] Submitted process > Accession_from_A_to_M (AX244966.1 From A to M)
[2b/7ae5cc] Submitted process > Accession_from_A_to_M (AX244965.1 From A to M)
[1b/8969c5] Submitted process > Accession_from_A_to_M (AX244964.1 From A to M)
[b6/aacf7b] Submitted process > Accession_from_A_to_M (AX244963.1 From A to M)
[1a/0ad54d] Submitted process > Accession_from_A_to_M (AX244962.1 From A to M)
[34/825c24] Submitted process > Accession_from_A_to_M (AX244961.1 From A to M)
[b7/6d0741] Submitted process > Accession_from_A_to_M (LP969861.1 From A to M)
[4d/25d807] Submitted process > Accession_from_A_to_M (LP969860.1 From A to M)
[51/cbdc7a] Submitted process > Accession_from_A_to_M (LP969859.1 From A to M)
[ad/bfcccb] Submitted process > Accession_from_A_to_M (LP969858.1 From A to M)
[8b/31582f] Submitted process > Accession_from_A_to_M (LP969857.1 From A to M)
[0d/ef37ae] Submitted process > Accession_from_A_to_M (LP969856.1 From A to M)
[d3/0b68a8] Submitted process > Accession_from_A_to_M (LP969855.1 From A to M)
[9c/595cf4] Submitted process > Accession_from_A_to_M (LP969854.1 From A to M)
[39/54dd9e] Submitted process > Accession_from_A_to_M (LP969853.1 From A to M)
[a7/540b58] Submitted process > Accession_from_A_to_M (LP969852.1 From A to M)
[20/6cef13] Submitted process > Accession_from_A_to_M (LP969851.1 From A to M)
[cf/96d587] Submitted process > Accession_from_A_to_M (LP969850.1 From A to M)
[21/e0ffee] Submitted process > Accession_from_A_to_M (LP969849.1 From A to M)
[1b/cafa7b] Submitted process > Accession_from_A_to_M (LP969848.1 From A to M)
[90/a1dd1a] Submitted process > Accession_from_A_to_M (LP969847.1 From A to M)
[d8/a6202e] Submitted process > Accession_from_A_to_M (LP969846.1 From A to M)
[fe/b1922d] Submitted process > Accession_from_A_to_M (LP969845.1 From A to M)
[e6/7dbf24] Submitted process > Accession_from_A_to_M (LP969844.1 From A to M)
[d7/afa9cf] Submitted process > Accession_from_A_to_M (LP969843.1 From A to M)
[ae/be0049] Submitted process > Accession_from_A_to_M (LP969842.1 From A to M)
[07/f2bc21] Submitted process > Accession_from_A_to_M (LP969841.1 From A to M)
[85/34fcb6] Submitted process > Accession_from_A_to_M (LP969840.1 From A to M)
[53/c1e82a] Submitted process > Accession_from_A_to_M (LP969839.1 From A to M)
[ec/5cb073] Submitted process > Accession_from_A_to_M (LP969838.1 From A to M)
[1d/dcc3cc] Submitted process > Accession_from_A_to_M (LP969837.1 From A to M)
[87/122147] Submitted process > Accession_from_A_to_M (LP969836.1 From A to M)
[90/1d2102] Submitted process > Accession_from_A_to_M (LP969834.1 From A to M)
[10/909855] Submitted process > Accession_from_A_to_M (LP969832.1 From A to M)
[50/22f34d] Submitted process > Accession_from_A_to_M (AF338248.1 From A to M)
[0a/730aa1] Submitted process > Accession_from_A_to_M (AF338247.1 From A to M)
[9a/3efec9] Submitted process > Accession_from_A_to_M (AF338246.1 From A to M)
[9d/e76138] Submitted process > Accession_from_A_to_M (AF338245.1 From A to M)
[76/89769f] Submitted process > Accession_from_A_to_M (AF338244.1 From A to M)
[51/f5fdfb] Submitted process > Accession_from_A_to_M (AF188530.1 From A to M)
[09/1a388e] Submitted process > Accession_from_A_to_M (AF004836.1 From A to M)
[20/eed338] Submitted process > Accession_from_A_to_M (AF002816.1 From A to M)
[25/473320] Submitted process > Accession_from_A_to_M (AF002815.1 From A to M)
[c8/9b42c6] Submitted process > Accession_from_A_to_M (FJ475056.1 From A to M)
[9f/0e37b5] Submitted process > Accession_from_A_to_M (FJ475055.1 From A to M)
[ed/1e97ff] Submitted process > Accession_from_A_to_M (JX417182.1 From A to M)
[ba/62c8a6] Submitted process > Accession_from_A_to_M (JX417181.1 From A to M)
[59/39d3a9] Submitted process > Accession_from_A_to_M (JX417180.1 From A to M)
[bb/257cf2] Submitted process > Accession_from_A_to_M (JQ687100.1 From A to M)
[cc/a8b30f] Submitted process > Accession_from_A_to_M (JQ687099.1 From A to M)
[5c/4b76cc] Submitted process > Accession_from_A_to_M (GU144588.1 From A to M)
[82/c6a46d] Submitted process > Accession_from_A_to_M (AY116592.1 From A to M)
[37/b2e2f3] Submitted process > Accession_from_A_to_M (AF188126.1 From A to M)
[00/c46801] Submitted process > Accession_from_A_to_M (AX244968.1 From A to M)
[b6/bb3705] Submitted process > Accession_from_A_to_M (AX244967.1 From A to M)
[de/99e4a0] Submitted process > Accession_from_A_to_M (AX244966.1 From A to M)
[3b/f49753] Submitted process > Accession_from_A_to_M (AX244965.1 From A to M)
[2d/497c6c] Submitted process > Accession_from_A_to_M (AX244964.1 From A to M)
[f0/78a7a3] Submitted process > Accession_from_A_to_M (AX244963.1 From A to M)
[e7/7d4c7a] Submitted process > Accession_from_A_to_M (AX244962.1 From A to M)
[b2/5335ed] Submitted process > Accession_from_A_to_M (AX244961.1 From A to M)
[13/303525] Submitted process > Accession_from_A_to_M (AJ279563.1 From A to M)
[cb/5a0a8f] Submitted process > Accession_from_A_to_M (AJ279561.1 From A to M)
[76/0115a7] Submitted process > Accession_from_A_to_M (AJ279560.1 From A to M)
[02/cd3ae4] Submitted process > Accession_from_A_to_M (AJ279559.1 From A to M)
[37/733b34] Submitted process > Accession_from_A_to_M (AJ279558.1 From A to M)
[9d/6ac767] Submitted process > Accession_from_A_to_M (AJ279557.1 From A to M)
[e4/945339] Submitted process > Accession_from_A_to_M (AJ279556.1 From A to M)
[6b/fb1ed5] Submitted process > Accession_from_A_to_M (AJ279555.1 From A to M)
[5b/9d3585] Submitted process > Accession_from_A_to_M (AJ279554.1 From A to M)
[fe/7ab840] Submitted process > Accession_from_A_to_M (A12993.1 From A to M)
[13/249f60] Submitted process > Accession_from_A_to_M (A12992.1 From A to M)
[dd/c3d399] Submitted process > Accession_from_A_to_M (A12991.1 From A to M)
[61/00710c] Submitted process > Accession_from_A_to_M (A12990.1 From A to M)
[0e/0cb7fe] Submitted process > Accession_from_A_to_M (A12989.1 From A to M)
[3e/f9d739] Submitted process > Accession_from_A_to_M (A12988.1 From A to M)
[01/5abdef] Submitted process > Accession_from_A_to_M (A12987.1 From A to M)
[3c/6eb1b2] Submitted process > Accession_from_A_to_M (A12986.1 From A to M)
[72/fd4f14] Submitted process > Accession_from_A_to_M (A12985.1 From A to M)
[b7/360459] Submitted process > Accession_from_A_to_M (A12997.1 From A to M)
[c5/6a96a2] Submitted process > Accession_from_A_to_M (A12996.1 From A to M)
[28/44e6b0] Submitted process > Accession_from_A_to_M (A12995.1 From A to M)
[6f/6c84c9] Submitted process > Accession_from_A_to_M (A12994.1 From A to M)
```


## Files

```
work/9f/0e37b5541ac590de3f7ecc07399431/FJ475055.1.am.txt
work/98/c16c9e90df2fc13cdc88c24fdd70ac/AF480271.1.am.txt
work/23/47c932c26c47f807a3fe39f27437e9/CT868068.1.am.txt
work/23/825bc8d181997d22285081916dc79c/Z21640.1.nz.txt
work/9a/3efec956bd922a24b0f7f376a7dbac/AF338246.1.am.txt
work/9a/6087416122156354161745fd0ea910/XM_001449677.1.nz.txt
work/cb/51fad6baa75c60f7e7017fe2048330/NM_001122842.2.nz.txt
work/cb/5a0a8f89d8826cb5d64c61382c7e2a/AJ279561.1.am.txt
work/cb/0b4cf1f726640f37845211bdba8397/AF480288.1.am.txt
work/6f/6c84c9217461142b3b078039a53a0e/A12994.1.am.txt
work/97/732cce313529d20b705e0ad699cc34/XM_001437902.1.nz.txt
work/a8/dada41079da4c90406b67060ba7704/AF480293.1.am.txt
work/a8/e8f21c4dbbc34b964566a41005b1b8/AF480266.1.am.txt
work/0d/ef37ae236c3916c3a44c39cf9fbbc9/LP969856.1.am.txt
work/6b/fb1ed5821ffba7057640b40f9f19a0/AJ279555.1.am.txt
work/18/52e93f0766db8dbb7f331700eab970/CS172261.1.am.txt
work/f8/be35903156c952397d9517d673311f/M22308.1.am.txt
work/f8/9da7b3f3ebfecd849646e6c7898129/NM_001174054.1.nz.txt
work/ec/5cb073489c029aca99b7b1f532c67f/LP969838.1.am.txt
work/c3/e187b852c6c44f91605ad085a9b698/NM_198947.3.nz.txt
work/b7/b4efe6143a2cb46c39a3a7abb5006e/AF002815.1.am.txt
work/b7/36045957baa1de254f65d7161f1c0a/A12997.1.am.txt
work/b7/6d07418188c42b1010ad6fffe5c85c/LP969861.1.am.txt
work/f3/778496023766f8349e4799278038af/NM_017590.5.nz.txt
work/f9/8adf4b8cf0d7ab1e0c25c95446ee5a/NM_001142703.1.nz.txt
work/1e/c28f91a5f9bba52f85b2179df37996/K02254.1.am.txt
work/21/e0ffeed4b0f1d97fe2ab6fb346e913/LP969849.1.am.txt
work/0a/730aa1dac769a0d9f26d1153baaafb/AF338247.1.am.txt
work/07/8e1c83e91568b045c9fdbaf26149f3/CS172267.1.am.txt
work/07/f2bc2185d495540a76fa0724182b7f/LP969841.1.am.txt
work/5a/dc26df9eef7dcfac3a9045ebb99710/XM_001441019.1.nz.txt
work/59/39d3a9be9bcff6bcdaeea29aaeecc4/JX417180.1.am.txt
work/d8/a6202e7ce0c7a6c8154f5e6f43a788/LP969846.1.am.txt
work/9c/595cf49b81003b9ed11842f8bbd2a2/LP969854.1.am.txt
work/d7/afa9cf07ef50050e0b349352ecb3b9/LP969843.1.am.txt
work/d7/9cb16f60cb6a671ff3b0772155f796/AF480275.1.am.txt
work/5c/4b76cc6600040c86f878a0e4de8bcb/GU144588.1.am.txt
work/5c/9c113ae7a2798f0341eeeb22efd5bc/M74219.1.am.txt
work/4d/25d807035c261c0a40267591d0f1be/LP969860.1.am.txt
work/ba/78b7a7350b48da07611b27c2917fae/XM_001424708.1.nz.txt
work/ba/62c8a6246d141bdb6a9b975ce74192/JX417181.1.am.txt
work/31/c50a1f251b00ccd942fbce9c55a833/AF480294.1.am.txt
work/b0/af53ba1626aad9f0cc8245206f5ed7/AF480270.1.am.txt
work/82/c6a46d5cfef82212d5a3845eb2e9eb/AY116592.1.am.txt
work/17/d0388ced61ffc46464f4674b6cd933/NM_001363990.1.nz.txt
work/17/844b4835ac8e4875e33344a43db255/AX244966.1.am.txt
work/39/54dd9e9f55a14b95e55e37cb3278a9/LP969853.1.am.txt
work/fc/21704b36fe608d83ae0040a3cf04c9/AY116592.1.am.txt
work/a4/8658aa51fd9c25e8fa90a0d9778ffa/NM_001199861.1.nz.txt
work/a4/b261079f36bd75d845fc003eb944fe/AF480269.1.am.txt
work/6a/278758cf2ccb9891f38046ffc9d47e/NM_015981.3.nz.txt
work/32/0cacbd394bdc516a46c5ebbd79b46e/AY116593.1.am.txt
work/13/3035251c11d1b9d7dd38cc51213ace/AJ279563.1.am.txt
work/13/249f60970678736275488f2fc9fa67/A12992.1.am.txt
work/3d/29b342831726ebed901208f8afd960/NM_003636.3.nz.txt
work/b5/dc9734df3b6376449d894804542c47/NM_171825.2.nz.txt
work/e7/7d4c7a9c10186ddc2ac597e2ab125f/AX244962.1.am.txt
work/9d/6ac767e28bcbf1c9123d5249498d65/AJ279557.1.am.txt
work/9d/e7613877ef3377a4d9c51a6ea5bb3b/AF338245.1.am.txt
work/95/c21549f095a99b20cfa2eaec7280a6/NM_174910.2.nz.txt
work/f2/ca80c5f2293724256d37990c378c04/NM_001199621.1.nz.txt
work/cc/a8b30f2a7c5011a6e16cd28308fc6f/JQ687099.1.am.txt
work/cc/f3cc3bd1eadabcc46445e41661cc97/NM_017590.5.nz.txt
work/e4/9453397c8940ae570392fcc4d43f0f/AJ279556.1.am.txt
work/36/aa11c69d008a1734aa41d100464b8e/NM_181782.4.nz.txt
work/29/a57564e1e2730dc0e74644ddab7825/NM_001199863.1.nz.txt
work/d9/d5e183156ec3797a4aa4614c3b7c56/AF480285.1.am.txt
work/15/8e6b6b9b97104188dea2a0e36fd37a/NM_172078.2.nz.txt
work/4b/376ca3379423de75b7ef1df924519d/AF480277.1.am.txt
work/c0/c74f289331e1ef0f22aa7d199236ca/CT867988.1.am.txt
work/c0/5fa5d125705fa346b64d4136fe41fd/CT868163.1.am.txt
work/50/22f34d7dd66a56c803b6bfd7de4287/AF338248.1.am.txt
work/65/94e14bf21927b431cd63abfce665ff/AF480263.1.am.txt
work/65/1bea5ba0fb4999ab853feac87f042d/NM_001220.4.nz.txt
work/1a/0ad54d62be56e10670fe450abec913/AX244962.1.am.txt
work/1a/de036fcc08234b14a55ff9bbd677e7/NM_172084.2.nz.txt
work/bb/0214a5e6d347e3cf7cce79b84b54b4/AF480273.1.am.txt
work/bb/257cf2d5df7d5f0ed1657e8a2a7ca7/JQ687100.1.am.txt
work/bc/2a8b977758f97ed867fc85925928ae/X65940.1.nz.txt
work/a2/bb997dc6c629a8e00bd62faf11b344/AF480291.1.am.txt
work/10/909855565b5a2d0cc2a59614b1602d/LP969832.1.am.txt
work/a7/540b58692787d53648ad11415ca342/LP969852.1.am.txt
work/9e/433e2dc1329782c202b5299559dbc1/NM_172083.2.nz.txt
work/e6/7dbf2471db7816170cf16b518ea281/LP969844.1.am.txt
work/84/90425ae49f74a6ba0929dd0dcc7ba0/AF480264.1.am.txt
work/84/91e30d1c645bb2f373183ef14c94bc/AF002816.1.am.txt
work/4c/ce08ec81422521bfa875ed5f83f736/AF004836.1.am.txt
work/5e/2bdfd1f93b0ebdcbf4c0f010f10556/NM_032436.3.nz.txt
work/e8/eb5e1da396c97a9f0090014a58f5dd/AF002815.1.am.txt
work/cf/96d587b6ed41efcfa711bbc3f8dc7f/LP969850.1.am.txt
work/67/52c365d1a7d8c708c146d23d752ae4/X14057.1.nz.txt
work/02/f99b29cab42b63a5fabb9906110d2c/XM_001460179.1.nz.txt
work/02/520c6369e66197f04d68c408282408/AF480267.1.am.txt
work/02/cd3ae4de22017f2005f32c9187aac9/AJ279559.1.am.txt
work/61/05ac2535115bb2b4857f7227586a06/CT868318.1.am.txt
work/61/00710c0d6f15c401e5ae6f90ff4579/A12990.1.am.txt
work/0e/4030f77b3023e1987fe6b483c5b986/CT867991.1.am.txt
work/0e/0cb7fe9b4cf82cb8552096dd5fdba1/A12989.1.am.txt
work/6e/5168f72c1d4b849630787a1e2f01fa/AF480281.1.am.txt
work/6e/dabcf9cd0122ef5298987bf88eb65d/NM_001199622.1.nz.txt
work/6e/78e65c3b470a1f9f5f5ff78adcfcac/AF480268.1.am.txt
work/8b/31582fd31122ef30480203be6f36f1/LP969857.1.am.txt
work/19/5ae688c2059f21857500223eec7654/U88717.1.nz.txt
work/56/8b13617df584f29ef7fea693357707/NM_172079.2.nz.txt
work/1b/8969c5678e8547c2027a17ef8fd744/AX244964.1.am.txt
work/1b/5b4ee0bd5944225140e562f2794ca3/M29287.1.am.txt
work/1b/cafa7b65345faba26bbcca66f1e5d0/LP969848.1.am.txt
work/09/1a388e01f59c0a5bd726cae037e758/AF004836.1.am.txt
work/c8/9b42c6cac7c1cc7bc8efd76f708845/FJ475056.1.am.txt
work/96/20e57cd0777b5fcaf803c13512c3ac/AF480292.1.am.txt
work/76/89769fb23d4ed6d949a75b905bd9fd/AF338244.1.am.txt
work/76/4f2ddeb0d404b16a3013a1fd934256/CT868085.1.am.txt
work/76/0115a7c097c20d22aa0a95eaf7596d/AJ279560.1.am.txt
work/d2/b7ba644e223b2f4d7a6322e4bafaef/X65939.1.nz.txt
work/3e/f9d7396d9c2de352c29057dc41d668/A12988.1.am.txt
work/37/733b34f16e41da7fa60ccb173e85f7/AJ279558.1.am.txt
work/37/b2e2f32716df3099fbe24fadc5752f/AF188126.1.am.txt
work/b2/4cfd3c54633349352cef6478c577f2/AF480287.1.am.txt
work/b2/5335ed24edadb09d25565f2ece3160/AX244961.1.am.txt
work/2d/497c6c3a91ed406c68543bb905598d/AX244964.1.am.txt
work/de/99e4a06e52f8df0ecb2d0f7c4a3d6c/AX244966.1.am.txt
work/a6/9debfa6aa0b9c35cc72cabf767b56d/AF480283.1.am.txt
work/a6/d0000d0cfd9590b84df3e8b752a10e/AF480274.1.am.txt
work/a6/5129e4027cd90c7d0012a0977058bd/M74218.1.am.txt
work/2b/7ae5cc4f203a2ced4a9d16b502bd5c/AX244965.1.am.txt
work/d5/d86068707932e15c6db4b3e2e93bd8/NR_138070.1.nz.txt
work/e0/5fc6c2d326fa6effe359982b9ff1dd/CT868274.1.am.txt
work/3c/6eb1b2c5fb40144897cd9c064876fb/A12986.1.am.txt
work/00/c46801cddb2e424dcae0956dd55f00/AX244968.1.am.txt
work/b6/aacf7b73925ec118827f419da11100/AX244963.1.am.txt
work/b6/ea0eb716e73a1c4405deced82a584f/Z21639.1.nz.txt
work/b6/bb37054a1a969fc12216ed7d74ef70/AX244967.1.am.txt
work/4a/e1686242481cd5a855de64234855ac/AF480279.1.am.txt
work/f0/78a7a356c792cef02a97b15433be4f/AX244963.1.am.txt
work/f0/45101fe4e746f5151aebe1f129fab0/AF480278.1.am.txt
work/a9/d4bdf366835c884e9c25203d531aba/AF188530.1.am.txt
work/ed/1e97ffdde1343adf540d18bce9716c/JX417182.1.am.txt
work/d3/0b68a8ec6bf65ffb0441ad0f025747/LP969855.1.am.txt
work/11/2c7532490d9e1e07f184b0603dac46/M74217.1.am.txt
work/aa/fddf215bfcad1a975086e7f150fa84/NM_001174053.1.nz.txt
work/aa/c62be29839ad18b8c2aff223f78263/AF480276.1.am.txt
work/60/566e5e783ff76619d0533a47aa7ecc/J04346.1.am.txt
work/eb/80a0f5cb83c3d4d8f49d978cb28499/AF188126.1.am.txt
work/eb/4b5df56fb1427f08f5b317c33aaabd/AF480289.1.am.txt
work/51/cbdc7ae7292853201412b6a10440e2/LP969859.1.am.txt
work/51/f5fdfbd25011fdf22353f90d210c15/AF188530.1.am.txt
work/28/44e6b0590c3f3705ab43a4559526a2/A12995.1.am.txt
work/8a/8c80f672d973cbee3f70776af76de3/M74216.1.am.txt
work/8a/8a7aad2b9bb4249e7c395efbbeaec0/AX244967.1.am.txt
work/c5/6a96a2749eee0a8c15f711c8b29303/A12996.1.am.txt
work/90/1d2102d9a9f3a7ff247eecb1a723a4/LP969834.1.am.txt
work/90/a1dd1ad23dc03a205ab7b0b0bc7b76/LP969847.1.am.txt
work/74/18f2d1044a152c4d804cfc893a4234/NM_001199620.1.nz.txt
work/c4/4af49ba1eb21f5a0e607fb8b3783bc/AF480265.1.am.txt
work/c4/da21e8eab636833a3a96504321472f/NM_172130.2.nz.txt
work/c4/2e7145ab2fab570aaf92b487a2e63e/NM_001142704.1.nz.txt
work/46/409ab7831984e9eaa89a65e39d424c/CT868429.1.am.txt
work/53/c1e82a46205c8a26f572e2dbfdeeaa/LP969839.1.am.txt
work/53/196516fd61cdb1c91c7d6832548dda/X60546.1.nz.txt
work/f1/42d99c6b1b8e416781f9d3cb76a384/NM_001199862.1.nz.txt
work/df/deefdf9bd76171eaf20a516fa21dc7/NM_172080.2.nz.txt
work/df/3733cb7803493010dac9d869bd25bb/AF480272.1.am.txt
work/72/9d1ff5d9a2df122f6e6e82910a0e8f/AX244968.1.am.txt
work/72/05a6428e7dca57fb26f6db400c126a/CT868030.1.am.txt
work/72/fd4f144daf7419b70c54d3b03ae031/A12985.1.am.txt
work/85/34fcb6f7de28227f6eaef9a7165aca/LP969840.1.am.txt
work/85/0c1fb2f808d7dd5a15531030c6d1b2/AF002816.1.am.txt
work/85/9422e0e412ca718402b4f4b0b1a4b9/X00421.1.nz.txt
work/1d/e9c4c740f2f77a9529f5c7482b25e5/NM_001199619.1.nz.txt
work/1d/dcc3cce09bb1f3bab997a739e75a67/LP969837.1.am.txt
work/3b/f49753450bb301506862c05e9aa69e/AX244965.1.am.txt
work/5b/9d358524fa6f2fc68d7cc0e00476eb/AJ279554.1.am.txt
work/dd/c3d399fcae19a54e7dc6070ffdd402/A12991.1.am.txt
work/04/df9e4d7984a709c06f104684e573dd/AF480282.1.am.txt
work/ad/bfcccbdd79317638767d6dea00ca13/LP969858.1.am.txt
work/ad/c6659ca3a513ab739821e940db2377/NM_001164144.2.nz.txt
work/be/ba4a8c731279ccc19ace82c8ea4774/AF480296.1.am.txt
work/66/4b092fe9bf74525298335cfb1e7db3/NM_001363989.1.nz.txt
work/a0/47f36344ef6767830ecb2291419545/NR_029944.1.nz.txt
work/a0/d390aeec4b56d75f2f6f4ae29344d6/XM_001424093.1.nz.txt
work/ea/08473f770e43a54a8262971c45bcdc/AF480295.1.am.txt
work/ea/0b8e89361facca38f680b56c57c954/NM_007595.5.nz.txt
work/35/1838938f41a5d188776283040b278e/NM_001164145.2.nz.txt
work/35/ffe678337791e0c49e58f3592b6984/XM_001445002.1.nz.txt
work/55/bdae7e5cadf3f802bdfb6bb0924819/KM983332.1.am.txt
work/87/12214773e8ac981c7a6c5f859df0cb/LP969836.1.am.txt
work/27/d42b56450a3619e4153aee81f5a740/U65924.1.nz.txt
work/0c/574cb4496656cb029df0909160ef3b/NM_172081.2.nz.txt
work/db/d91b761d0d9e8e6afeac8b0cd05515/M87502.1.am.txt
work/30/52360f724f37995a9eeb9d32a05976/AF480286.1.am.txt
work/8d/07236b49b603bfd5cdc6b02b6eb6b1/NC_029006.1.nz.txt
work/8d/7b4ca692906f56e5b025c3e76e1e67/CT868670.1.am.txt
work/45/f67fa732be11fbd1ba46493b69023d/X65938.1.nz.txt
work/20/eed33815d7789afd61cd8a9ed11d70/AF002816.1.am.txt
work/20/6cef13db6c086bec239ee6f553a4bf/LP969851.1.am.txt
work/2f/d472910d440cb723c6d2c27384aed3/NM_001293170.1.nz.txt
work/24/f42a721830b391622af813935ddf59/CS172270.1.am.txt
work/24/b6fcf39ac6cdab5b43474e3cdb5e12/NM_172082.2.nz.txt
work/ae/743c51297b8f6780feb28bafec6196/AF188126.1.am.txt
work/ae/be00499681abcf3717f6a2cdb8bb6d/LP969842.1.am.txt
work/b3/b75e3820df8c18aa5f4034b1810666/AF480290.1.am.txt
work/01/5abdef31112eb16c891f49506e846f/A12987.1.am.txt
work/fe/7ab8408e783ded34615ef622b9f8b4/A12993.1.am.txt
work/fe/b1922dfe67dfb670ef3cc185e06b9f/LP969845.1.am.txt
work/34/825c24b4b425cfc918e6fd315f95a8/AX244961.1.am.txt
work/a5/cb72fb13d76396f7becf96a50de18b/NM_001199860.1.nz.txt
work/25/473320965571b4a4489b0b0650d46c/AF002815.1.am.txt
work/4f/72f6fb1c7ca5ec06c7dfc6a7a2a285/AF480284.1.am.txt
work/40/81aff1c250c063ade250702609a79c/AF004836.1.am.txt
work/d0/c27cba7450eae59f50ab4562edbee2/AF480280.1.am.txt
```


