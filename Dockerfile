ARG DOCKER_BASE_IMAGE
FROM ${DOCKER_BASE_IMAGE}
WORKDIR /var/local/app/
COPY ./Gemfile* ./
RUN bundle install
COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
