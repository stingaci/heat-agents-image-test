#!/bin/bash
set -eux

http_proxy=$http_proxy_val
https_proxy=$https_proxy_val

if [ "$http_proxy" != "None" ]
then
	export HTTP_PROXY=$http_proxy
	echo "Setting http_proxy var: $HTTP_PROXY"
fi

if [ "$https_proxy" != "None" ]
then
	export HTTPS_PROXY=$https_proxy
	echo "Setting https_proxy var: $HTTPS_PROXY"
fi

yum -y install https://www.rdoproject.org/repos/rdo-release.rpm
yum -y install python-zaqarclient python-oslo-log python-psutil os-collect-config os-apply-config os-refresh-config dib-utils
