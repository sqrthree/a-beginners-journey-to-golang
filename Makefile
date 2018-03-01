all: clean serve
.PHONY: all

serve:
	@gitbook serve
.PHONY: serve

build:
	@gitbook build
.PHONY: build

clean:
	@rm -rf ./_book
.PHONY: clean
