## nextflow

### ./workflow.nf

```groovy
acn_file_channel = Channel.fromPath( "${params.acns}")

process fetchAcn {
	tag "download ${acn} using ${params.web}"
	maxForks 1
	input:
		val acn from acn_file_channel.
				splitCsv(sep:',',strip:true,limit:2).
				map{ARRAY->ARRAY[0]}
	output:
		file("${acn}.fa") into fastas
	script:
	
	 if( params.web == 'wget' )
		"""
		wget -O "${acn}.fa" "https://www.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nucleotide&id=${acn}&rettype=fasta"
		"""
	else  if( params.web == 'curl' )
		"""
		curl -o "${acn}.fa" "https://www.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nucleotide&id=${acn}&rettype=fasta"
		"""
	else
		 error "Invalid alignment mode: ${params.web}"
	}

```


## Execute

```
../bin/nextflow run workflow.nf --acns '../data/list1.acns.txt' --web wget
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [serene_raman] - revision: 1d5587e209
[warm up] executor > local
[c1/6d49dc] Submitted process > fetchAcn (download NM_017590.5 using wget)
[a5/7f4d74] Submitted process > fetchAcn (download LP969861.1 using wget)
../bin/nextflow run workflow.nf --acns '../data/list1.acns.txt' --web curl
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [kickass_wiles] - revision: 1d5587e209
[warm up] executor > local
[f7/b778ec] Submitted process > fetchAcn (download NM_017590.5 using curl)
[4a/b05aaa] Submitted process > fetchAcn (download LP969861.1 using curl)
```


## Files

```
work/c1/6d49dca4b65063fcc0aea2e96af826/NM_017590.5.fa
work/4a/b05aaa7a8a503e7a66b17ab2365c49/LP969861.1.fa
work/f7/b778ec7c190327be1cefecdfadc8d6/NM_017590.5.fa
work/a5/7f4d74ad789bfa2424c1487f3cb3e7/LP969861.1.fa
```


