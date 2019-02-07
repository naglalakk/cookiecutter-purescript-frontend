PCK_MANAGER=yarn

.PHONY: all test clean

default: build docs

docs:
	purs docs '.spago/*/*/src/**/*.purs' 'src/*.purs' --format html

server:
	spago bundle --main Server --to server.js && node server.js
test:
	spago test

build: install
	spago build

bundle:
	spago build && spago bundle --to static/dist/index.js

install:
	spago install && $(PCK_MANAGER) install

clean:
	rm -rf output generated-docs
