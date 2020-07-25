################################################################################
# 変数
################################################################################
IGNORE_OS       := linux,macos,windows
IGNORE_EDITOR   := vim,emacs,intellij+all,visualstudiocode
IGNORE_LANGUAGE := bash,ruby
IGNORE_LIST     := $(IGNORE_OS),$(IGNORE_EDITOR)
GIT_IGNORE_URL  := https://www.toptal.com/developers/gitignore/api/$(IGNORE_LIST)

################################################################################
# タスク
################################################################################
.gitignore:
	curl --output .gitignore $(GIT_IGNORE_URL)

.PHONY: setup-gitignore
setup-gitignore: .gitignore ## .gitignoreをsetup
	@make --no-print-directory add-ytt-for-gitignore
	@make --no-print-directory add-mo-for-gitignore

.PHONY: add-ytt-for-gitignore
add-ytt-for-gitignore:
	grep '^ytt$$' .gitignore || echo 'ytt' >> .gitignore

.PHONY: add-ytt-for-gitignore
add-mo-for-gitignore:
	grep '^mo$$' .gitignore || echo 'mo' >> .gitignore
