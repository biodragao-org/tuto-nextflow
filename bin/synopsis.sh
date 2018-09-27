#!/bin/bash

if [ -f synopsis.txt ] ; then
	echo "## Synopsis"
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
cat $F
echo '```'
echo
echo
done
fi

echo "## Execute"
echo
echo '```'
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
