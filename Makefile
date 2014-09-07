SHELL=/bin/sh

.PHONY: install
install:
	./deploy $(shell pwd) ${HOME} create

.PHONY: clean
clean:
	./deploy $(shell pwd) ${HOME} remove
