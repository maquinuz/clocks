BROWSERIFY=./node_modules/.bin/browserify -t [babelify]
NODEMON=./node_modules/.bin/nodemon --ext js,scss --ignore ./css/ --ignore ./js/ --quiet
POSTCSS=./node_modules/.bin/postcss --use autoprefixer
SASS=./node_modules/.bin/node-sass --output-style=compressed
UGLIFY=./node_modules/.bin/uglifyjs --compress warnings=false --mangle

_SCSS=$(shell ls _scss)
CSS=$(addprefix css/, $(_SCSS:.scss=.css))
JS=$(addprefix js/, $(shell ls _js))

default: watch

build: css js

clean:
	rm -fr css js tmp

css: $(CSS)

css/%.css: _scss/%.scss
	@mkdir -p css
	cat $< | $(SASS) | $(POSTCSS) > $@

ga: $(shell git ls-files ./*.html | grep -v "^_")
	for i in $^; do ./_ga $$i; done

js: $(JS)

js/%.js: _js/%.js
	@mkdir -p js
	$(BROWSERIFY) -e $< | $(UGLIFY) > $@

watch:
	$(NODEMON) --exec "make build"

.PHONY: clean ga watch
