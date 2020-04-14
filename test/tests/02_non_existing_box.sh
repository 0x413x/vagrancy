#!/bin/bash -e
#
# Test handling of a box that does not exist.
#

source ${WORKDIR}/helpers/functions.sh

downloadBox /tmp/dummy.box test/nonexistant 1.0.0 virtualbox 404

checkVersionList test/nonexistant 1.0.0 virtualbox 404
checkNotInInventory test/nonexistant

deleteBox test/nonexistant 1.0.0 virtualbox 404

rm -f /tmp/dummy.box /tmp/versionlist.txt
