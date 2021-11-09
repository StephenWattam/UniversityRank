Data Format
===========
The data format should be basic, utf-8, CSV.  List fields in here as they become apparent:

 * word --- The word, non-normalised and raw, as segmented from a text source
 * uni --- The university for which this word counts
 * freq --- The number of times this word has been seen on that text source
 * uni_total --- The number of words in the source, total (N_uni)
 * llik --- The log likelihood compared to a given corpus [which?]
 * word_dcase --- A lowercase form of the word
 * word_stem --- A stemmed form of the word, lowercase