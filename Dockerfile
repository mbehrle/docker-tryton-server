# tryton-server 3.4

FROM debian:jessie
MAINTAINER Mathias Behrle <mbehrle@m9s.biz>

# Set Tryton major variable for reuse
ENV T_MAJOR 3.4

# Setup environment and UTF-8 locale
ENV DEBIAN_FRONTEND noninteractive
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Use our local cache
#RUN echo 'Acquire::http { Proxy "http://apt-cacher:9999"; };' >> /etc/apt/apt.conf.d/01proxy (#778532)
#RUN sed -i "s/http\.debian\.net/apt-cacher:9999/" /etc/apt/sources.list

# Do not use Recommends (otherwise Tryton packages will install postgresql)
# Grab gosu for easy step-down from root
# (gosu snippets taken from https://github.com/docker-library/postgres/blob/master/9.4/Dockerfile)
# Add key and sources for gosu and debian.tryton.org
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN apt-get update && apt-get install -y --no-install-recommends \
	curl ca-certificates locales \
	&& rm -rf /var/lib/apt/lists/* \
	&& curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture)" \
	&& curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture).asc" \
	&& gpg --verify /usr/local/bin/gosu.asc \
	&& rm /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu \
	&& curl -o /etc/apt/debian.tryton.org-archive.asc -SL "http://debian.tryton.org/debian/debian.tryton.org-archive.asc" \
	&& apt-key add /etc/apt/debian.tryton.org-archive.asc \
	&& curl -o /etc/apt/sources.list.d/tryton-jessie-$T_MAJOR.list http://debian.tryton.org/debian/tryton-jessie-$T_MAJOR.list \
	&& curl -o /etc/apt/preferences.d/debian.tryton.org.pref -SL "http://debian.tryton.org/debian/debian.tryton.org.pref" \
	&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
	&& apt-get purge -y --auto-remove curl ca-certificates

# Install additional distribution packages
RUN apt-get update && apt-get install -y --no-install-recommends \
	python-psycopg2 \
	python-levenshtein \
	python-bcrypt \
	python-pydot \
	python-webdav \
	python-psycopg2 \
	ssl-cert \
	tryton-server \
	unoconv \
	&& rm -rf /var/lib/apt/lists/*

# Default environment for the server
ENV TRYTOND_CONFIG=/etc/tryton/trytond.conf
#ENV TRYTOND_DATABASE_URI=sqlite://
ENV TRYTOND_DATA=/var/lib/tryton
ENV TRYTONPASSFILE=/tmp/trytonpass

# Add a directory to process setup scripts for the container
RUN mkdir /docker-entrypoint-init.d

EXPOSE 	8000

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["trytond"]
