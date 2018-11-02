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
Launching `workflow.nf` [sleepy_lamarr] - revision: 1d5587e209
[warm up] executor > local
[d2/900123] Submitted process > fetchAcn (download NM_017590.5 using wget)
[af/4b5db0] Submitted process > fetchAcn (download LP969861.1 using wget)
../bin/nextflow run workflow.nf --acns '../data/list1.acns.txt' --web curl
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [adoring_feynman] - revision: 1d5587e209
[warm up] executor > local
[dd/093a13] Submitted process > fetchAcn (download NM_017590.5 using curl)
[f9/3584b1] Submitted process > fetchAcn (download LP969861.1 using curl)
```


## Files

```
work/af/4b5db054ff978b26d24d690fc7b6c7/LP969861.1.fa
work/f9/3584b1dff4d70065af465e10f8c0b0/LP969861.1.fa
work/d2/900123686d1aaebb6f4f287f37f02c/NM_017590.5.fa
work/dd/093a132239c1d3289cfb333916e88a/NM_017590.5.fa
```


