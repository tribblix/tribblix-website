This is the [Tribblix](http://www.tribblix.org/) website.

It uses [nanoc](https://nanoc.app/) as a Static Site Generator to assemble
the various page fragments.

The only slightly odd thing is the way that the overlay list is constructed
dynamically. But everything is hidden in the manage-site.sh script.

For the handbook, in content/Use, you should edit the body files. The html
files there are updated by the mk-handbook.sh script, which appends the
previous/next links at the bottom.
