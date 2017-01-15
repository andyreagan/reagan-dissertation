#!/bin/bash

mkdir -p package
echo "making a single latex file..."
./make-single-latex-file.pl $1-main.tex
echo "finding figures and linking..."
./makelinks.pl $1-main-combined.tex

## this makes pdf's and such: moved to makelinks.pl
## cd package
## \ls *.pdf | xargs -n 1 pdf2ps
## \rm *.pdf
## \ls *.ps | xargs -n 1 ps2eps
## \rm *.ps
## for figure in $(\ls -1 *.png *.jpg); do
##   convert $figure{,.ps}
## done

echo "creating $1-arxiv.tgz..." 1>&2;
cd package;
tar cvfzph ../$1-arxiv.tgz * 1>&2;
