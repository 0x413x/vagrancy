#!/bin/bash -e
#
# Test handling of a box with invalid names.
#

source ${WORKDIR}/helpers/functions.sh

echo "Test" > /tmp/dummy.box
uploadBox   /tmp/dummy.box test 1.0.0 virtualbox 404
downloadBox /tmp/dummy.box test 1.0.0 virtualbox 404
checkVersionList           test 1.0.0 virtualbox 404
deleteBox                  test 1.0.0 virtualbox 404

uploadBox   /tmp/dummy.box test/wrong/name 1.0.0 virtualbox 404
downloadBox /tmp/dummy.box test/wrong/name 1.0.0 virtualbox 404
checkVersionList           test/wrong/name 1.0.0 virtualbox 404
deleteBox                  test/wrong/name 1.0.0 virtualbox 404

rm -f /tmp/dummy.box /tmp/versionlist.txt
