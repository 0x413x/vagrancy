#!/bin/bash -e
#
# Install the release in a docker container
#

WORKDIR=$(dirname $(readlink -f $0))
BASEDIR=$(dirname $(dirname $WORKDIR))

UBUNTU_VERSION=18.04
VAGRANCY_VERSION=$(grep "^VERSION *=" $BASEDIR/Rakefile | cut -d = -f 2 | grep -o "[0-9.]*")

# Copy release
cp $BASEDIR/vagrancy-${VAGRANCY_VERSION}-linux-x86_64.tar.gz $WORKDIR

# Build docker image
docker build \
       -t vagrancy_test \
       --build-arg UBUNTU_VERSION=${UBUNTU_VERSION} \
       --build-arg VAGRANCY_VERSION=${VAGRANCY_VERSION} \
        $WORKDIR

# Run the vagrancy
mkdir -p /tmp/vagrancy_test
docker run \
       --rm -d \
       --name vagrancy_test \
       -v /tmp/vagrancy_test:/var/tmp/vagrancy \
       -p 127.0.0.1:9000:9000 \
       vagrancy_test -p 9000
sleep 5s

# Perform the tests
RETVAL=0
if ! $BASEDIR/test/run_tests.sh -h 127.0.0.1 -p 9000 -s /tmp/vagrancy_test; then
    RETVAL=1
fi

# Stop the vagrancy
docker stop vagrancy_test
sudo rm -rf /tmp/vagrancy_test

exit $RETVAL
