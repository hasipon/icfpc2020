#!/bin/bash


cd $(dirname $0)


function run () {
  rm tmp
	java -jar ../bin/Main.jar < $1 > tmp 2> /dev/null
}

for file in `ls ../../../problems/*.in`; do
  run $file
  base=`basename $file .in`
	dir=`dirname $file`
	res=`diff tmp $dir/$base.out`

	echo "========================="
	echo "$base"
	if [ "$res" = "" ]; then
	  echo "PASS"
  else
	  echo "FAIL"
		echo "YOU"
	  diff -y tmp $dir/$base.out
	fi
done
echo "========================="
