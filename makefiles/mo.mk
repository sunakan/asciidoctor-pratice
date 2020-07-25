################################################################################
# タスク
################################################################################
.PHONY: install-mo
install-mo:
	( command -v ./mo ) \
	|| curl -sSL https://git.io/get-mo -o mo
	chmod +x ./mo

.PHONY: setup-mo
setup-mo: ## moのインストール
	@make --no-print-directory install-mo

.PHONY: uninstall-mo
uninstall-mo: ## moのアンインストール
	command -v ./mo && rm ./mo
