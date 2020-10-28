DOCNAME = robbie_vanvossen
IMAGES = $(wildcard images/*.xml)
IMAGE_PDFS = $(patsubst %.xml,%.pdf,$(IMAGES))

.PHONY: clean

$(DOCNAME).pdf: *.tex *.bib *.cls $(IMAGE_PDFS)
	xelatex $(DOCNAME)
	biber $(DOCNAME)
	xelatex $(DOCNAME)
	#docker run --rm -h dw_docs -v ${PWD}:/var/tex dornerworks/docs pdflatex $(DOCNAME).tex

images/%.pdf: images/%.xml
	docker run --rm -v ${PWD}/:/images/ dornerworks/drawio-batch bash -c "drawio-batch \
	$(patsubst %.pdf,%.xml,$@) $@"
	docker run --rm -h dw_docs -v ${PWD}:/var/tex dornerworks/docs pdfcrop $@ $@

full-clean: clean
	rm -rf *.pdf

clean:
	rm -rf *.aux *.toc *.log *.bcf *.out *.bbl *.xml *.blg $(IMAGE_PDFS) *~ \#*#
