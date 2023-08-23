#!/bin/sh
#
# creates all the pages
#
cd content/Use

#
# the assumption here is that the page names sort into the right order
# this array is used for previous and next
#
set -A farray ?.*.body

#
# the index doesn't have the extra footer
#
cp index.body index.html

#
# now loop through all the body files, creating the forward/back
# links at the bottom
#
for index in "${!farray[@]}"
do
    file=${farray[$index]}
    prev=$((index-1))
    next=$((index+1))
    echo creating ${file/.body/.html}
    echo "<hr>" > tfooter.tmp
    echo "<p><a href=\"./\">Index</a>" >> tfooter.tmp
    if [ "$prev" -gt -1 ]; then
	#echo prev is ${farray[$prev]}
	turl=${farray[$prev]}
	turl=${turl/.body/.html}
	echo " | <a href=\"$turl\">Previous Section</a>" >> tfooter.tmp
    fi
    if [ "$next" -lt ${#farray[*]} ]; then
	#echo next is ${farray[$next]}
	turl=${farray[$next]}
	turl=${turl/.body/.html}
	echo " | <a href=\"$turl\">Next Section</a>" >> tfooter.tmp
    fi
    echo "</p>" >> tfooter.tmp
    cat ${file} tfooter.tmp  >  ${file/.body/.html}
done
rm -f tfooter.tmp
