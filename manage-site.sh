#!/bin/sh
#
# manage the tribblix website content
#

THOME=${THOME:-/packages/localsrc/Tribblix}
NANOC="/usr/versions/ruby-3/bin/nanoc"

if [ ! -x "${NANOC}" ]; then
    echo "ERROR: nanoc isn't installed"
    echo "On tribblix, as root:"
    echo "zap install TRIBv-ruby-3 TRIBwebrick-ruby-3 TRIBnanoc-ruby-3 TRIBadsf-ruby-3"
    exit 1
fi

if [ ! -d "${THOME}/overlays" ]; then
    echo "ERROR: overlays not found"
    echo "You need to check out https://github.com/tribblix/overlays into $THOME"
    exit 1
fi

usage() {
    echo "Usage: $0 update|view"
    exit 1
}

case $# in
    0)
	usage
	;;
esac

case $1 in
    update)
	./mk-overlays.sh > content/overlays.html
	$NANOC
	;;
    view)
	$NANOC view
	;;
    *)
	usage
	;;
esac
