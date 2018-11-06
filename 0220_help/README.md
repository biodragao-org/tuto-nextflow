## Synopsis
aide en ligne pour un workflow.

## nextflow

### ./workflow.nf

```groovy
acn_file_channel = Channel.fromPath( "${params.acns}")


def helpMessage() {
    log.info"""
    =========================================
    This is the help message
    =========================================
  
    Options:
      --web    method to fetch from NCBI. 'wget' or 'curl'
    """.stripIndent()
}

/*
 * SET UP CONFIGURATION VARIABLES
 */

// Show help message
if (params.help){
    helpMessage()
    exit 0
}

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
		../bin/ncbiwget "${acn}" > "${acn}.fa" 
		"""
	else  if( params.web == 'curl' )
		"""
		../bin/ncbicurl "${acn}" > "${acn}.fa" 
		"""
	else
		 error "Invalid alignment mode: ${params.web}"
	}

```


## Execute

```
../bin/nextflow run workflow.nf --help
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [kickass_mccarthy] - revision: 46b3f52ced
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


