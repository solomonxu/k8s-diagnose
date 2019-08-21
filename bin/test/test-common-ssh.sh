#!/usr/bin/bash

## include shells
. ./common/logger.sh
. ./common/ssh.sh

## read config and included shells
chmod a+x ../conf/diag.conf
. ../conf/diag.conf

## test ssh trust by remote hosts
test_ssh_remote_trust(){
    logger_info "TEST: call test_ssh_remote_trust"
    ssh_remote_trust;
}

## trust by remote hosts
test_ssh_remote_trust;
