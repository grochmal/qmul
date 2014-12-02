# Makefile for report
LATEX  = pdflatex
BIBTEX = bibtex
RM     = rm -f
BIB    = biblio.bib
LTFS   = *.aux *.lof *.log *.lot *.fls *.out *.toc
DOCS   = *.dvi *.pdf
BIBS   = *.bbl *.blg
IDXS   = *.idx *.ilg *.ind *.ist
OTHER  = *.acn *.acr *.glg *.glo *.gls *.brf *.lol

all: three-month.pdf

%.pdf: %.tex # %.bbl
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
	$(RM) $(LTFS) $(DOCS) $(BIBS) $(IDXS) $(OTHER)
