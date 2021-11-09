Format Conversions
==================
A wide array of formats seems to have been downloaded, however, we're most interested in the overtly textual: html, doc, and pdf.

Each of these may be identified by:

 * The MIME type given in the http header
 * The file extension
 * Content heuristics

and converted using a selection of shell tools for text processing:

 * XPDF comes with [pdftotext](http://linux.die.net/man/1/pdftotext)
 * [Doc2TXT](http://doc2txt.com/)
 * HTML conversion is tricky, it'd be worth subjectively trying some out.