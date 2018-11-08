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
		wget -O "${acn}.fa" "https://www.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nucleotide&id=${acn}&rettype=fasta"
		"""
	else  if( params.web == 'curl' )
		"""
		curl -o "${acn}.fa" -f -L  "https://www.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nucleotide&id=${acn}&rettype=fasta"
		"""
	else
		 error "Invalid alignment mode: ${params.web}"
	}

