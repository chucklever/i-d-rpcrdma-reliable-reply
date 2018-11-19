#
# Manage generated versions of rpcrdma-reliable-reply
#

# Tools
ENSCRIPT := enscript -f Courier@10 --margins 76::76: -B -q -p
PS2PDF := pstopdf
RM := rm -f
XML2RFC := xml2rfc -v
IDNITS := ../../idnits-2.14.01/idnits

# full document name
AUTHOR := $(shell cat initials)
GROUP := nfsv4
NAME := $(shell basename $(PWD))
REVISION := $(shell cat revision)
DOCNAME := draft-$(AUTHOR)-$(GROUP)-$(NAME)-$(REVISION)

# Source
SOURCE := $(NAME).xml

# Gen
TXT := $(DOCNAME).txt
PS := $(DOCNAME).ps
PDF := $(DOCNAME).pdf
HTML := $(DOCNAME).html
XML := $(DOCNAME).xml

all: $(TXT) $(PS) $(PDF) $(HTML) $(XML)

autogen.xml: $(SOURCE) references/reference.*.xml initials revision
	sed -e s/DOCNAMEVAR/$(DOCNAME)/g < $(SOURCE) > $@

$(XML): autogen.xml
	$(XML2RFC) $^ --exp -o $@

$(TXT): $(XML)
	$(XML2RFC) $^ --text -o $@

$(HTML): $(XML)
	$(XML2RFC) $^ --html -o $@

$(PS): $(TXT)
	$(ENSCRIPT) $@ $^

$(PDF): $(PS)
	$(PS2PDF) $^ $@

.PHONY: idnits clean

idnits: $(TXT)
	$(IDNITS) --verbose $^

clean:
	$(RM) draft-* autogen.xml
