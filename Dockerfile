ARG DOCKER_BASE_IMAGE
FROM ${DOCKER_BASE_IMAGE}
WORKDIR /var/local/app/
RUN mkdir --parents /usr/share/man/man1 \
  && apt-get update \
  && apt-get install --assume-yes --no-install-recommends \
    graphviz \
    default-jre

COPY ./Gemfile* ./
RUN bundle install

COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
