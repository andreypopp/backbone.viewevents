SRC = $(wildcard *.coffee)
LIB = $(SRC:%.coffee=%.js)

all: build

build: $(LIB)

watch:
	watch -n1 $(MAKE) build

clean:
	rm -f *.js

%.js: %.coffee
	coffee -bcp $< > $@
