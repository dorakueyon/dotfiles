DOTPATH    := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))

init: ## Create symlink to home director
	@DOTPATH=$(DOTPATH) bash $(DOTPATH)/etc/init/init.sh

install: init ## Run make update, deploy, init
	@exec $$SHELL

help: ## Self-documented Makefile
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
