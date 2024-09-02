#!/bin/sh
#
# SPDX-License-Identifier: CDDL-1.0
#
# just creates the list in the middle
# redirect to overlays.html
#
# FIXME: mark as available for sparc and/or x86
#

cd content || exit 1

cat <<EOF
---
title: Software Overlays
---
<h1>&gt; Software overlays</h1>

<p>
The following overlays are available for installation, using the
<a href="zap.html">zap</a> utility. Those marked with [*] can be
directly installed from the downloaded ISO without needing to
contact the online repository.
</p>

<ul>
EOF

THOME=${THOME:-/packages/localsrc/Tribblix}

for file in ${THOME}/overlays/*.ovl
do
    ovl=${file%.ovl}
    ovl=${ovl##*/}
    if grep -q "^$ovl$" "${THOME}/overlays/overlays.iso"
    then
	isostat=" [*]"
    else
	isostat=""
    fi
    ONAME=$(awk -F= '{if ($1=="NAME") print $2}' "$file")
    #
    # if an ovl file exists we link to it
    # regenerate the h1 header to match the actual Overlay metadata
    #
    if [ -f "${ovl}.ovl" ]; then
	cat > "tmp-${ovl}.body" <<_EOF
---
title: $ovl overlay
---
_EOF
	echo "<h1>Overlay $ovl - $ONAME</h1>" >> "tmp-${ovl}.body"
	grep -v -e '<h1>' -e '^---' -e '^title:' "${ovl}.ovl" >> "tmp-${ovl}.body"
	mv "tmp-${ovl}.body" "${ovl}.ovl"
	echo "<li><a href=\"overlay-${ovl}.html\">${ovl}</a> - ${ONAME}${isostat}</li>"
    else
	echo "<li>${ovl} - ${ONAME}${isostat}</li>"
    fi
done
echo "</ul>"
