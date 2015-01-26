#!/bin/bash

PROXY_IP="proxy_address"
PROXY_PORT="proxy_port"

CORKSCREW=`which corkscrew`
if [ x$CORKSCREW == "x" ]; then
	echo "ERROR: Corkscrew is not installed."
	echo "corkscrew is a tool to tunnel TCP connections through an HTTP proxy"
	exit 1
fi

function usage {
	echo "Usage: $0 -r remote-server [-u user] [-p port]"
	exit 1
}

while getopts "u:p:r:" o; do
    case "${o}" in
    	r)	REMOTE_SERVER=${OPTARG} ;;
        u)	REMOTE_USER=${OPTARG} ;;
        p)	REMOTE_PORT=${OPTARG} ;;
        *)	usage ;;
    esac
done

[ -z $REMOTE_SERVER ] && usage
[ -z $REMOTE_USER ] && REMOTE_USER=`whoami`
[ -z $REMOTE_PORT ] && REMOTE_PORT=22

echo "Connecting to $REMOTE_USER@$REMOTE_SERVER:$REMOTE_PORT using proxy $PROXY_IP:$PROXY_PORT..."

ssh $REMOTE_USER@$REMOTE_SERVER -o \
	"ProxyCommand $CORKSCREW $PROXY_IP $PROXY_PORT $REMOTE_SERVER $REMOTE_PORT"
