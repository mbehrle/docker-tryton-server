# tryton-server 4.6

FROM debian:stretch-slim
MAINTAINER Mathias Behrle <mbehrle@m9s.biz>

# Set Tryton major variable for reuse
ENV T_DIST stretch
ENV T_MAJOR 4.6

# Setup environment and UTF-8 locale
ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8

# Use a local cache
#RUN echo 'Acquire::http { Proxy "http://apt-cacher:9999"; };' >> /etc/apt/apt.conf.d/01proxy

# Do not use Recommends (otherwise Tryton packages will install postgresql)
# Use gosu for easy step-down from root
# Add key and sources for debian.tryton.org
RUN apt-get update && apt-get install -y --no-install-recommends \
		curl \
		ca-certificates \
		gosu \
	&& curl -o /etc/apt/trusted.gpg.d/debian.tryton.org-archive.gpg -SL "http://debian.tryton.org/debian/debian.tryton.org-archive.gpg" \
	&& curl -o /etc/apt/sources.list.d/tryton-$T_DIST-$T_MAJOR.list http://debian.tryton.org/debian/tryton-$T_DIST-$T_MAJOR.list \
	&& curl -o /etc/apt/preferences.d/debian.tryton.org.pref -SL "http://debian.tryton.org/debian/debian.tryton.org.pref" \
	&& apt-get purge -y --auto-remove \
		curl \
		ca-certificates

# Install additional distribution packages
RUN apt-get update && apt-get install -y --no-install-recommends \
	python3-bcrypt \
	python3-levenshtein \
	python3-pydot \
	python3-psycopg2 \
	ssl-cert \
	tryton-server \
	unoconv \
	&& rm -rf /var/lib/apt/lists/*

# Default environment for the server
ENV TRYTOND_CONFIG=/etc/tryton/trytond.conf
ENV TRYTOND_DATABASE_URI=sqlite://
ENV TRYTOND_DATA=/var/lib/tryton

# Add a directory to process setup scripts for the container
RUN mkdir /docker-entrypoint-init.d

EXPOSE 	8000

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["trytond"]
