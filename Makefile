all: serve
.PHONY: all

serve:
	@gitbook serve
.PHONY: serve

build:
	@gitbook build
.PHONY: build
