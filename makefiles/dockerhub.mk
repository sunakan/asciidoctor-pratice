################################################################################
# 変数
################################################################################
DOCKERHUB_USERNAME := dummy-user
DOCKERHUB_PASSWORD := dummy-pass

################################################################################
# タスク
################################################################################
.PHONY: dockerhub-login
dockerhub-login: ## dockerhubへlogin（要：user名とpassword）
	@echo $(DOCKERHUB_PASSWORD) | docker login --username $(DOCKERHUB_USERNAME) --password-stdin
