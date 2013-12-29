# Docker images with PostgreSQL

`pgserver` is the base server image. It is basically `apt-get install
postgresql-9.1`, with a "docker" user, and a "docker" database already created.

The following command can be used to build the image:

    > docker build -t pgserver pgserver

The image provides two commands: `run`, and `psql`. The former simply starts
the PostgreSQL server. See `pgserver.sh` for an example that use the `run`
command then spawn a local `psql` process to connect to the server. The later
directly starts a `psql` process within the container.

    > docker run -d pgserver run
    > docker run -t -i pgserver psql
