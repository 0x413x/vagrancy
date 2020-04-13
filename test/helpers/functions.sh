#
# Helper functions to be sourced by calling
#  source ${WORKDIR}/helpers/functions.sh
#


# uploadBox <FILE> <BOXNAME> <VERSION> <PROVIDER> <EXPECTED HTTP CODE>
function uploadBox() {
    BOXFILE=$1
    BOXNAME=$2
    VERSION=${3:-1.0.0}
    PROVIDER=${4:-virtualbox}
    EXPECTED_HTTP_STATUS=${5:-201}

    echo "Uploading box file $BOXFILE as $BOXNAME (provider $PROVIDER) version $VERSION..."
    HTTP_STATUS=$(curl -w "%{http_code}" ${VAGRANCY_URL}/$BOXNAME/$VERSION/$PROVIDER --upload-file $BOXFILE)
    if [[ "$HTTP_STATUS" != *"$EXPECTED_HTTP_STATUS"* ]]; then
	echo "ERROR: Expected HTTP status $EXPECTED_HTTP_STATUS for upload command but received $HTTP_STATUS!"
	exit 1
    fi

    if [ "$EXPECTED_HTTP_STATUS" == "201" ]; then
	if [ "$VAGRANCY_STORAGE" != "" ]; then
	    if ! cmp $BOXFILE $VAGRANCY_STORAGE/$BOXNAME/$VERSION/$PROVIDER/box &>/dev/null; then
		echo "ERROR: Uploaded file does not match file found in the file storage!"
		exit 2
	    fi
	fi
    fi
}


# downloadBox <FILE> <BOXNAME> <VERSION> <PROVIDER> <EXPECTED HTTP CODE>
function downloadBox() {
    BOXFILE=$1
    BOXNAME=$2
    VERSION=${3:-1.0.0}
    PROVIDER=${4:-virtualbox}
    EXPECTED_HTTP_STATUS=${5:-200}

    echo "Downloading box file $BOXFILE as $BOXNAME (provider $PROVIDER) version $VERSION..."
    HTTP_STATUS=$(curl -w "%{http_code}" -o $BOXFILE ${VAGRANCY_URL}/$BOXNAME/$VERSION/$PROVIDER)
    if [[ "$HTTP_STATUS" != *"$EXPECTED_HTTP_STATUS"* ]]; then
	echo "ERROR: Expected HTTP status $EXPECTED_HTTP_STATUS for download command but received $HTTP_STATUS!"
	exit 1
    fi

    if [ "$EXPECTED_HTTP_STATUS" == "200" ]; then
	if [ "$VAGRANCY_STORAGE" != "" ]; then
	    if ! cmp $BOXFILE $VAGRANCY_STORAGE/$BOXNAME/$VERSION/$PROVIDER/box &>/dev/null; then
		echo "ERROR: Downloaded file does not match file found in the file storage!"
		exit 2
	    fi
	fi
    fi
}


# deleteBox <BOXNAME> <VERSION> <PROVIDER> <EXPECTED HTTP CODE>
function deleteBox() {
    BOXNAME=$1
    VERSION=${2:-1.0.0}
    PROVIDER=${3:-virtualbox}
    EXPECTED_HTTP_STATUS=${4:-200}

    echo "Deleting box $BOXNAME (provider $PROVIDER) version $VERSION..."
    HTTP_STATUS=$(curl -w "%{http_code}" -XDELETE ${VAGRANCY_URL}/$BOXNAME/$VERSION/$PROVIDER)
    if [[ "$HTTP_STATUS" != *"$EXPECTED_HTTP_STATUS"* ]]; then
	echo "ERROR: Expected HTTP status $EXPECTED_HTTP_STATUS for delete command but received $HTTP_STATUS!"
	exit 1
    fi

    if [ "$EXPECTED_HTTP_STATUS" == "200" ]; then
	if [ "$VAGRANCY_STORAGE" != "" ]; then
	    if [ -e $VAGRANCY_STORAGE/$BOXNAME/$VERSION/$PROVIDER/box ]; then
		echo "ERROR: Box still available at $VAGRANCY_STORAGE/$BOXNAME/$VERSION/$PROVIDER/box!"
		exit 1
	    fi
	fi
    fi
}

# deleteBox <BOXNAME> <VERSION> <PROVIDER> <EXPECTED HTTP CODE>
function checkVersionList() {
    BOXNAME=$1
    VERSION=${2:-1.0.0}
    PROVIDER=${3:-virtualbox}
    EXPECTED_HTTP_STATUS=${4:-200}

    echo "Checking for box $BOXNAME (provider $PROVIDER) version $VERSION in version list..."
    HTTP_STATUS=$(curl -w "%{http_code}" -o /tmp/versionlist.txt ${VAGRANCY_URL}/$BOXNAME)
    if [[ "$HTTP_STATUS" != *"$EXPECTED_HTTP_STATUS"* ]]; then
	echo "ERROR: Expected HTTP status $EXPECTED_HTTP_STATUS for version list but received $HTTP_STATUS!"
	exit 1
    fi

    if [ "$EXPECTED_HTTP_STATUS" == "200" ]; then
	if ! grep -q "\"version\":\"$VERSION\"" /tmp/versionlist.txt; then
	    echo "ERROR: The version $VERSION was not found in the version list!"
	    exit 1
	fi
	if ! grep -q "\"url\":\"${VAGRANCY_URL}/$BOXNAME/$VERSION/$PROVIDER\"" /tmp/versionlist.txt; then
	    echo "ERROR: The URL ${VAGRANCY_URL}/$BOXNAME/$VERSION/$PROVIDER was not found in the version list!"
	    exit 1
	fi
    fi
}
