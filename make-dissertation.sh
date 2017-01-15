#!/bin/bash

FILENAME_BASE="reagan-dissertation"

## set STYLE to "JA" for a journal article style thesis
##      (and set the \input's to \include's in the main)
## STYLE="standard"
STYLE="JA"

## first test the body versus our style scripts
for FILE in $FILENAME_BASE.chapter*-$STYLE.tex
do
  echo "checking $FILE"
  perl bin/lexical-illusion-spotter.pl $FILE
  bin/weasel-word-spotter.sh $FILE
  bin/passive-word-spotter.sh $FILE
done

pdflatex $FILENAME_BASE-main;

if [ $STYLE == "JA" ]; then
  for auxfile in $FILENAME_BASE.paper*.aux
  do
      bibtex `basename $auxfile .aux`
  done
  
  for bblfile in $FILENAME_BASE.paper*.bbl
  do
          sed -i 's/thebibliography/references/' $bblfile
  done
fi

bibtex $FILENAME_BASE-main;
pdflatex $FILENAME_BASE-main;
pdflatex $FILENAME_BASE-main;
## again for good measure
pdflatex $FILENAME_BASE-main;

echo " "
echo " "
echo "There are $(($(grep todo *.tex | wc -l | awk '{print $1;}')-2)) to-dos!!"

\rm *.{toc,aux,log,lot,lof,blg}
## leaving the .bbl for making arxiv version

open $FILENAME_BASE-main.pdf
