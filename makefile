PAPER=reagan-dissertation
PYTOOLDIR=/Users/andyreagan/tools/python/kitchentable/
PLTOOLDIR=/Users/andyreagan/tools/perl/kitchentable/
all: rootbib
clean:
	rm *.aux *.log *.blg *.lof *.lot *.out *.toc *~ *.bak *.bbl
# this doesn't work!
# needs rootbib
main: reagan-dissertation.*.tex reagan-dissertation-main*.tex
	# cp ~/papers/everything.bib .
	pdflatex ${PAPER}-$@
	bibtex ${PAPER}-$@
	sed -i .bak 's/thebibliography/references/' ${PAPER}.paper01.bbl
	bibtex ${PAPER}-$@
	pdflatex ${PAPER}-$@
	pdflatex ${PAPER}-$@
	open ${PAPER}-$@.pdf
# arxiv: main
# 	# cutpdf 1 8 ${PAPER}-$@-manuscript.pdf ${PAPER}-$@.pdf
# 	# open ${PAPER}-$@-manuscript.pdf
# 	if [ -d $@-package ]; then \rm -r $@-package; fi
# 	mkdir -p $@-package
# 	python ${PYTOOLDIR}make-single-latex-file.py ${PAPER}-$<.tex
# 	${PLTOOLDIR}make-links.pl ${PAPER}-$<-combined.tex $@-package
# 	# cd arxiv-package; for fig in $$(\ls -1 fig*.pdf | head -n 50); do optimizepdf $$fig; done
# 	cd $@-package; tar cvfzph ../${PAPER}-$<-$@.tgz * 1>&2;
rootbib.out: reagan-dissertation.*.tex reagan-dissertation-main*.tex
	# cp ~/Box\ Sync/papers/everything.bib .
	# with rootbib
	sed -i .bak 's/\usepackage{chapterbib}/\usepackage[rootbib]{chapterbib}/' reagan-dissertation-main.tex
	# cp reagan-dissertation-main-rootbib.tex reagan-dissertation-main.tex
	pdflatex reagan-dissertation-main
	bibtex reagan-dissertation-main
	# change it back to no rootbib
	sed -i .bak 's/\usepackage\[rootbib\]{chapterbib}/\usepackage{chapterbib}/' reagan-dissertation-main.tex
	# cp reagan-dissertation-main-copy.tex reagan-dissertation-main.tex
	pdflatex reagan-dissertation-main
	bibtex reagan-dissertation.paper01
	bibtex reagan-dissertation.paper02
	sed -i .bak 's/thebibliography/references/' reagan-dissertation.paper01.bbl
	sed -i .bak 's/thebibliography/references/' reagan-dissertation.paper02.bbl
	pdflatex reagan-dissertation-main
	pdflatex reagan-dissertation-main
	# open reagan-dissertation-main.pdf
	# gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER -dFirstPage=1 -dLastPage=18 -sOutputFile=$1-combined-manuscript.pdf $1-combined.pdf $1>&2
	touch rootbib.out
arxiv-package: rootbib.out
	# cutpdf 1 8 ${PAPER}-$@-manuscript.pdf ${PAPER}-$@.pdf
	# open ${PAPER}-$@-manuscript.pdf
	if [ -d $@ ]; then \rm -r $@; fi
	mkdir -p $@
	python ${PYTOOLDIR}make-single-latex-file.py ${PAPER}-main.tex
	cp reagan-dissertation.paper01.bbl $@/reagan-dissertation.paper01-combined.bbl
	cp reagan-dissertation.paper02.bbl $@/reagan-dissertation.paper02-combined.bbl
	# cp *-combined.tex $@
	${PLTOOLDIR}make-links.pl ${PAPER}.paper01-combined.tex $@
	${PLTOOLDIR}make-links.pl ${PAPER}.paper02-combined.tex $@
	# cp everything.bib $@
	cp thesis.sty $@
	${PLTOOLDIR}make-links.pl ${PAPER}-main-combined.tex $@
	# cd arxiv-package; for fig in $$(\ls -1 fig*.pdf | head -n 50); do optimizepdf $$fig; done
	cp -r /Users/andyreagan/projects/2014/09-books/media/figures/all-timeseries $@
	cd $@; sed -i .bak 's|/Users/andyreagan/projects/2014/09-books/media/figures/||' reagan-dissertation-main-combined.tex
	# tell arxiv to process this file first
	mv $@/${PAPER}-main-combined.tex $@/ms.tex
	cd $@; tar cvfzph ../${PAPER}-main-$@.tgz * 1>&2;
	# check that it can build
	cd $@; pdflatex ms; pdflatex ms;
