## Synopsis

aide en ligne pour un workflow.

## nextflow

### ./workflow.nf

```groovy
  1   acn_file_channel = Channel.fromPath( "${params.acns}")
  2   
  3   
  4   def helpMessage() {
  5       log.info"""
  6       =========================================
  7       This is the help message
  8       =========================================
  9     
 10       Options:
 11         --web    method to fetch from NCBI. 'wget' or 'curl'
 12       """.stripIndent()
 13   }
 14   
 15   /*
 16    * SET UP CONFIGURATION VARIABLES
 17    */
 18   
 19   // Show help message
 20   if (params.help){
 21       helpMessage()
 22       exit 0
 23   }
 24   
 25   process fetchAcn {
 26   	tag "download ${acn} using ${params.web}"
 27   	maxForks 1
 28   	input:
 29   		val acn from acn_file_channel.
 30   				splitCsv(sep:',',strip:true,limit:2).
 31   				map{ARRAY->ARRAY[0]}
 32   	output:
 33   		file("${acn}.fa") into fastas
 34   	script:
 35   	
 36   	 if( params.web == 'wget' )
 37   		"""
 38   		../bin/ncbiwget "${acn}" > "${acn}.fa" 
 39   		"""
 40   	else  if( params.web == 'curl' )
 41   		"""
 42   		../bin/ncbicurl "${acn}" > "${acn}.fa" 
 43   		"""
 44   	else
 45   		 error "Invalid alignment mode: ${params.web}"
 46   	}
 47   
```


## Execute

```
../bin/nextflow run workflow.nf --help
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [wise_volta] - revision: 46b3f52ced
WARN: Access to undefined parameter `acns` -- Initialise it to a default value eg. `params.acns = some_value`

=========================================
This is the help message
=========================================

Options:
  --web    method to fetch from NCBI. 'wget' or 'curl'

```


## Files

```
```


