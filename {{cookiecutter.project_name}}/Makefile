PCK_MANAGER=yarn

.PHONY: all test clean

default: build docs

docs:
	purs docs '.spago/*/*/src/**/*.purs' 'src/*.purs' --format html

server:
	make bundle && make browser && spago bundle-app --main Server --to server.js && node server.js

test:
	spago test

build: install
	spago build

bundle:
	spago build && spago bundle-app --to static/build/index.js

browser:
	parcel build static/build/index.js -d static/dist

install:
	spago install && $(PCK_MANAGER) install

clean:
	rm -rf output generated-docs
