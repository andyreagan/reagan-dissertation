From Josh's version I've added some functionality through scripts, reorganized, and made the default more thesis-oriented.

TLDR: run "./setup.sh my-dissertation", edit away, compile w "./make-dissertation.sh"

Mainly, it's just more set up for making a standard style thesis (as opposed to a journal article thesis).
Both functionalities are included in the dissertation.tex file, and both sets of tex files for the chapters are included.
Running ./make-dissertation.sh makes either format, specified by the variable STYLE.

I've also included a few files for catching common writing errors, as detailed in http://matt.might.net/articles/shell-scripts-for-passive-voice-weasel-words-duplicates/ and brought to our attention by Chris Danforth.
These run by default in make-dissertation.sh and their usage is otherwise documented in bin.

On making an arxiv version: there are three scripts of Peter's that I've hacked upto make work on this repo.
This has only been tested with Master's thesis options in place.
As I've left it, it moves all the TeX to one file, and renames and grabs all of the figures, converts them all to pdf (from .ps,.pdf,.png,.jpg).
Things I changed from Peter were in the make-links, and make-arxiv-submission scripts.
In make-links.pl, you can play around to convert more figure types to pdf, or I commented out a chunk that converts them all to .eps.
But those files are bigger (although it will run without pdflatex then).
For the arXiv the images need to be small, (and they don't say), but I've figured out that less than 400K is okay.
It might be best to leave photos (with colors) as jpg, but the size penalty for converting the to pdf isn't that bad, and it looks nice having everything be pdf.
(This would be a quick change in make-links.pl).
For pdf's that are huge (millions of points plotted), you can bitmap them by converting to a png and back.
The -density is really important, for how it looks and the file size (those work in opposite directions).
Here is an example: (you need imagemagick and/or miktex)
% convert -density 150 image.{pdf,png}
% cp image{.pdf,-backup.pdf}
% convert image.{png,pdf}

If you have an ToC formatting questions, ask soon because I'll forget how that works.

Cheers,
Andy

-------------------------------------------

This is a LaTeX style file for typesetting a UVM thesis or dissertation in compliance with the guideline of the Graduate College.  The package is free software, available under the terms of the Academic Free License version 2.0.

I, Joshua Auerbach, adapted this from materials provided by David Van Horn (see http://www.cs.brandeis.edu/~dvanhorn/uvmlatexthesis/ and text below)

I have updated David's file to comply with the current guidelines (As of Spring semester 2013, see http://www.uvm.edu/~gradcoll/pdf/Guidelines%20for%20Writing%20and%20Defending%20Thesis%20and%20Disseration.pdf)
and to allow for journal format dissertations, but you will still need to bring a copy of your thesis to the Graduate College for a format review, and they may require you to make small changes. 

See dissertation.tex for an example and more details.

Use make-dissertation.sh to compile (this has some special logic for creating the per chapter reference sections)

Hope this is somewhat helpful.  Following David's initial remarks I welcome comments, questions, and improvements on this package. If your thesis uses this style, I'd really appreciate a notice. 
---Josh

------------------------------------------

David's original notice:

This is a LaTeX style file for typesetting a graduate thesis in compliance with the guidelines of the Graduate College of the University of Vermont. The package is free software, available under the terms of the Academic Free License version 2.0.

caveat emptor: You will still need to bring a copy of your thesis to the Graduate College for a format review, and they may require you to make small changes. Several people have taken a thesis using this style for review. Each time, different minor changes are requested by the reviewer. So, the process is not totally consistent, but this package should save you significant work. Send me any changes requested by the Graduate College and I will incorporate them into the style to save others the hassle.

I welcome comments, questions, and improvements on this package. If your thesis uses this style, I'd really appreciate a notice. ---David

2016-12-12

There are three strategies in the paper01 file on how to include papers.
Including the full PDF is very unlikely to be acceptable, so I'm going to try to include the full paper.
I thought of a better strategy that is to combine just the files that are needed over in the paper's own folder, and the include that file.
That way, can ensure that the full paths for images are loaded, etc.
This is the third, and hopefully final strategy for including papers.

Right now it doesn't compile because of the figures in the sentiment comp paper (the second strategy).
I think the newest solution I'm going to try is to add a makefile target for a combined version of the paper that uses full paths for the images!
...in the compilation: if filepath[0] is not "/": (make the path full)

Can use either
`PAPER_REF=emotional-arcs make test`
or
```export PAPER_REF=emotional-arcs
make test```

Wow after a great deal of work, everything is now working.
Using natbib in conjuction with chapterbib is not easy, and it requires the main file to be pdflatex'ed twice using different import options for chapterbib.
This is including the makefile logic for "rootbib"
```rootbib: reagan-dissertation.*.tex reagan-dissertation-main*.tex
	cp ~/papers/everything.bib .
	# with rootbib
	cp reagan-dissertation-main-rootbib.tex reagan-dissertation-main.tex
	pdflatex reagan-dissertation-main
	bibtex reagan-dissertation-main
	# change it to no rootbib
	cp reagan-dissertation-main-copy.tex reagan-dissertation-main.tex
	pdflatex reagan-dissertation-main
	bibtex reagan-dissertation.paper01
	sed -i .bak 's/thebibliography/references/' reagan-dissertation.paper01.bbl
	pdflatex reagan-dissertation-main
	pdflatex reagan-dissertation-main
	open reagan-dissertation-main.pdf```



