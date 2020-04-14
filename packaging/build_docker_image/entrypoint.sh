#!/bin/bash
#
# Entrypoint for vagrancy.
#

PORT="8099"
ENVIRONMENT="production"

show_help() {
  cat << EOF
`basename $0` [-p PORT] [-e ENVIRONMENT]

Options
    -p,     Port to listen on. Defaults to $PORT
    -e,     Rack environment. Default is $ENVIRONMENT
    -h,     Show help
EOF
}

while getopts "hp:e:" FLAG; do
  case $FLAG in
    p)
      PORT=$OPTARG
      ;;
    e)
      ENVIRONMENT=$OPTARG
      ;;
    h)
      show_help
      exit 1
      ;;
  esac

done

exec bundle exec puma -p $PORT -e $ENVIRONMENT
