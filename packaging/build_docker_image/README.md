Build a Docker Image of Vagrancy
================================

This directory hosts the scripts and configuration files used to build a
docker image containing a vagrancy instance. Instead of using the default
portable distribution a native ruby environment is used.


Usage
-----

    packaging/build_docker_image/build.sh
    packaging/build_docker_image/test.sh


The docker image is then available as vagrancy:0.0.4.


Starting the Docker Container
-----------------------------

The mount point `/data` of the docker container should be pointed to a persistent
directory, and the port used to communicate with the vagrancy must be exported as
well. For example, to start the docker container using the host directory
`/server/vagrancy` and port 9000, call

    docker run \
       --rm -d \
       --name vagrancy \
       -v /server/vagrancy:/data \
       -p 9000:9000 \
       vagrancy:0.0.4 -p 9000
