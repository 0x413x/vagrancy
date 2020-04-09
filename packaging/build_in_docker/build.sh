#!/bin/bash -e
#
# Build the release in a docker container.
#

WORKDIR=$(dirname $(readlink -f $0))
BASEDIR=$(dirname $(dirname $WORKDIR))

# Build base docker image
docker build -t vagrancy_build --pull $WORKDIR

# Run build script in docker
docker run \
       --rm \
       --name vagrancy_build \
       -v $BASEDIR:/vagrancy \
       -e TARGET_USER_ID=$(id -u) \
       -e TARGET_GROUP_ID=$(id -g) \
       vagrancy_build \
       /bin/bash -l -c /vagrancy/packaging/build_in_docker/test_and_build.sh
