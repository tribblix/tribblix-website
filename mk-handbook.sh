#!/bin/sh
#
# SPDX-License-Identifier: CDDL-1.0
#
# creates all the pages
#
cd content/Use || exit 1

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
# and the title header, which is pulled out of the h1 element
# in the page, dropping any instances of the word "Tribblix" as
# that's already part of the layout for the handbook pages
#
for index in "${!farray[@]}"
do
    file=${farray[$index]}
    prev=$((index-1))
    next=$((index+1))
    echo "creating ${file/.body/.html}"
    echo "---" > theader.tmp
    echo "title: $(head -1 "${file}" | cut -d' ' -f2- | cut -d'<' -f1 | sed s:Tribblix::)" >> theader.tmp
    echo "---" >> theader.tmp
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
    cat theader.tmp "${file}" tfooter.tmp  >  "${file/.body/.html}"
done
rm -f tfooter.tmp
rm -f theader.tmp
