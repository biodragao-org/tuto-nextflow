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
../bin/nextflow run workflow.nf --acns '../data/list*.acns.txt'
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [trusting_heyrovsky] - revision: 5a86ad5e38
[warm up] executor > local
[81/c138c7] Submitted process > sortAcns (sorting list1.acns.txt)
[d0/1c1f35] Submitted process > sortAcns (sorting list4.acns.txt)
[16/70bc66] Submitted process > sortAcns (sorting list2.acns.txt)
[d7/63698a] Submitted process > sortAcns (sorting list3.acns.txt)
[b5/00f691] Submitted process > commonAcns (comm list2.acns.txt vs list4.acns.txt)
[a0/27d672] Submitted process > commonAcns (comm list1.acns.txt vs list4.acns.txt)
[c1/24d409] Submitted process > commonAcns (comm list1.acns.txt vs list2.acns.txt)
[72/1156f7] Submitted process > commonAcns (comm list3.acns.txt vs list4.acns.txt)
[59/cf8716] Submitted process > commonAcns (comm list2.acns.txt vs list3.acns.txt)
[56/d4c3d4] Submitted process > commonAcns (comm list1.acns.txt vs list3.acns.txt)
[e1/bf265a] Submitted process > listCommons (common list size: 6)
[8a/314987] Submitted process > eachAcn (dowloading AF002815.1)
[15/eb36d5] Submitted process > eachAcn (dowloading AF002816.1)
[4e/0477b7] Submitted process > filterSize (size for AF002815.1.fa)
[9e/911994] Submitted process > filterSize (size for AF002816.1.fa)
[19/39675c] Submitted process > eachAcn (dowloading AF004836.1)
[ff/1d9cd2] Submitted process > filterSize (size for AF004836.1.fa)
[5c/f8dd7b] Submitted process > eachAcn (dowloading AF188126.1)
[58/6d1a04] Submitted process > eachAcn (dowloading AF188530.1)
[ed/12f680] Submitted process > filterSize (size for AF188126.1.fa)
[67/e31ce7] Submitted process > eachAcn (dowloading AX244961.1)
[7a/84fc33] Submitted process > filterSize (size for AF188530.1.fa)
[73/172e4a] Submitted process > eachAcn (dowloading AX244962.1)
[02/6aa0ca] Submitted process > filterSize (size for AX244961.1.fa)
[ee/a43847] Submitted process > eachAcn (dowloading AX244963.1)
[42/0ba28a] Submitted process > filterSize (size for AX244962.1.fa)
[1c/e1c3ef] Submitted process > eachAcn (dowloading AX244964.1)
[74/d0c7c5] Submitted process > filterSize (size for AX244963.1.fa)
[5d/e240cb] Submitted process > eachAcn (dowloading AX244965.1)
[f3/77b692] Submitted process > filterSize (size for AX244964.1.fa)
[57/5dbc43] Submitted process > eachAcn (dowloading AX244966.1)
[be/c6ae0a] Submitted process > filterSize (size for AX244965.1.fa)
[e8/c820cd] Submitted process > filterSize (size for AX244966.1.fa)
[73/8f7ab2] Submitted process > eachAcn (dowloading AX244967.1)
[31/f48fe1] Submitted process > eachAcn (dowloading AX244968.1)
[82/caab06] Submitted process > filterSize (size for AX244967.1.fa)
[ac/1f3d1c] Submitted process > eachAcn (dowloading AY116592.1)
[40/3f43d9] Submitted process > filterSize (size for AX244968.1.fa)
[7d/feafd7] Submitted process > filterSize (size for AY116592.1.fa)
[17/cda59a] Submitted process > eachAcn (dowloading NM_017590.5)
[40/2748c0] Submitted process > filterSize (size for NM_017590.5.fa)
```


## Files

```
work/73/172e4afa18fe8e9c1fe107f9032d9d/AX244962.1.fa
work/73/8f7ab2c80f2375d09503ded67e4a8d/AX244967.1.fa
work/38/a4bc229092d472a1f728b36fc7ea85/list1.acns.txt
work/38/a4bc229092d472a1f728b36fc7ea85/list1.acns.txt.sorted.txt
work/00/d14a0800fa29ec79b771843291cfb1/AF002815.1.fa
work/e8/c820cd41c9fe0ba991a2e309b2fbda/AX244966.1.fa.small.fa
work/e8/c820cd41c9fe0ba991a2e309b2fbda/AX244966.1.fa
work/81/c138c7ccb5a65444c77076b6e1729a/list1.acns.txt
work/81/c138c7ccb5a65444c77076b6e1729a/list1.acns.txt.sorted.txt
work/cd/399343befa12aa3f8320c92cb9a093/AF188126.1.fa
work/58/6d1a0436c8e1b4f44ebf12c1cf6a74/AF188530.1.fa
work/58/508eca5211995bed1f7c0f69027a56/AX244961.1.fa
work/58/508eca5211995bed1f7c0f69027a56/AX244961.1.fa.small.fa
work/a8/db375827585f5e20fb69fca740f4c0/AF188530.1.fa
work/a8/b0b716481af570eaeb43eedaf0d441/comm.txt
work/c3/b69a9e385ee0562bec313e8891aa32/AX244963.1.fa
work/31/f48fe1eb4f1e15927d6106d481ec1a/AX244968.1.fa
work/5d/e240cb639adefb24d6ad8e736d6f74/AX244965.1.fa
work/f5/35ba63debcd68c7cb973529e4fb969/comm.txt
work/df/d629b041691c59bf1c228acb090e12/comm.txt
work/df/033ce52312f12bfda09b66e0f40985/AF188530.1.fa
work/bb/ccf42f5a3e1f5137ec323c4681e98d/AF002816.1.fa
work/d0/1c1f35574097f99813ef110bd6ea41/list4.acns.txt
work/d0/1c1f35574097f99813ef110bd6ea41/list4.acns.txt.sorted.txt
work/ee/a43847d5b192a107013261c8afa790/AX244963.1.fa
work/60/d1c8e38379f6a9163bc088477e2f26/AX244961.1.fa
work/60/d1c8e38379f6a9163bc088477e2f26/AX244961.1.fa.small.fa
work/f9/b526f0ce6e4e912351f636922f678b/AF002815.1.fa
work/0a/51fb53849ff0078ba8824ae3573a44/AF004836.1.fa
work/97/1260da651905471f3989cd9687d64e/NM_017590.5.fa
work/b5/00f691352a2df59c25e2ca732ceea7/comm.txt
work/b5/9e149686bd98807d8455f336d9b651/comm.txt
work/43/b034cdf0f47e43a850ed0cf21bf078/NM_017590.5.fa
work/41/dee083b51336a72b09f627b9286fc2/AX244968.1.fa.small.fa
work/41/dee083b51336a72b09f627b9286fc2/AX244968.1.fa
work/18/344f0fc455f05feedb04345a94e5e6/list3.acns.txt
work/18/344f0fc455f05feedb04345a94e5e6/list3.acns.txt.sorted.txt
work/86/279311363a80061c50016593a568ca/table.csv
work/86/279311363a80061c50016593a568ca/distcint.acns.txt
work/86/7b0caa9f015b4b56f09da765a89b91/comm.txt
work/bc/fefb62c77aac379c5e22fbc2b9ca19/AX244963.1.fa
work/1c/e1c3ef91978ef5b429e3386a116774/AX244964.1.fa
work/5a/a596c299d81115edc64b1a6878ed67/AF004836.1.fa
work/5a/331cdf98ba2b8e728f2d447e12732b/AX244964.1.fa
work/5a/331cdf98ba2b8e728f2d447e12732b/AX244964.1.fa.small.fa
work/84/dded91c0d4cf5f5a0e0255ea92f74e/AX244962.1.fa.small.fa
work/84/dded91c0d4cf5f5a0e0255ea92f74e/AX244962.1.fa
work/fc/828bcbd321b3168147279cebaec503/AX244968.1.fa
work/da/b1aed90cf6360839e38b71d1b5cb24/NM_017590.5.fa
work/20/a2b8f1d7d22b44e1a055cc4885fc12/AX244961.1.fa
work/5c/f8dd7b60e86baade67abd208893894/AF188126.1.fa
work/e1/25c1516cbaf54082bc93a4df00c233/AX244968.1.fa
work/e1/bf265afc59266334d07607dfa09652/table.csv
work/e1/bf265afc59266334d07607dfa09652/distcint.acns.txt
work/52/62f683052a1cc18c1333bcfb1cda65/AF004836.1.fa
work/c1/24d4099f4e9555eae3492fcb913252/comm.txt
work/10/dd9d1cddaad328c0374caf0fb2b899/AF188126.1.fa
work/45/7e953cfc93611b0cc0726325f4b7fe/list2.acns.txt.sorted.txt
work/45/7e953cfc93611b0cc0726325f4b7fe/list2.acns.txt
work/45/e3d943e9b671d2a9574eeade1d7f8c/comm.txt
work/7d/feafd7697737baf9fa2ab9e9e462b2/AY116592.1.fa
work/67/45ad1cb2f1968e145ce345f5bd331f/AX244964.1.fa
work/67/b106cbf1b999a074d98094b9aca8d2/AX244962.1.fa.small.fa
work/67/b106cbf1b999a074d98094b9aca8d2/AX244962.1.fa
work/67/e31ce7e11f82bab2a67102dce2c1b3/AX244961.1.fa
work/ac/1f3d1cf8a04fcf53af451f7e3caaed/AY116592.1.fa
work/ac/3a068dfec9919dd5d8ed6c6c79be3d/AF002816.1.fa
work/40/2748c0d906028c5b5c66afb7d362a6/NM_017590.5.fa
work/40/3f43d9d779d2250c4e0b6109573d29/AX244968.1.fa.small.fa
work/40/3f43d9d779d2250c4e0b6109573d29/AX244968.1.fa
work/4e/44445459a9847420dffab5d9bb48cf/comm.txt
work/4e/0477b7aa84d54b77432322a59090ad/AF002815.1.fa
work/8b/fae5e25720102e0d9c60888c2819b4/AX244966.1.fa.small.fa
work/8b/fae5e25720102e0d9c60888c2819b4/AX244966.1.fa
work/56/d4c3d4e728d83354331cbd5dd2d674/comm.txt
work/6e/db48d151a455b6ce8513a99a120394/AF002816.1.fa
work/d6/9d4941437c1baac3ce70357ee53f23/AX244962.1.fa
work/59/cf87166133349794d8a162c563c7f9/comm.txt
work/59/b5a3e857a285ed4b375cb7203abaf2/AX244965.1.fa.small.fa
work/59/b5a3e857a285ed4b375cb7203abaf2/AX244965.1.fa
work/b2/7db528d0d5b005a1a1c6b0892eca7d/AX244964.1.fa
work/b2/7db528d0d5b005a1a1c6b0892eca7d/AX244964.1.fa.small.fa
work/d7/63698a258e53c1f037dc6dad3a9a1c/list3.acns.txt
work/d7/63698a258e53c1f037dc6dad3a9a1c/list3.acns.txt.sorted.txt
work/de/87e6336b80c4eb30234f62d6e6dbd8/AX244967.1.fa
work/7a/84fc339fb20791e17ef73b652276f0/AF188530.1.fa
work/8a/31498797088d07d5275e933d0e96c8/AF002815.1.fa
work/d5/abaa19a17ac0709664354991d84557/AF002815.1.fa
work/15/87323cde2084fa81f3c3d42069df75/NM_017590.5.fa
work/15/6c7299163950b774d2525e725f3419/AX244965.1.fa
work/15/eb36d53cdb2740a22ad286f025ccf3/AF002816.1.fa
work/69/781fefc6a8702959feb10175033536/list1.acns.txt
work/69/781fefc6a8702959feb10175033536/list1.acns.txt.sorted.txt
work/57/fc07aff4863682a25908367ac8d9bb/AF004836.1.fa
work/57/5dbc43c0f3d4a7c7fb37388adce117/AX244966.1.fa
work/a4/79bfb6fa2dea26319ccdc2e16a7c79/AY116592.1.fa
work/34/48d39f7f560e5bde80b97cfb2f4780/comm.txt
work/16/70bc66f75fe2c6e052b3c88567ee9e/list2.acns.txt.sorted.txt
work/16/70bc66f75fe2c6e052b3c88567ee9e/list2.acns.txt
work/9e/911994d90fd7f0e528edb71b8bb7cc/AF002816.1.fa
work/9e/e86f31c4618a1e6152517a68ca834f/list2.acns.txt.sorted.txt
work/9e/e86f31c4618a1e6152517a68ca834f/list2.acns.txt
work/fb/099eaa41b18253c811462293fefe10/AX244963.1.fa
work/fb/099eaa41b18253c811462293fefe10/AX244963.1.fa.small.fa
work/fb/0dbe3b9a1709e9a43989c6551899fc/AY116592.1.fa
work/19/39675c804f073a828e5490f75e0d7f/AF004836.1.fa
work/be/c6ae0a9fe874bbf4dd69e01345af24/AX244965.1.fa.small.fa
work/be/c6ae0a9fe874bbf4dd69e01345af24/AX244965.1.fa
work/bd/fbed540e13bde834b67a06ba68b475/AX244966.1.fa.small.fa
work/bd/fbed540e13bde834b67a06ba68b475/AX244966.1.fa
work/01/3dd67045b17fd2402588d6d949dfb8/AX244961.1.fa
work/36/61e5c48efc64295387591b699d1c60/AX244966.1.fa
work/36/1a7648d296229d9e13946c2cc72d7a/AX244967.1.fa
work/17/cda59aa382430f5435af783bb2c6ae/NM_017590.5.fa
work/9c/368519919851c710f3f2013eeca20e/AX244963.1.fa
work/9c/368519919851c710f3f2013eeca20e/AX244963.1.fa.small.fa
work/30/87b409612cb02b44254d476ff19b4e/AF188530.1.fa
work/e3/61e634d0e1f30e42daa8dd48189dff/AX244962.1.fa
work/e3/69d52f3457a4444fb95bafb662cdbb/AY116592.1.fa
work/82/caab0636f48eeb36ee600da280ad3c/AX244967.1.fa.small.fa
work/82/caab0636f48eeb36ee600da280ad3c/AX244967.1.fa
work/f1/c183cc0e261702b4d20fde3fc48bff/list4.acns.txt
work/f1/c183cc0e261702b4d20fde3fc48bff/list4.acns.txt.sorted.txt
work/cc/f5c07ff8e586cd607c0b182fcfc389/AX244967.1.fa.small.fa
work/cc/f5c07ff8e586cd607c0b182fcfc389/AX244967.1.fa
work/49/cf0cb508c2c636ecc1f5575d1e4401/AX244965.1.fa.small.fa
work/49/cf0cb508c2c636ecc1f5575d1e4401/AX244965.1.fa
work/72/1156f767309498c2fbf28f7955a8b4/comm.txt
work/b4/118c789d7eed5791e346140ca55f33/AF188126.1.fa
work/ed/12f680c3bea66610946e50bf741eb9/AF188126.1.fa
work/75/8474ee46be58406fdbde36560063b8/AX244968.1.fa.small.fa
work/75/8474ee46be58406fdbde36560063b8/AX244968.1.fa
work/c2/4797487f0dc13f82bc9bacc486e9a8/AX244966.1.fa
work/ff/1d9cd285c6888003dec99644a5fb4d/AF004836.1.fa
work/1f/7e1a95b2ab7dc06bf830013ae7c865/AF002816.1.fa
work/26/9efb8060cf8cb931787ec4c7d88504/comm.txt
work/74/d0c7c5ae9c6e7c74c659aad3008e04/AX244963.1.fa
work/74/d0c7c5ae9c6e7c74c659aad3008e04/AX244963.1.fa.small.fa
work/aa/aa4e7d7fc5bf422c7bdcb6ea242394/AF188126.1.fa
work/c6/2b6a1ec78e3d908c283d84c3de740d/table.csv
work/c6/2b6a1ec78e3d908c283d84c3de740d/distcint.acns.txt
work/11/e20e0212e12b28459dc8e25d2afb60/AY116592.1.fa
work/5b/94a639f45b415241cc3e3047e2c320/AX244967.1.fa.small.fa
work/5b/94a639f45b415241cc3e3047e2c320/AX244967.1.fa
work/cf/2f740119b76d27c2cb34cfea49bfe7/list4.acns.txt
work/cf/2f740119b76d27c2cb34cfea49bfe7/list4.acns.txt.sorted.txt
work/a1/cbe5e55788bace18e95509d14cd88a/list3.acns.txt
work/a1/cbe5e55788bace18e95509d14cd88a/list3.acns.txt.sorted.txt
work/f3/77b69239403bbb3b2376ab42f9a251/AX244964.1.fa
work/f3/77b69239403bbb3b2376ab42f9a251/AX244964.1.fa.small.fa
work/9f/47f3906a0facf99cbdffb3be11c036/comm.txt
work/e0/a981e4346d4142db121b94b7ed72d6/AX244965.1.fa
work/ef/41fdc0f398145bf32098b5a7a1403c/AX244964.1.fa
work/02/36973533995f883db6fb2bce0f5847/comm.txt
work/02/6aa0ca8590077889df21dbadd73d6f/AX244961.1.fa
work/02/6aa0ca8590077889df21dbadd73d6f/AX244961.1.fa.small.fa
work/7c/4ca316726758b226d68e945d865f4e/AF188530.1.fa
work/42/0ba28a87046db63f5b51321b9a6b65/AX244962.1.fa.small.fa
work/42/0ba28a87046db63f5b51321b9a6b65/AX244962.1.fa
work/a6/9f774553838084a62d232b3d23a2f7/comm.txt
work/ba/b1e9960e07939cfc18c8f9ab51e1bf/AF002815.1.fa
work/a0/27d67239bcee5266f95230a4379e60/comm.txt
```


