NAME=draft-ietf-taps-transports-02
MD=kramdown-rfc2629
X2R=xml2rfc
CF=cupsfilter

all: txt pdf
txt: $(NAME).txt
pdf: $(NAME).pdf
clean:
	if [ -e $(NAME).xml  ]; then rm $(NAME).xml ; fi
	if [ -e $(NAME).txt  ]; then rm $(NAME).txt ; fi
	if [ -e $(NAME).html ]; then rm $(NAME).html; fi
	if [ -e $(NAME).pdf  ]; then rm $(NAME).pdf ; fi

%.pdf: %.txt
	$(CF) $< > $@

%.txt: %.xml
	$(X2R) $< $@

%.xml: %.md
	$(MD) < $< | sed -e 's/xml.resource.org/xml2rfc.ietf.org/g' > $@

#$(NAME).pdf: $(NAME).txt
#	$(CF) $(NAME).txt >$(NAME).pdf

#$(NAME).txt: $(NAME).xml
#	$(X2R) $(NAME).xml $(NAME).txt

#$(NAME).xml: $(NAME).md
#	$(MD) <$(NAME).md | sed -e 's/xml.resource.org/xml2rfc.ietf.org/g' >$(NAME).xml
