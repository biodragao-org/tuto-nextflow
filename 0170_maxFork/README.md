## Synopsis

> The maxForks directive allows you to define the maximum number of process instances that can be executed in parallel.

## nextflow

### ./workflow.nf

```groovy
  1   acn_file_channel = Channel.fromPath( "${params.acns}")
  2   
  3   process sortAcns {
  4   	tag "sorting ${acnFile}"
  5   	input:
  6   		file acnFile from acn_file_channel
  7   	output:
  8   		set acnFile, file("${acnFile}.sorted.txt") into (acn_sorted1,acn_sorted2)
  9   	script:
 10   	
 11   	"""
 12   	sort '${acnFile}' > "${acnFile}.sorted.txt"
 13   	"""
 14   }
 15   
 16   process commonAcns {
 17   	tag "comm ${label}"
 18   	input:
 19   		set label,sorted1,sorted2 from acn_sorted1.
 20                                             combine(acn_sorted2).
 21                                             filter{ROW->ROW[0].getName().compareTo(ROW[2].getName())<0}.
 22   					  map{ROW->[ ROW[0].getName() + " vs " + ROW[2].getName() , ROW[1] , ROW[3] ] }
 23   	output:
 24   		set label,file("comm.txt") into commons
 25   	script:
 26   	"""
 27   	comm -12 "${sorted1}" "${sorted2}" > comm.txt
 28   	"""
 29   }
 30   
 31   process listCommons {
 32   	tag "common list size: ${array_of_rows.size()}"
 33   	input:
 34   		val array_of_rows from commons.map{ROW->ROW[0]+","+ROW[1]}.collect()
 35   	output:
 36   		file("table.csv")
 37   		file("distinct.acns.txt") into distinct_acns
 38   	script:
 39   	"""
 40   	echo '${array_of_rows.join("\n")}' > table.csv
 41   	cut -d ',' -f2 table.csv | while read F
 42   	do
 43   		cat \$F
 44   	done | sort | uniq > distinct.acns.txt
 45   	"""
 46   
 47   }
 48   
 49   // https://www.nextflow.io/docs/latest/process.html?highlight=maxfork#maxforks
 50   process eachAcn {
 51   	tag "dowloading ${acn}"
 52   	maxForks 1
 53   	input:	
 54   		val acn from distinct_acns.splitCsv(sep:',',strip:true).map{ARRAY->ARRAY[0]}
 55   	output:
 56   		file("${acn}.fa")
 57   	script:
 58   	"""
 59   	../bin/ncbicurl ${acn} > "${acn}.fa"
 60   	"""
 61   	}
 62   
```


## Execute

```
../bin/nextflow run  workflow.nf --acns '../data/list*.acns.txt'
N E X T F L O W  ~  version 0.31.1
Launching `workflow.nf` [extravagant_brahmagupta] - revision: e51b9730ab
[warm up] executor > local
[ad/00885e] Submitted process > sortAcns (sorting list3.acns.txt)
[d3/1e2f41] Submitted process > sortAcns (sorting list4.acns.txt)
[0d/e5c880] Submitted process > sortAcns (sorting list2.acns.txt)
[79/34dd32] Submitted process > sortAcns (sorting list1.acns.txt)
[86/2e6ea2] Submitted process > commonAcns (comm list3.acns.txt vs list4.acns.txt)
[d2/58c421] Submitted process > commonAcns (comm list2.acns.txt vs list3.acns.txt)
[80/2460dd] Submitted process > commonAcns (comm list2.acns.txt vs list4.acns.txt)
[7c/ac605b] Submitted process > commonAcns (comm list1.acns.txt vs list3.acns.txt)
[f2/53e3cf] Submitted process > commonAcns (comm list1.acns.txt vs list2.acns.txt)
[0d/80785e] Submitted process > commonAcns (comm list1.acns.txt vs list4.acns.txt)
[62/39f777] Submitted process > listCommons (common list size: 6)
[d6/e2a4df] Submitted process > eachAcn (dowloading AF002815.1)
ERROR ~ Error executing process > 'eachAcn (dowloading AF002815.1)'

Caused by:
  Process `eachAcn (dowloading AF002815.1)` terminated with an error exit status (1)

Command executed:

  ../bin/ncbicurl AF002815.1 > "AF002815.1.fa"

Command exit status:
  1

Command output:
  (empty)

Command error:
  .command.sh: line 2: ../bin/ncbicurl: No such file or directory

Work dir:
  /home/lindenb/src/tuto-nextflow/0170_maxFork/work/d6/e2a4dfca78aa4ca83cc409de0941b5

Tip: you can try to figure out what's wrong by changing to the process work dir and showing the script file named `.command.sh`

 -- Check '.nextflow.log' file for details
[1e/b88566] Submitted process > eachAcn (dowloading AF002816.1)
WARN: Killing pending tasks (1)
Makefile:4: recipe for target 'all' failed
make[1]: *** [all] Error 1
```


## Files

```
work/0d/80785e12ac2deb489f1639169df12f/comm.txt
work/0d/e5c8808af0d1d4babe3dd0a034df70/list2.acns.txt.sorted.txt
work/0d/e5c8808af0d1d4babe3dd0a034df70/list2.acns.txt
work/1e/b88566959dcd4e014626878b8e93d7/AF002816.1.fa
work/f2/53e3cfec7c49b552337d91e1d5124a/comm.txt
work/d2/58c4217e3c4d60ecfa2c2559bcff2b/comm.txt
work/62/39f7774951fc5b48fe92cef82120c6/distinct.acns.txt
work/62/39f7774951fc5b48fe92cef82120c6/table.csv
work/d3/1e2f4178665e3a77443d7287cb43fe/list4.acns.txt.sorted.txt
work/d3/1e2f4178665e3a77443d7287cb43fe/list4.acns.txt
work/7c/ac605bd9bfcbf342283fe84baa48e2/comm.txt
work/79/34dd320578f7437f99ae1bf5d93104/list1.acns.txt.sorted.txt
work/79/34dd320578f7437f99ae1bf5d93104/list1.acns.txt
work/d6/e2a4dfca78aa4ca83cc409de0941b5/AF002815.1.fa
work/80/2460dd05da7f206a86204fd7cc7326/comm.txt
work/ad/00885edf6ee43ca170d2126c81458c/list3.acns.txt
work/ad/00885edf6ee43ca170d2126c81458c/list3.acns.txt.sorted.txt
work/86/2e6ea2db65c2e4faf6eee810e53724/comm.txt
```


