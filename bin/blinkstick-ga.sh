y=0
nc -vv -k -w 3 -l 8080 | 
egrep -o --line-buffered "GET /[0-9]+" | 
egrep -o --line-buffered "[0-9]+" | 
while read x
  do 
    if [ $x -gt $y ]
    then blinkstick --set-color=red --pulse
    fi
    y=$x
  done