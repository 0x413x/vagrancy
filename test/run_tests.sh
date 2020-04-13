#!/bin/bash -e
#
# Test the vagrancy API.
#


# -----------------------------------------------------------------------------
# CHECK SYSTEM REQUIREMENTS
# -----------------------------------------------------------------------------
if ! which curl >/dev/null; then
    echo "ERROR: Please install 'curl'!"
    exit 2
fi


# -----------------------------------------------------------------------------
# CHECK COMMAND LINE ARGUMENTS
# -----------------------------------------------------------------------------
VAGRANCY_HOST=127.0.0.1
VAGRANCY_PORT=8099
VAGRANCY_STORAGE=

function usage() {
    echo
    echo "Usage: $1 [-h <HOST>] [-p <PORT>] [-s <STORAGE_DIR>]"
    echo ""
    echo "Test the vagrancy installation on a remote host. You can"
    echo "overwrite the default host (${VAGRANCY_HOST}) and port (${VAGRANCY_PORT})"
    echo "by using the '-h' and '-p' options."
    exit 1
}

while getopts "h:p:s:" OPT; do
    case $OPT in
	h )
	    VAGRANCY_HOST=$OPTARG
	    ;;
	p )
	    VAGRANCY_PORT=$OPTARG
	    ;;
	s )
	    VAGRANCY_STORAGE=$OPTARG
	    ;;
	\? )
	    usage $0
	    ;;
    esac
done


# -----------------------------------------------------------------------------
# EXPORTS FOR TEST SCRIPTS
# -----------------------------------------------------------------------------
export WORKDIR=$(dirname $(readlink -f $0))
export VAGRANCY_URL=http://${VAGRANCY_HOST}:${VAGRANCY_PORT}
export VAGRANCY_STORAGE


# -----------------------------------------------------------------------------
# RUN TESTS
# -----------------------------------------------------------------------------
RETVAL=0
TMPOUTPUT=$(tempfile)

for SCRIPT in ${WORKDIR}/tests/*.sh; do
    echo -n "Running test $(basename $SCRIPT) ... "
    if $SCRIPT &> $TMPOUTPUT; then
	echo "OK"
    else
	echo "FAILED"
	echo "-----------------------------------------------------------------"
	echo " Output:"
	cat $TMPOUTPUT
	echo "-----------------------------------------------------------------"
	RETVAL=1
    fi
done

rm -f $TMPOUTPUT

exit $RETVAL


# -----------------------------------------------------------------------------
# EOF
# -----------------------------------------------------------------------------
