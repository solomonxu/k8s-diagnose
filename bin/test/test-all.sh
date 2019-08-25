#!/usr/bin/bash

## include shells
. ./common/logger.sh

## get host
host=192.168.1.12
if [ $# -ge 1 ]; then
    host=$1
fi 

logger_info "TEST ALL: host=${host}"

#./test/test-common-ssh.sh ${host}
./test/test-common-logger.sh ${host}
#./test/test-common-email.sh ${host}
./test/test-os-os.sh ${host}
./test/test-docker-docker.sh ${host}
./test/test-k8s-kubectl.sh ${host}
#./test/test-kcc-kcc.sh ${host}
#./test/test-all.sh ${host}

logger_info "TEST ALL: Done."
