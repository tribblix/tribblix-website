#!/bin/sh
#
# SPDX-License-Identifier: CDDL-1.0
#
# Copyright 2025 Peter Tribble
#
# manage the tribblix website content
#

THOME=${THOME:-/packages/localsrc/Tribblix}
NANOC="/usr/versions/ruby-3/bin/nanoc"

if [ ! -x "${NANOC}" ]; then
    echo "ERROR: nanoc isn't installed"
    echo "On tribblix, as root:"
    echo "zap install TRIBv-ruby-3 TRIBwebrick-ruby-3 TRIBnanoc-ruby-3 TRIBadsf-ruby-3 TRIBnokogiri-ruby-3 TRIBw3cvalidators-ruby-3"
    exit 1
fi

if [ ! -d "${THOME}/overlays" ]; then
    echo "ERROR: overlays not found"
    echo "You need to check out https://github.com/tribblix/overlays into $THOME"
    exit 1
fi

usage() {
    echo "Usage: $0 update|view|check|spell"
    exit 1
}

case $# in
    0)
	usage
	;;
esac

#
# restrict checks to css, internal_links, stale, mixed_content
# the external_links and html checks will probably fail to run
# and external_links fetches the content of every link, which
# includes the iso images
#
# ilinks check disabled as the Manual is external and thus fails
#
case $1 in
    update)
	./mk-overlays.sh > content/overlays.html
	./mk-handbook.sh
	./mk-changes.sh
	$NANOC
	;;
    view)
	$NANOC view
	;;
    check)
	shift
	$NANOC check css stale mixed_content
	;;
    spell)
	shift
	if [ -x /usr/bin/codespell ]; then
	    /usr/bin/codespell -L ede,oclock,nce content layouts
	else
	    echo "ERROR: codespell not installed"
	    exit 1
	fi
	;;
    pmd)
	shift
	if [ -x /usr/bin/pmd ]; then
	    /usr/bin/pmd check -R category/html/bestpractices.xml -d $(find output -name '*.html') 2>/dev/null
	else
	    echo "ERROR: pmd not installed"
	    exit 1
	fi
	;;
    *)
	usage
	;;
esac
