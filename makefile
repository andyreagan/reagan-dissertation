all: rootbib
clean:
	rm *.aux *.log *.blg *.lof *.lot *.out *.toc *~ *.bak *.bbl
main: reagan-dissertation.*.tex reagan-dissertation-main*.tex
	cp ~/papers/everything.bib .
	pdflatex reagan-dissertation-main
	bibtex reagan-dissertation.paper01
	sed -i .bak 's/thebibliography/references/' reagan-dissertation.paper01.bbl
	bibtex reagan-dissertation-main
	pdflatex reagan-dissertation-main
	pdflatex reagan-dissertation-main
	open reagan-dissertation-main.pdf
rootbib: reagan-dissertation.*.tex reagan-dissertation-main*.tex
	cp ~/Box\ Sync/papers/everything.bib .
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
	open reagan-dissertation-main.pdf
	# gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER -dFirstPage=1 -dLastPage=18 -sOutputFile=$1-combined-manuscript.pdf $1-combined.pdf $1>&2
# revtex: reagan-dissertation.*.tex reagan-dissertation-revtex4*.tex
# 	pdflatex reagan-dissertation-revtex4
# 	bibtex reagan-dissertation-revtex4
# 	pdflatex reagan-dissertation-revtex4
# 	pdflatex reagan-dissertation-revtex4
# 	open reagan-dissertation-revtex4.pdf
# pnas: reagan-dissertation.*.tex reagan-dissertation-revtex4*.tex
# 	pdflatex reagan-dissertation-pnas
# 	bibtex reagan-dissertation-pnas
# 	pdflatex reagan-dissertation-pnas
# 	pdflatex reagan-dissertation-pnas
# 	open reagan-dissertation-pnas.pdf
# plos: reagan-dissertation.*.tex reagan-dissertation-revtex4*.tex
# 	pdflatex reagan-dissertation-pnas
# 	bibtex reagan-dissertation-pnas
# 	pdflatex reagan-dissertation-pnas
# 	pdflatex reagan-dissertation-pnas
# 	open reagan-dissertation-pnas.pdf
