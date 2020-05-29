SHELL = /bin/bash

.PHONY: help build go

.DEFAULT_GOAL = help

help:
	@echo "You'll need to specify a thing to do:"
	@egrep '^(.+)\:\ ##\ (.+)' ${MAKEFILE_LIST} | column -t -c 2 -s ':#'

build: ## - Build Docker image
	@echo "[i] Building docker image"
	@docker build -t mcrmonkey/doctl-pkg .

output:
	@echo "[i] Creating output directory"
	@mkdir output

go: ## - Go get doctl. Specify "VERSION=" to override defaults
	@echo "[i] Getting doctl..."
	@${MAKE} output
	@docker run -it --rm -e VERSION="${VERSION}" -v ${PWD}/output:/output mcrmonkey/doctl-pkg

