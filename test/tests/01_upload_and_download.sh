#!/bin/bash -e
#
# Test uploading a dummy box and downloading it again.
#

source ${WORKDIR}/helpers/functions.sh

echo "Test" > /tmp/dummy.box
uploadBox /tmp/dummy.box test/ubuntu

downloadBox /tmp/dummy.box.2 test/ubuntu

echo "Compare the uploaded and the downloaded box files..."
cmp /tmp/dummy.box /tmp/dummy.box.2

checkVersionList test/ubuntu
checkInInventory test/ubuntu

deleteBox test/ubuntu
checkNotInInventory test/ubuntu

rm -f /tmp/dummy.box /tmp/dummy.box.2 /tmp/versionlist.txt /tmp/inventory
