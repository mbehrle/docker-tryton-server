## mbsolutions/tryton-server [![](https://img.shields.io/badge/container-ready-green.svg?style=flat)](https://registry.hub.docker.com/u/mbsolutions/tryton-server/)

# Dockerfile for Tryton Server

## Supported tags

- [`latest`](https://github.com/mbehrle/docker-tryton-server/blob/master/Dockerfile)
- [`4.2`](https://github.com/mbehrle/docker-tryton-server/blob/4.2/Dockerfile)
- [`4.0`](https://github.com/mbehrle/docker-tryton-server/blob/4.0/Dockerfile)
- [`3.8`](https://github.com/mbehrle/docker-tryton-server/blob/3.8/Dockerfile)
- [`3.6`](https://github.com/mbehrle/docker-tryton-server/blob/3.6/Dockerfile)
- [`3.4`](https://github.com/mbehrle/docker-tryton-server/blob/3.4/Dockerfile)
- [`3.2`](https://github.com/mbehrle/docker-tryton-server/blob/3.2/Dockerfile)

This Dockerfile contains the steps required to build a working image of
Tryton server. The build is based on the official
[Debian base image](https://registry.hub.docker.com/_/debian/) on 
[Dockerhub](https://docs.docker.com/docker-hub/repos/#repositories) and 
packages from [Debian Tryton Maintainers](http://tryton.alioth.debian.org/).

The image provided by this Dockerfile is a minimalistic Docker container
for Tryton server

* that works out of the box,
* follows [best practices](https://docs.docker.com/articles/dockerfile_best-practices/) for Dockerfiles,
* is meant to be extended to fit your personal needs. For further steps see below.

The [Tryton Server image](https://registry.hub.docker.com/u/mbsolutions/tryton-server/) is built automatically from [GitHub](https://github.com/mbehrle/docker-tryton-server).

## Installation

If you don't have yet a running docker installation, install first `docker` with

    apt-get install docker.io

Add the user, that will use docker, to the docker group

    useradd myuser docker

Note: You may have to relogin before the group settings will take effect.


## Usage

Fetch the repository from docker

    docker pull mbsolutions/tryton-server

Note: To fetch and work with specific versions add the relative tag to the command like

    docker pull mbsolutions/tryton-server:4.2

Run a new container using the image

    docker run -d -p 8000:8000 mbsolutions/tryton-server

* The `-d` option indicates that the container should be run in daemon
  mode.
* The `-p` option and it's value `8000:8000` instructs docker to bind TCP port 8000
  of the container to port 8000 on the host. For more options on binding the interfaces
  of containers to the host machine see the
  [ports documentation](http://docs.docker.io/use/port_redirection/#port-redirection).

### Database creation

The creation of new databases is done with `trytond-admin` inside the container.
For more information have a look at the documentation of the
[Debian package](ttps://alioth.debian.org/plugins/scmgit/cgi-bin/gitweb.cgi?p=tryton/tryton-server.git;a=blob;f=debian/tryton-server.README.Debian;hb=HEAD).

## Environment Variables

This image image uses several environment variables which are not required,
but may significantly aid in using the image.

### `TRYTOND_DATABASE_URI`

This environment variable can be used to set the database connection.

Use "-e TRYTOND_DATABASE_URI=postgresql://user:password@localhost:5432/" in "docker run".

## Accessing the docker container

You can access the docker container and work from within it.

    docker exec -it mbsolutions/tryton-server /bin/bash

On execution of the command a new prompt within the container should be
available to you.

## Extending this image

This docker image is a minimal base on which you should extend and write
your own.

If you would like to do additional initialization `before` the startup of the server
in an image derived from this one, add an `*.sh` script under `/docker-entrypoint-init.d`.
The entrypoint script will will source any `*.sh` script found in that directory
to do further initialization before starting the service.

The following example steps would be required to say
make your setup work with postgres and install the sale module.


    # Tryton Server with Sale module and Postgres

    FROM mbsolutions/tryton-server:4.2
    MAINTAINER Mathias Behrle <mbehrle@m9s.biz>

    # Install additional distribution packages
    RUN apt-get update && apt-get install -y \
    tryton-modules-sale \
    && rm -rf /var/lib/apt/lists/*
        
    # Get a [sample trytond.conf](https://alioth.debian.org/plugins/scmgit/cgi-bin/gitweb.cgi?p=tryton/tryton-server.git;a=blob_plain;f=debian/trytond.conf;hb=refs/heads/debian), 
    # copy it to the directory of your Dockerfile,
    # adjust the settings to your needs (e.g. connection parameters and credentials to your PostgreSQL server)
    # and copy it into the container with
    COPY trytond.conf /etc/tryton/trytond.conf

## Authors and Credits

This image was built by [MBSolutions](http://www.m9s.biz).

Parts of the setup were adopted from

* [tryton](https://github.com/openlabs/tryton) by [Openlabs](http://www.openlabs.co.in).
* [postgres](https://github.com/docker-library/postgres/) by [Docker Official Image Packaging for Postgres](https://github.com/docker-library/postgres/).

## Support

For any questions about this image and your docker setup contact our [support](mailto:info@m9s.biz).

[![GPL 3 License](https://img.shields.io/badge/license-GPL3-blue.svg?style=flat)](LICENSE)
