#!/bin/bash -e
#
# Test uploading multiple versions of a dummy box and downloading it again.
#

source ${WORKDIR}/helpers/functions.sh

function uploadVersion() {
    echo "Test $1" > /tmp/dummy.box
    uploadBox   /tmp/dummy.box    test/multiversion $1
    downloadBox /tmp/dummy.box.2  test/multiversion $1

    echo "Compare the uploaded and the downloaded box files..."
    cmp /tmp/dummy.box /tmp/dummy.box.2

    checkVersionList test/multiversion $1
}

function checkVersion() {
    echo "Test $1" > /tmp/dummy.box
    downloadBox /tmp/dummy.box.2  test/multiversion $1

    echo "Compare the expected and the downloaded box files..."
    cmp /tmp/dummy.box /tmp/dummy.box.2

    checkVersionList test/multiversion $1
}

uploadVersion 0.0.1
uploadVersion 0.1.0
uploadVersion 1.0.0
uploadVersion 1.1.0

checkVersion 0.0.1
checkVersion 0.1.0
checkVersion 1.0.0
checkVersion 1.1.0

deleteBox test/multiversion 0.0.1
deleteBox test/multiversion 0.1.0
deleteBox test/multiversion 1.0.0
deleteBox test/multiversion 1.1.0

rm -f /tmp/dummy.box /tmp/dummy.box.2 /tmp/versionlist.txt
