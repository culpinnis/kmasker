#cMasker

cMasker is a experimental, but stable fork of kmasker. Kmaskers core functionality (make_occ, normalize occ, apply occ) was rewritten into c++. cMasker is faster and more memory efficent than kmaskers perl scripts, but future features (*like reverse masking*) are not still implemented (*or/and will not be backported*). You can use cMasker if you just need the core functionality. 

#Features
cMasker can output a (normalized) occ file for you if wanted. Otherwise it will just mask your fasta or fastq file with the provided parameters and the jellyfish index.

#How to use

cMasker has the following parameters:

* -f Fasta input file (fastq should work, too)
* -j Jellyfish index .jf
* -n Your sequencing depth (if the index was build out of reads), default 1 (no normalization)
* -r Repeat threshould for masking. Any kmers with higher count than this value will be masked in your fasta file.
* -o Write occ file which can be used with kmaskers additional postprocessing scripts.

#Output

cMasker will create a freakmaskedRT(Value).prefix file for you, which is in fasta format.
With -o it will also create an occ file called prefix_normalized.occ - it is also called normalized if the -n parameter is 1.

#Installation

Please check kmaskers wiki for instructions how to compile. It is build like the make_occ component of kmasker. 

https://github.com/tschmutzer/kmasker/wiki/03-Library-Documentation

#More Informations

You can find more informations on this topic at kmaskers GitHub page.

https://github.com/tschmutzer/kmasker


