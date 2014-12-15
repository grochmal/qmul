# Makefile for report
LATEX  = pdflatex
BIBTEX = bibtex
RM     = rm -f
BIB    = threem.bib
LTFS   = *.aux *.lof *.log *.lot *.fls *.out *.toc
DOCS   = *.dvi *.pdf
BIBS   = *.bbl *.blg
IDXS   = *.idx *.ilg *.ind *.ist
BEAM   = *.nav *.snm
OTHER  = *.acn *.acr *.glg *.glo *.gls *.brf *.lol

all: three-month.pdf pres.pdf

.PHONY: three pres
three: three-month.pdf
pres: pres.pdf

three-month.pdf: three-month.tex three-month.bbl
	$(LATEX) $<
	$(LATEX) $<

# beamer needs three passes:
# one to generate .aux
# one to generate \tableofcontents with pausesections
# and one to correct \tableofcontents with the moved pages
# after pausesections
%.pdf: %.tex
	$(LATEX) $<
	$(LATEX) $<
	$(LATEX) $<

.PRECIOUS: %.aux
%.aux: %.tex
	$(LATEX) $<

.PRECIOUS: %.bbl
%.bbl: %.aux $(BIB)
	$(BIBTEX) $<

.PHONY: clean
clean:
	$(RM) $(LTFS) $(DOCS) $(BIBS) $(IDXS) $(BEAM) $(OTHER)

