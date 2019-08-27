#!/usr/bin/bash

## include shells
. ./common/logger.sh
. ./common/ssh.sh

## read config and included shells
chmod a+x ../conf/diag.conf
. ../conf/diag.conf

## test ssh trust by remote hosts
function test_ssh_remote_trust()
{
    logger_info "TEST: call test_ssh_remote_trust"
    ssh_remote_trust;
}

## test
## enable trusting on this local host by remote hosts
## run multi-tasks concurrently
function test_ssh_remote_trust_concur()
{
    logger_info "TEST: call ssh_remote_trust_concur $@"
    ssh_remote_trust_concur $@;
}

## test check and install COMMAND on remote host
function test_ssh_remote_check_install
{
    logger_info "TEST: call ssh_remote_check_install $@"	
    ssh_remote_check_install $@
    _ret=${ret_value}
    logger_info "TEST: check and install's result is: ${_ret}"
}

logger_info "TEST: ssh"

## get host
_host=192.168.1.11
if [ $# -ge 1 ]; then
    _host=$1
fi

## test trust by remote hosts
#if [ $# -le 0 ]; then
#    test_ssh_remote_trust;
#fi

## test
## enable trusting on this local host by remote hosts
## run multi-tasks concurrently
test_ssh_remote_trust_concur 20

## test check and install COMMAND on remote host
test_ssh_remote_check_install ${_host} mysql
test_ssh_remote_check_install ${_host} redis-cli redis
