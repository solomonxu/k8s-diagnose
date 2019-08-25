#!/usr/bin/bash

## include shells
. ./common/logger.sh
. ./db/etcd.sh

## test Execute command in etcd via remote host
function test_etcd_exec_command_envs(){
    logger_info "TEST: call etcd_exec_command_envs $@"	
    etcd_exec_command_envs $@
    _list=${ret_value}
    _count=$(echo ${_list} | wc -l)
    logger_info "TEST: exec etcd command's result is: ${_list}"
}

## Execute command db/get in etcd via remote host
function test_etcd_db_get(){
    logger_info "TEST: call etcd_db_get $@"	
    etcd_db_get $@
    _list=${ret_value}
    _count=$(echo ${_list} | wc -l)
    logger_info "TEST: exec etcd db/get command's result is: ${_list}"
}

## Execute Execute command db/set in etcd via remote host
function test_etcd_db_set(){
    logger_info "TEST: call etcd_db_set $@"	
    etcd_db_set $@
    _list=${ret_value}
    _count=$(echo ${_list} | wc -l)
    logger_info "TEST: exec etcd db/set command's result is: ${_list}"
}


## get host
_host=192.168.1.11
if [ $# -ge 1 ]; then
    _host=$1
fi

logger_info "TEST: etcd, host=${_host}"

## set etcd connection's parameters
ETCD_CONN="ETCD=http://192.168.1.11:2379"

## test Execute command in etcd via remote host
test_etcd_exec_command_envs ${_host} set /test-dir-solomon/testkey "Hello world"

## Execute command db/get in etcd via remote host
test_etcd_db_get ${_host} /test-dir-solomon/testkey

## Execute Execute command db/set in etcd via remote host
test_etcd_db_set ${_host} /test-dir-solomon/testkey1 "Hello world 1"

## Execute command db/get in etcd via remote host
test_etcd_db_get ${_host} /test-dir-solomon/testkey1
