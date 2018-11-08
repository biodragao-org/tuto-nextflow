## Synopsis

> Process scripts can contain conditional statements by simply prefixing the script block with the keyword script:. By doing that the interpreter will evaluate all the following statements as a code block that must return the script string to be executed.

## nextflow

### ./workflow.nf

```groovy
  1   acn_file_channel = Channel.fromPath( "${params.acns}")
  2   
  3   process fetchAcn {
  4   	tag "download ${acn} using ${params.web}"
  5   	maxForks 1
  6   	input:
  7   		val acn from acn_file_channel.
  8   				splitCsv(sep:',',strip:true,limit:2).
  9   				map{ARRAY->ARRAY[0]}
 10   	output:
 11   		file("${acn}.fa") into fastas
 12   	script:
 13   	
 14   	 if( params.web == 'wget' )
 15   		"""
 16   		wget -O "${acn}.fa"   "https://www.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nucleotide&id=${acn}&rettype=fasta"
 17   		"""
 18   	else  if( params.web == 'curl' )
 19   		"""
 20   		curl -o "${acn}.fa" -f -L  "https://www.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nucleotide&id=${acn}&rettype=fasta"
 21   		"""
 22   	else
 23   		 error "Invalid alignment mode: ${params.web}"
 24   	}
 25   
```


## Execute

```
../bin/nextflow run workflow.nf --acns '../data/list1.acns.txt' --web wget
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [jolly_mahavira] - revision: cfa4a30e81
[warm up] executor > local
[8f/c83e00] Submitted process > fetchAcn (download NM_017590.5 using wget)
[38/35e945] Submitted process > fetchAcn (download LP969861.1 using wget)
../bin/nextflow run workflow.nf --acns '../data/list1.acns.txt' --web curl
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [amazing_cray] - revision: cfa4a30e81
[warm up] executor > local
[7e/ff8043] Submitted process > fetchAcn (download NM_017590.5 using curl)
[48/89adbd] Submitted process > fetchAcn (download LP969861.1 using curl)
```


## Files

```
work/38/35e94547d342d79d500157a5b4d315/LP969861.1.fa
work/48/89adbdb2a10b4b18e217dd5f751350/LP969861.1.fa
work/7e/ff8043f3221288dee510bb06684998/NM_017590.5.fa
work/8f/c83e00ca56222c5e48602d6a75da41/NM_017590.5.fa
```


