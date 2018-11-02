acn_file_channel = Channel.fromPath( "${params.acns}")

/** copy acn_file_channel : https://www.nextflow.io/docs/latest/faq.html How do I use the same channel multiple times?  */
acn_file_channel.into { copy1 ; copy2}

process Accession_from_A_to_M {
	tag "${acn} From A to M"
	maxForks 1
	input:
		val acn from copy1.
				splitCsv(sep:',',strip:true).
				map{ARRAY->ARRAY[0]}
	output:
		file("${acn}.am.txt") into A_TO_M
	
	when:
		acn =~ /^[A-M]/
	
	script:
	 
	"""
	echo "${acn}" > "${acn}.am.txt"
	"""
	}

process Accession_from_N_to_Z {
	tag "${acn} From N to Z"
	maxForks 1
	input:
		val acn from copy2.
				splitCsv(sep:',',strip:true).
				map{ARRAY->ARRAY[0]}
	output:
		file("${acn}.nz.txt") into N_TO_Z
	
	when:
		acn =~ /^[N-Z]/
	
	script:
	 
	"""
	echo "${acn}" > "${acn}.nz.txt"
	"""
	}

