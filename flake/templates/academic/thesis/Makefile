.PHONY: all clean watch

MAIN = main

all: $(MAIN).pdf

$(MAIN).pdf: $(MAIN).tex references.bib
	latexmk -pdf -interaction=nonstopmode $(MAIN).tex

watch:
	latexmk -pdf -pvc -interaction=nonstopmode $(MAIN).tex

clean:
	latexmk -C
	rm -f *.bbl *.run.xml
