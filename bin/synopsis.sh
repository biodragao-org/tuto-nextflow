#!/bin/bash

if [ -f synopsis.txt ] ; then
	echo "## Synopsis"
	echo
	cat synopsis.txt
	echo
fi


count=`find . -type f -name "*.nf"  | wc -l`

if [ $count != 0 ];
then
echo "## nextflow"

find . -type f -name "*.nf" | while read F
do

echo
echo "### ${F}"
echo
echo '```groovy'
awk '{printf("%3d   %s\n",NR,$0);}'  $F
echo '```'
echo
echo
done
fi

echo "## Execute"
echo
echo '```'
rm -rf work
make --no-print-directory  2>&1 
echo '```'
echo
echo
echo "## Files"
echo
echo '```'
find work \! -type d  | grep -v -F '.command' | grep -v -F '.exitcode'
echo '```'
echo
echo



if [ -f flowchart.png ] ; then
	echo
	echo "## Workflow"
	echo
	echo '![Workflow](flowchart.png)'
	echo
fi

if [ -f trace.tsv ] ; then
	echo
	echo "## Trace"
	echo
	echo '```'
	cat trace.tsv 
	echo '```'
	echo
	rm trace.tsv
fi


