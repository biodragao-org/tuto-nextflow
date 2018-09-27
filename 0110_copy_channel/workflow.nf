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

// https://www.nextflow.io/docs/latest/operator.html#view

acn_sorted1.view{F->"CHANNEL 1 : "+F}

acn_sorted2.view{F->"CHANNEL 2 : "+F}
