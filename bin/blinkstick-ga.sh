#!/bin/bash

if [ "x$1" = "x-h" ]
  then echo "$0 <port optional (8080)> <colors optional (red,green,blue)> <granularity optional (10)>"
  echo "    Every power of the granularity the color changes, e.g. by default 0-9 visitors is red, 10-99 is 100 and 100+ is green"
  echo "    Beware the command line arguments!!!"
  exit -1
fi

if [ "x$1" = "x" ]
  then port=8080
else port=$1
fi
if [ "x$2" = "x" ]
  then colors="red,green,blue"
else
  colors=$2
fi
if [ "x$3" = "x" ]
  then granularity=10
else
  granularity=$3
fi

lastValue=0 #loop variable
nc -vv -k -w 3 -l $port | #read from port
egrep -o --line-buffered "GET /[0-9]+" | #strip number
egrep -o --line-buffered "[0-9]+" | 
while read currentValue #foreach number
  do 
    if [ $currentValue -gt $lastValue ] #if changed
    then echo ""; echo $currentValue #flash blinkstick
      color=`echo $currentValue | pawk -B "colors=\"$colors\".split(\",\")" "colors[int(math.log(int(f[0]),$granularity))] if int(math.log(int(f[0]),$granularity)) < len(colors) else colors[-1]"`
      blinkstick --set-color=$color --pulse > /dev/null
      lastValue=$currentValue
    fi
    echo -n .
  done