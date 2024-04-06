
PREFIX?=~/.local

VERSIONS+=5 6.3 7 8 9

install: $(PREFIX)/bin/proton $(addprefix $(PREFIX)/bin/proton,$(VERSIONS))

$(PREFIX)/bin/proton: proton-run.sh
	cp -v $< $@

$(PREFIX)/bin/proton%: proton-run.sh
	if [ ! -L $@ ]; then \
		ln -s proton $@; \
	fi

