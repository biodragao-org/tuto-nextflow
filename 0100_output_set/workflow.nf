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
