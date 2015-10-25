# Makefile for RIM presentation

LATEX = pdflatex
RM    = rm -f
LTFS  = *.aux *.lof *.log *.lot *.fls *.out *.toc *.snm *.nav *.pdf

all: rimpres.pdf

%.pdf: %.tex
	$(LATEX) $<

.PHONY: clean
clean:
	$(RM) $(LTFS)

