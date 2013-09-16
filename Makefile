SHELL=/bin/sh

.PHONY: install
install:
	./deploy.py $(shell pwd) ${HOME} create

.PHONY: clean
clean:
	./deploy.py $(shell pwd) ${HOME} remove
