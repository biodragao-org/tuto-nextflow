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
 16   		../bin/ncbiwget "${acn}" > "${acn}.fa" 
 17   		"""
 18   	else  if( params.web == 'curl' )
 19   		"""
 20   		../bin/ncbicurl "${acn}" > "${acn}.fa" 
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
Launching `workflow.nf` [big_spence] - revision: 97626d9205
[warm up] executor > local
[a5/696294] Submitted process > fetchAcn (download NM_017590.5 using wget)
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
  /home/lindenb/src/tuto-nextflow/0200_conditional/work/a5/696294fa13fd5d6905c3314dedb846

Tip: view the complete command output by changing to the process work dir and entering the command `cat .command.out`

 -- Check '.nextflow.log' file for details
[55/4b43ae] Submitted process > fetchAcn (download LP969861.1 using wget)
WARN: Killing pending tasks (1)
Makefile:4: recipe for target 'all' failed
make[1]: *** [all] Error 1
```


## Files

```
work/55/4b43ae188a68876305968768bb7cc6/LP969861.1.fa
work/a5/696294fa13fd5d6905c3314dedb846/NM_017590.5.fa
```


