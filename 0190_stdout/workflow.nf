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

process commonAcns {
	tag "comm ${label}"
	input:
		set label,sorted1,sorted2 from acn_sorted1.
                                          combine(acn_sorted2).
                                          filter{ROW->ROW[0].getName().compareTo(ROW[2].getName())<0}.
					  map{ROW->[ ROW[0].getName() + " vs " + ROW[2].getName() , ROW[1] , ROW[3] ] }
	output:
		set label,file("comm.txt") into commons
	script:
	"""
	comm -12 "${sorted1}" "${sorted2}" > comm.txt
	"""
}

process listCommons {
	tag "common list size: ${array_of_rows.size()}"
	input:
		val array_of_rows from commons.map{ROW->ROW[0]+","+ROW[1]}.collect()
	output:
		file("table.csv")
		file("distcint.acns.txt") into distinct_acns
	script:
	"""
	echo '${array_of_rows.join("\n")}' > table.csv
	cut -d ',' -f2 table.csv | while read F
	do
		cat \$F
	done | sort | uniq > distcint.acns.txt
	"""

}

// https://www.nextflow.io/docs/latest/process.html?highlight=maxfork#maxforks
process eachAcn {
	tag "dowloading ${acn}"
	maxForks 1
	input:	
		val acn from distinct_acns.splitCsv(sep:',',strip:true).map{ARRAY->ARRAY[0]}
	output:
		file("${acn}.fa") into fastas
	script:
	"""
	curl -o "${acn}.fa" "https://www.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nucleotide&id=${acn}&rettype=fasta"
	"""
	}

process filterSize {
	tag "size for ${fasta}"

	input:
		file fasta from fastas
	output:
		file("${fasta}.small.fa") optional true into (smallfastas1,smallfastas2)
	script:

	"""
	if [ `grep -v ">" ${fasta} | tr -d '\\n ' | wc -c` -lt 100 ]; then
		cp "${fasta}"  "${fasta}.small.fa"
	fi
	"""
	}

process pairwise_align {
	tag "pairwise ${fasta1} vs ${fasta2}"
	maxForks 1
	input:
		set fasta1,fasta2 from smallfastas1.
		          combine(smallfastas2).
		          filter{ROW->ROW[0].getName().compareTo(ROW[1].getName())<0}.
			  take(2)
			  
	output:
		stdout scores
	script:
	"""
	SEQ1=`grep -v ">" "${fasta1}" | tr -d "\n"`
	SEQ2=`grep -v ">" "${fasta2}" | tr -d "\n"`
	
	echo -n "${fasta1},${fasta2},"

	curl 'https://embnet.vital-it.ch/cgi-bin/LALIGN_form_parser' \
		-H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:62.0) Gecko/20100101 Firefox/62.0' \
		-H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' -H 'Accept-Language: en-US,en;q=0.5' \
		--compressed \
		-H 'Referer: https://embnet.vital-it.ch/software/LALIGN_form.html' \
		-H 'Content-Type: application/x-www-form-urlencoded' \
		-H 'DNT: 1' \
		-H 'Connection: keep-alive' \
		-H 'Upgrade-Insecure-Requests: 1' \
		--data "method=global&no=1&evalue=10.0&matrix=dna&open=-12&exten=-2&comm1=seq1&format1=plain_text&seq1=\${SEQ1}&comm2=seq2&format2=plain_text&seq2=\${SEQ2}" |\
	xmllint --html --format --xpath '//pre[1]/text()' - |\
		grep -F 'Z-score:' -m1 | cut -d ':' -f 5 | tr -d ' '
	"""
	}

scores.subscribe { print "I say..  $it" }
