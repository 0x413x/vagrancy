#!/bin/bash -e
#
# Build a docker image of vagrancy.
#

WORKDIR=$(dirname $(readlink -f $0))
BASEDIR=$(dirname $(dirname $WORKDIR))

RUBY_VERSION=2.7-buster
VAGRANCY_VERSION=$(grep "^VERSION *=" $BASEDIR/Rakefile | cut -d = -f 2 | grep -o "[0-9.]*")

# Copy parts to move into docker
rm -rf   ${WORKDIR}/to_docker
mkdir -p ${WORKDIR}/to_docker
cp -a ${BASEDIR}/lib               ${WORKDIR}/to_docker/
cp -a ${BASEDIR}/spec              ${WORKDIR}/to_docker/
cp -a ${BASEDIR}/config.ru         ${WORKDIR}/to_docker/
cp -a ${BASEDIR}/config.sample.yml ${WORKDIR}/to_docker/config.yml
cp -a ${BASEDIR}/LICENCE.txt       ${WORKDIR}/to_docker/
cp -a ${BASEDIR}/README.md         ${WORKDIR}/to_docker/

# Build base docker image
docker build --pull \
       -t vagrancy:${VAGRANCY_VERSION} \
       --build-arg VAGRANCY_VERSION=${VAGRANCY_VERSION} \
       --build-arg RUBY_VERSION=${RUBY_VERSION} \
       $WORKDIR
