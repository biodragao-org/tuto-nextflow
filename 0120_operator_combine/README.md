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
	tag "comm ${sorted1.getName()} and ${sorted2.getName()}"
	input:
		set acn1,sorted1,acn2,sorted2 from acn_sorted1.combine(acn_sorted2)
	output:
		set acn1,acn2,file("comm.txt")
	script:
	"""
	comm -12 "${sorted1}" "${sorted2}" > comm.txt
	"""
}
```


## Execute

```
../bin/nextflow run workflow.nf --acns '../data/list*.acns.txt'
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [infallible_cajal] - revision: 58a06a28ba
[warm up] executor > local
[93/14fcb4] Submitted process > sortAcns (sorting list4.acns.txt)
[17/afa7fb] Submitted process > sortAcns (sorting list3.acns.txt)
[1b/bdd723] Submitted process > sortAcns (sorting list1.acns.txt)
[d6/8c2d69] Submitted process > sortAcns (sorting list2.acns.txt)
[83/44f286] Submitted process > commonAcns (comm list2.acns.txt.sorted.txt and list2.acns.txt.sorted.txt)
[4a/b65f09] Submitted process > commonAcns (comm list4.acns.txt.sorted.txt and list2.acns.txt.sorted.txt)
[b4/df87c7] Submitted process > commonAcns (comm list2.acns.txt.sorted.txt and list4.acns.txt.sorted.txt)
[73/369223] Submitted process > commonAcns (comm list3.acns.txt.sorted.txt and list4.acns.txt.sorted.txt)
[08/a8a8e0] Submitted process > commonAcns (comm list3.acns.txt.sorted.txt and list2.acns.txt.sorted.txt)
[74/5f40f2] Submitted process > commonAcns (comm list4.acns.txt.sorted.txt and list3.acns.txt.sorted.txt)
[e4/e95bca] Submitted process > commonAcns (comm list2.acns.txt.sorted.txt and list3.acns.txt.sorted.txt)
[6c/4257f6] Submitted process > commonAcns (comm list4.acns.txt.sorted.txt and list4.acns.txt.sorted.txt)
[8c/aa617a] Submitted process > commonAcns (comm list1.acns.txt.sorted.txt and list4.acns.txt.sorted.txt)
[7b/230ded] Submitted process > commonAcns (comm list3.acns.txt.sorted.txt and list3.acns.txt.sorted.txt)
[26/8471d6] Submitted process > commonAcns (comm list1.acns.txt.sorted.txt and list2.acns.txt.sorted.txt)
[46/ab45a9] Submitted process > commonAcns (comm list1.acns.txt.sorted.txt and list3.acns.txt.sorted.txt)
[3b/d52a44] Submitted process > commonAcns (comm list2.acns.txt.sorted.txt and list1.acns.txt.sorted.txt)
[93/820865] Submitted process > commonAcns (comm list4.acns.txt.sorted.txt and list1.acns.txt.sorted.txt)
[15/15c6ce] Submitted process > commonAcns (comm list1.acns.txt.sorted.txt and list1.acns.txt.sorted.txt)
[bd/5221c8] Submitted process > commonAcns (comm list3.acns.txt.sorted.txt and list1.acns.txt.sorted.txt)
```


## Files

```
work/73/369223057fc7a8d66e0b088eecb72f/comm.txt
work/e4/e95bca4341437c44d4e19e982e8a21/comm.txt
work/81/a352e843a2c11e0d7df44810ebdf18/comm.txt
work/58/f8623a7b3d344867d28b96447593cd/list4.acns.txt
work/58/f8623a7b3d344867d28b96447593cd/list4.acns.txt.sorted.txt
work/1b/bdd7238a997d8409c178ce5f222c32/list1.acns.txt
work/1b/bdd7238a997d8409c178ce5f222c32/list1.acns.txt.sorted.txt
work/68/e59ef45b27f2f9093b82574aea9bc9/comm.txt
work/08/a8a8e0b5e9e6659466d9292e70932e/comm.txt
work/6c/4257f6b6408fc642b09b3af2edb93c/comm.txt
work/d3/4febaf423041b37394ae0b34790363/list2.acns.txt.sorted.txt
work/d3/4febaf423041b37394ae0b34790363/list2.acns.txt
work/3b/d52a44ec34d909929e9b2c6326b050/comm.txt
work/52/dfb183e0c8fc0de07d992ab536d8d2/comm.txt
work/80/88418ddf854465570caa89dda460c4/comm.txt
work/7d/52a6b0d9980786105455650bffc7ca/list3.acns.txt
work/7d/52a6b0d9980786105455650bffc7ca/list3.acns.txt.sorted.txt
work/46/ab45a991558ee16e04731564323623/comm.txt
work/8b/4ddc46114955cbe520227809fa7a7f/comm.txt
work/4a/b65f095403e191694a0b404fecba5c/comm.txt
work/d6/8c2d6945fb14267c57925b8286469d/list2.acns.txt.sorted.txt
work/d6/8c2d6945fb14267c57925b8286469d/list2.acns.txt
work/6d/182329abdfccd2c3219e624c35ec03/comm.txt
work/15/15c6ce153240fdc6405a601f355c7f/comm.txt
work/34/2c787dc52f175be635379f516701d0/comm.txt
work/48/73571e9f9931850a24d18e16895793/comm.txt
work/16/474aca3cef55e74478730fdb353b67/list1.acns.txt
work/16/474aca3cef55e74478730fdb353b67/list1.acns.txt.sorted.txt
work/d4/8be38a78ef8798d869e25d53a04d00/comm.txt
work/bd/5221c843eff0f5141e82f40ef8d400/comm.txt
work/17/afa7fb2fe7fdebb99927ba2f24242b/list3.acns.txt
work/17/afa7fb2fe7fdebb99927ba2f24242b/list3.acns.txt.sorted.txt
work/93/820865d8f2ddc1f10f7bc0c1b707b0/comm.txt
work/93/14fcb4d1c411109edaa166e03b97ba/list4.acns.txt
work/93/14fcb4d1c411109edaa166e03b97ba/list4.acns.txt.sorted.txt
work/b4/df87c7957b8bfa974d8a7055081c95/comm.txt
work/a7/045abbd1042848cca5cd580cbdc744/comm.txt
work/7b/4d7ea5abe83795322a13000cb867f4/comm.txt
work/7b/230deda4f1786dfa0271d790637bd6/comm.txt
work/26/8471d618ae5abd736ff6cd59c6cc29/comm.txt
work/83/2dbe40fd1c8e4a43c91d070ee1285a/comm.txt
work/83/44f28640d0a47e7e1986db8129ba34/comm.txt
work/74/5f40f2b2ba89778714da95c4ec786a/comm.txt
work/8c/aa617aa4401053238d79bc5aa2f9a8/comm.txt
work/a1/bc83c47c30fea48da90194b1a55274/comm.txt
work/0f/0144269cd844c20a2ccd8995b9ed0a/comm.txt
work/8e/86e81ba3c352af30a6de6f367ee6ec/comm.txt
work/ba/35daa10e32215c169bf0f2eefb3ffb/comm.txt
```


