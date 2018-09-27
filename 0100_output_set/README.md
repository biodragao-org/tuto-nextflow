## nextflow

### ./workflow.nf

```groovy
acn_file_channel = Channel.fromPath( "${params.acns}")

process sortAcns {
	tag "sorting ${acnFile}"
	input:
		file acnFile from acn_file_channel
	output:
		set acnFile, file("${acnFile}.sorted.txt")
	script:
	
	"""
	sort '${acnFile}' > "${acnFile}.sorted.txt"
	"""
}
```


## Execute

```
../bin/nextflow run workflow.nf --acns '../data/list*.acns.txt'
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [adoring_payne] - revision: efdcb56eb1
[warm up] executor > local
[7d/c1bd4b] Submitted process > sortAcns (sorting list4.acns.txt)
[92/c082f2] Submitted process > sortAcns (sorting list1.acns.txt)
[49/f66561] Submitted process > sortAcns (sorting list2.acns.txt)
[ca/d95bbc] Submitted process > sortAcns (sorting list3.acns.txt)
```


## Files

```
work/73/46d6c388c9380794e8f72866709d50/list2.acns.txt.sorted.txt
work/73/46d6c388c9380794e8f72866709d50/list2.acns.txt
work/38/a7e8fe43fd05071910058d05b61610/list3.acns.txt
work/38/a7e8fe43fd05071910058d05b61610/list3.acns.txt.sorted.txt
work/e8/2aed2485eecd275df57193d37fa80b/list2.acns.txt.sorted.txt
work/e8/2aed2485eecd275df57193d37fa80b/list2.acns.txt
work/e8/d67b65a3048d6edb5297ccd5d84974/list3.acns.txt
work/e8/d67b65a3048d6edb5297ccd5d84974/list3.acns.txt.sorted.txt
work/ce/bcc636f92f9734426a528195d9c440/list3.acns.txt
work/ce/bcc636f92f9734426a528195d9c440/list3.acns.txt.sorted.txt
work/1b/015f57f513a4b84a4ad80b199063b5/list2.acns.txt.sorted.txt
work/1b/015f57f513a4b84a4ad80b199063b5/list2.acns.txt
work/31/365f4d2bf95d964b211eea15cdc6c3/list1.acns.txt
work/31/365f4d2bf95d964b211eea15cdc6c3/list1.acns.txt.sorted.txt
work/5d/84d9629dcb8030df302be7686852f6/list1.acns.txt
work/5d/84d9629dcb8030df302be7686852f6/list1.acns.txt.sorted.txt
work/90/bdf6ecabab5a190238d1f73d205822/list3.acns.txt
work/90/bdf6ecabab5a190238d1f73d205822/list3.acns.txt.sorted.txt
work/fd/f124135a62e0d0c27dddee30cba467/list4.acns.txt
work/fd/f124135a62e0d0c27dddee30cba467/list4.acns.txt.sorted.txt
work/ca/d95bbcbde779ab6d20e3838c0ad31b/list3.acns.txt
work/ca/d95bbcbde779ab6d20e3838c0ad31b/list3.acns.txt.sorted.txt
work/97/d5ab078f81cec81ba3d4d4fc29feb1/list1.acns.txt
work/97/d5ab078f81cec81ba3d4d4fc29feb1/list1.acns.txt.sorted.txt
work/08/0a159d9cd12dcd8de1ee4934f9efb0/list4.acns.txt
work/08/0a159d9cd12dcd8de1ee4934f9efb0/list4.acns.txt.sorted.txt
work/14/86872cd6722efdf8e8326cb3384418/list2.acns.txt.sorted.txt
work/14/86872cd6722efdf8e8326cb3384418/list2.acns.txt
work/5f/62c6a25a9ff842425ef0e3c6cde8d7/list1.acns.txt
work/5f/62c6a25a9ff842425ef0e3c6cde8d7/list1.acns.txt.sorted.txt
work/41/50ac7d71c5e6fe3a440b84f5698072/list2.acns.txt.sorted.txt
work/41/50ac7d71c5e6fe3a440b84f5698072/list2.acns.txt
work/18/43911464649ec4aca2eae9b7e9458f/list3.acns.txt
work/18/43911464649ec4aca2eae9b7e9458f/list3.acns.txt.sorted.txt
work/b7/9a5db7c51a93292eab40f211dc90d6/list2.acns.txt.sorted.txt
work/b7/9a5db7c51a93292eab40f211dc90d6/list2.acns.txt
work/da/da41b5c6bd12b8810a59a742e8bcf5/list4.acns.txt
work/da/da41b5c6bd12b8810a59a742e8bcf5/list4.acns.txt.sorted.txt
work/7d/c1bd4b89d8b97080c14b3583fff1a4/list4.acns.txt
work/7d/c1bd4b89d8b97080c14b3583fff1a4/list4.acns.txt.sorted.txt
work/04/93326d0550fc32e599ca44450725f2/list2.acns.txt.sorted.txt
work/04/93326d0550fc32e599ca44450725f2/list2.acns.txt
work/50/d5df8c8652bb17fd53a9148b7206af/list1.acns.txt
work/50/d5df8c8652bb17fd53a9148b7206af/list1.acns.txt.sorted.txt
work/92/c082f259def0ee7f7c7c1c7a9302b4/list1.acns.txt
work/92/c082f259def0ee7f7c7c1c7a9302b4/list1.acns.txt.sorted.txt
work/21/10b54fa0b453f38b148ebed583be88/list1.acns.txt
work/21/10b54fa0b453f38b148ebed583be88/list1.acns.txt.sorted.txt
work/f7/f1607a1f7603579d32e2ce0731d898/list1.acns.txt
work/f7/f1607a1f7603579d32e2ce0731d898/list1.acns.txt.sorted.txt
work/59/b5af9acdc3c88c225ef482eec5f0bf/list2.acns.txt.sorted.txt
work/59/b5af9acdc3c88c225ef482eec5f0bf/list2.acns.txt
work/15/8395b668c96ecaddc23bb31fb27d67/list3.acns.txt
work/15/8395b668c96ecaddc23bb31fb27d67/list3.acns.txt.sorted.txt
work/0e/9b333b8410f76607d8a55a71252613/list4.acns.txt
work/0e/9b333b8410f76607d8a55a71252613/list4.acns.txt.sorted.txt
work/24/108ec6f00e5d8d69243c37f74a6436/list1.acns.txt
work/24/108ec6f00e5d8d69243c37f74a6436/list1.acns.txt.sorted.txt
work/a4/556ad8411d7e2d1c93ca3677f8922a/list4.acns.txt
work/a4/556ad8411d7e2d1c93ca3677f8922a/list4.acns.txt.sorted.txt
work/a4/2adca31b4d3704434c96110b2f9bd3/list3.acns.txt
work/a4/2adca31b4d3704434c96110b2f9bd3/list3.acns.txt.sorted.txt
work/35/0bbb60865b287e496e1488a1bbda55/list2.acns.txt.sorted.txt
work/35/0bbb60865b287e496e1488a1bbda55/list2.acns.txt
work/35/1ca5792cf60c5af6d9ff34bdd5ad1f/list1.acns.txt
work/35/1ca5792cf60c5af6d9ff34bdd5ad1f/list1.acns.txt.sorted.txt
work/48/602920a3e3bf975a602a6bdcc1b066/list4.acns.txt
work/48/602920a3e3bf975a602a6bdcc1b066/list4.acns.txt.sorted.txt
work/2b/e50f2ad08cca345258558eafd080b9/list3.acns.txt
work/2b/e50f2ad08cca345258558eafd080b9/list3.acns.txt.sorted.txt
work/9d/aaff42b626789e8102db916305f464/list2.acns.txt.sorted.txt
work/9d/aaff42b626789e8102db916305f464/list2.acns.txt
work/fb/e7342d6650d4e2635bc9d3766d8393/list3.acns.txt
work/fb/e7342d6650d4e2635bc9d3766d8393/list3.acns.txt.sorted.txt
work/2e/aaea2b2f8a21415d1157723cc1a2f2/list4.acns.txt
work/2e/aaea2b2f8a21415d1157723cc1a2f2/list4.acns.txt.sorted.txt
work/a2/dee94732f7510946a1eecfb217a88a/list1.acns.txt
work/a2/dee94732f7510946a1eecfb217a88a/list1.acns.txt.sorted.txt
work/55/4f2fdc2ca925296592d42048340cfa/list2.acns.txt.sorted.txt
work/55/4f2fdc2ca925296592d42048340cfa/list2.acns.txt
work/e3/df77a7122bee07c7bb1259228cb5a6/list4.acns.txt
work/e3/df77a7122bee07c7bb1259228cb5a6/list4.acns.txt.sorted.txt
work/e3/91e76da84781e2e92c3a861770c5c8/list3.acns.txt
work/e3/91e76da84781e2e92c3a861770c5c8/list3.acns.txt.sorted.txt
work/49/f66561d1ba562006c973ee6369f853/list2.acns.txt.sorted.txt
work/49/f66561d1ba562006c973ee6369f853/list2.acns.txt
work/26/447c8d435a7a5b69ed7967e1fdce81/list4.acns.txt
work/26/447c8d435a7a5b69ed7967e1fdce81/list4.acns.txt.sorted.txt
work/8c/35fcffc6c67e6dd786871546526972/list4.acns.txt
work/8c/35fcffc6c67e6dd786871546526972/list4.acns.txt.sorted.txt
work/05/efbc746e661bfde832209599e2cf5b/list1.acns.txt
work/05/efbc746e661bfde832209599e2cf5b/list1.acns.txt.sorted.txt
work/8e/57bac933a450a6483481906c14efd8/list4.acns.txt
work/8e/57bac933a450a6483481906c14efd8/list4.acns.txt.sorted.txt
work/a6/25210c93fbe7e147ecde07363920cd/list3.acns.txt
work/a6/25210c93fbe7e147ecde07363920cd/list3.acns.txt.sorted.txt
```


