SRC = $(wildcard *.coffee)
LIB = $(SRC:%.coffee=%.js)

all: build

build: $(LIB)

watch:
	watch -n1 $(MAKE) build

clean:
	rm -f *.js

test:
	$(MAKE) -Ctests

%.js: %.coffee
	coffee -bcp $< > $@

publish:
	git push
	git push --tags
	npm publish
