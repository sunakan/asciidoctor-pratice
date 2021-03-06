include makefiles/dockerhub.mk
include makefiles/gitignore.mk
include makefiles/mo.mk
include makefiles/ytt.mk
include makefiles/help.mk

################################################################################
# マクロ
################################################################################
define config-json
  cat config.yml | ./ytt -f- --output json
endef

################################################################################
# 変数
################################################################################
APP_IMAGE         := $(shell $(config-json) | jq --raw-output '.["app-image"]')
DOCKER_BASE_IMAGE := $(shell $(config-json) | jq --raw-output '.["docker-base-image"]')

################################################################################
# タスク
################################################################################
.PHONY: build
build: ## asciidoctorイメージのビルド
	docker build ./app/ \
		--file ./Dockerfile \
		--build-arg DOCKER_BASE_IMAGE=$(DOCKER_BASE_IMAGE) \
		--tag $(APP_IMAGE)

.PHONY: bash
bash: ## asciidoctorコマンドが走る
	docker run \
		--rm \
		--interactive \
		--tty \
		--user `id -u`:`id -g` \
		--mount type=bind,source=$(PWD)/docs/,target=/var/local/docs/ \
		--env TZ=Aisa/Tokyo \
		--entrypoint '' \
		$(APP_IMAGE) bash

.PHONY: doc
doc: ## asciidoctorコマンドが走る
	docker run \
		--rm \
		--interactive \
		--tty \
		--user `id -u`:`id -g` \
		--mount type=bind,source=$(PWD)/docs/,target=/var/local/docs/ \
		--env TZ=Aisa/Tokyo \
		--entrypoint '' \
		$(APP_IMAGE) asciidoctor-pdf \
			--require asciidoctor-pdf-cjk \
			--require asciidoctor-diagram \
			--attribute scripts=cjk \
			--attribute pdf-type=default-with-fallback-font-theme.yml \
			/var/local/docs/README.adoc

#		htakeuchi/docker-asciidoctor-jp asciidoctor \
#			--require asciidoctor-pdf-cjk \
#			--require asciidoctor-diagram \
#			--out-file /var/local/docs/html/index.html \
#			/var/local/docs/README.adoc

#		uochan/docker-asciidoctor-jp asciidoctor \
#			-a source-highlighter=highlightjs -a stylesheet=/stylesheets/github.css \
#			--require asciidoctor-diagram \
#			--out-file /var/local/docs/html/index.html \
#			/var/local/docs/README.adoc

#		$(APP_IMAGE) \
#			--require asciidoctor-pdf-cjk \
#			--require asciidoctor-diagram \
#			--out-file /var/local/docs/html/index.html \
#			/var/local/docs/README.adoc

.PHONY: nginx
nginx: ## asciidoctorで出力したHTMLを閲覧するためのコンテナを立てる
	docker run \
		--detach \
		--rm \
		--name suna-nginx \
		--publish 80:80 \
		--mount type=bind,source=$(PWD)/docs/html/,target=/usr/share/nginx/html/ \
		nginx:stable

.PHONY: clean
clean: ## nginxコンテナを片付け
	docker container ls --quiet --filter 'name=suna-nginx' | xargs docker container stop

.PHONY: all
all:
	@make --no-print-directory doc
	cp docs/html/index.html ./README.html
