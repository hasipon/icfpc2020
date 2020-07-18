#!/bin/bash


cd $(dirname $0)


function run () {
  rm testscript_result
	TEST=test python a.py < $1 > testscript_result
}

for file in `ls problems/*.in`; do
  run $file
  base=`basename $file .in`
	dir=`dirname $file`
	res=`diff testscript_result $dir/$base.out`

	echo "========================="
	echo "$base"
	if [ "$res" = "" ]; then
	  echo "PASS"
  else
	  echo "FAIL"
		echo "YOU"
	  diff -y testscript_result $dir/$base.out
	fi
done
echo "========================="
