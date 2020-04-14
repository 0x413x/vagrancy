#!/bin/bash -e
#
# Test the docker image of vagrancy.
#

WORKDIR=$(dirname $(readlink -f $0))
BASEDIR=$(dirname $(dirname $WORKDIR))

VAGRANCY_VERSION=$(grep "^VERSION *=" $BASEDIR/Rakefile | cut -d = -f 2 | grep -o "[0-9.]*")

# Run the vagrancy
mkdir -p /tmp/vagrancy_test
docker run \
       --rm -d \
       --name vagrancy_test \
       -v /tmp/vagrancy_test:/data \
       -p 127.0.0.1:9000:9000 \
       vagrancy:${VAGRANCY_VERSION} -p 9000
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
