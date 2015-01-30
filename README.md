# Docker images with PostgreSQL

## `pgserver`

`pgserver` is the base server image. It is basically `apt-get install
postgresql-9.1`, with a "docker" user, and a "docker" database already created.

The following command can be used to build the image:

    > docker build -t pgserver pgserver

The image provides five commands:

- `configure`,
- `build`,
- `run`,
- `restore`
- and `psql`.

`configure` takes three arguments: a new database name, a username, and a
password. Once the container exits, you can commit it to a new image.

    > docker run pgserver configure <database> <user> <password>
    > docker commit `docker ps -l -q` <image>

`restore` is used to temporarily restore a database cluster dump and inspect it
with `psql`. Assuming the file to restore and inspect is in the current
directory:

    > docker run -t -i -v `pwd`:/in pgserver restore /in/<filename>

`run` simply starts the PostgreSQL server. See `pgserver.sh` for an example
that use the `run` command then spawn a local `psql` process to connect to the
server. `psql` directly starts a `psql` process within the container.

    > docker run -d pgserver run
    > docker run -t -i pgserver psql

If a file `/initial.sh` is available in the image, it is executed before
running the server. Its purpose is to provide another way to create the `/data`
directory. A second argument can be given and will be passed the script (e.g.
to give it some URL from which to fetch a tarball).

    > docker run -d pgserver run http://example.com/base.tar.gz

To keep the PostgreSQL cluster around, and possibly reuse it in the next run of
the image, a volume called `/data` can be given to the container, e.g.:

    > docker run -t -i -v `pwd`/data:/data pgserver psql

When the container sees a `/data` directory, it will use it instead of the
cluster that already exists within the image.

One possible way to create initially the local `data` directory is to use
`docker cp`, e.g.:

    > docker run pgserver true
    > docker cp `docker ps -l -q`:/var/lib/postgresql/9.1/main .
    > mv main data

where `a62681994e1f` is the container ID of a previous run.

    > docker run pgserver
    > docker ps -l

A complementary way to create the local `data` is to provide a `build.sh`
script and use the `build` command:

    > docker run -v `pwd`/build:/build pgserver build
    > docker cp `docker ps -l -q`:/var/lib/postgresql/9.1/main .
    > mv main data

This makes it possible to initialize the cluster in a clean way (i.e. the
server is stopped properly with `service postgresql stop`).

# `pgprimary`

`pgprimary` is similar to `pgserver` (and it is built on top of it), but has
WAL archiving enabled. Read its Dockerfile to see how to configure a new
image for yourself.
