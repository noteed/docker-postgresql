# Docker images with PostgreSQL server and/or client

`pgserver` is the base server image. It is basically `apt-get update
postgresql`, a docker user, and a docker database.

The following command can be used to build the image:

    > docker build -t pgserver pgserver

See `pgserver.sh` for an example usage of the resulting image.
