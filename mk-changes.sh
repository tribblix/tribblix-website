#!/bin/sh
#
# SPDX-License-Identifier: CDDL-1.0
#
# creates all the change list pages
#
cd content/Changes || exit 1

for file in *.body
do
    nfile=${file%.body}
    rev=${nfile##*-}
    echo "---" > "${nfile}.html"
    echo "title: ${rev} changes" >> "${nfile}.html"
    echo "---" >> "${nfile}.html"
    case $rev in
	0*)
	    echo "<h1>Changes in ${rev} prerelease</h1>" >> "${nfile}.html"
	    ;;
	*)
	    echo "<h1>Changes in release ${rev}</h1>" >> "${nfile}.html"
	    ;;
    esac
    echo "<p>" >> "${nfile}.html"
    cat "${file}" | sed 's:^$:</p><p>:' >> "${nfile}.html"
    echo "</p>" >> "${nfile}.html"
done

#
# now create an index
#
# the sort here assumes specific filenames, m as the field separator
# picks out the milestone part of the name for the numeric sort,
# ensuring it correctly parses as a number
#
echo "---" > index.html
echo "title: Changes by release" >> index.html
echo "---" >> index.html
echo "<h1>Changes by release</h1>" >> index.html
echo "<ul>" >> index.html
ls -1 *body | sort -t m -k 2 -nr | while read -r file
do
    nfile=${file%.body}
    hfile=${nfile}.html
    rev=${nfile##*-}
    case $rev in
	0*)
	    echo "<li><a href=\"${hfile}\">Changes in ${rev} prerelease</a></li>" >> index.html
	    ;;
	*)
	    echo "<li><a href=\"${hfile}\">Changes in release ${rev}</a></li>" >> index.html
	    ;;
    esac
done
echo "</ul>" >> index.html
