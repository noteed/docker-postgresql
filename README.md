# Docker images with PostgreSQL

`pgserver` is the base server image. It is basically `apt-get install
postgresql-9.1`, with a "docker" user, and a "docker" database already created.

The following command can be used to build the image:

    > docker build -t pgserver pgserver

See `pgserver.sh` for an example usage of the resulting image.
