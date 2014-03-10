# Docker images with PostgreSQL

## `pgserver`

`pgserver` is the base server image. It is basically `apt-get install
postgresql-9.1`, with a "docker" user, and a "docker" database already created.

The following command can be used to build the image:

    > docker build -t pgserver pgserver

The image provides three commands: `configure`, `run`, and `psql`.

`configure` takes three arguments: a new database name, a username, and a
password. Once the container exits, commit it to a new image.

`run` simply starts the PostgreSQL server. See `pgserver.sh` for an example
that use the `run` command then spawn a local `psql` process to connect to the
server. `psql` directly starts a `psql` process within the container.

    > docker run -d pgserver run
    > docker run -t -i pgserver psql

To keep the PostgreSQL cluster around, and possibly reuse it in the next run of
the image, a volume called `/data` can be given to the container, e.g.:

    > docker run -t -i -v `pwd`/data:/data pgserver psql

When the container sees a `/data` directory, it will use it instead of the
cluster that already exists within the image.

One possible way to create initially the local `data` directory is to use
`docker cp`, e.g.:

    > docker cp a62681994e1f:/var/lib/postgresql/9.1/main .
    > mv main data

where `a62681994e1f` is the container ID of a previous run.

    > docker run pgserver
    > docker ps -l

# `pgprimary`

`pgprimary` is similar to `pgserver` (and it is built on top of it), but has
WAL archiving enabled. Read its Dockerfile to see how to configure a new
image for yourself.
