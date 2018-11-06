## Synopsis
> Process scripts can contain conditional statements by simply prefixing the script block with the keyword script:. By doing that the interpreter will evaluate all the following statements as a code block that must return the script string to be executed.

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
../bin/nextflow run workflow.nf --acns '../data/list1.acns.txt' --web wget
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [festering_sanger] - revision: 97626d9205
[warm up] executor > local
[a2/cb5fd2] Submitted process > fetchAcn (download NM_017590.5 using wget)
ERROR ~ Error executing process > 'fetchAcn (download NM_017590.5 using wget)'

Caused by:
  Process `fetchAcn (download NM_017590.5 using wget)` terminated with an error exit status (1)

Command executed:

  ../bin/ncbiwget "NM_017590.5" > "NM_017590.5.fa"

Command exit status:
  1

Command output:
  (empty)

Command error:
  .command.sh: line 2: ../bin/ncbiwget: No such file or directory

Work dir:
  /home/lindenb/src/tuto-nextflow/0200_conditional/work/a2/cb5fd2bb887398c0bc84708f21dec2

Tip: when you have fixed the problem you can continue the execution appending to the nextflow command line the option `-resume`

 -- Check '.nextflow.log' file for details
[a6/f0e51b] Submitted process > fetchAcn (download LP969861.1 using wget)
WARN: Killing pending tasks (1)
Makefile:4: recipe for target 'all' failed
make[1]: *** [all] Error 1
```


## Files

```
work/a2/cb5fd2bb887398c0bc84708f21dec2/NM_017590.5.fa
work/a6/f0e51bdd67681e3ab8bb8ee91deffb/LP969861.1.fa
```


