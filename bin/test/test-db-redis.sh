#!/usr/bin/bash

## include shells
. ./common/logger.sh
. ./db/redis.sh

## test Login to Redis via remote host
function test_redis_login(){
    logger_info "TEST: call redis_login $@"	
    redis_login $@
    _list=${ret_value}
    _count=$(echo ${_list} | wc -l)
    logger_info "TEST: login to redis are: ${_list}"
}

## test Login to Redis via remote host
function test_redis_login_envs(){
    logger_info "TEST: call redis_login_envs $@"	
    redis_login_envs $@
    _list=${ret_value}
    _count=$(echo ${_list} | wc -l)
    logger_info "TEST: login to redis are: ${_list}"
}

## test Execute command in Redis via remote host
function test_redis_exec_command_envs(){
    logger_info "TEST: call redis_exec_command_envs $@"	
    redis_exec_command_envs $@
    _list=${ret_value}
    _count=$(echo ${_list} | wc -l)
    logger_info "TEST: exec redis command's result is: ${_list}"
}

## test Execute command info in Redis via remote host
function test_redis_info(){
    logger_info "TEST: call redis_info $@"
    redis_info $@
    _list=${ret_value}
    _count=$(echo ${_list} | wc -l)
    logger_info "TEST: exec command info's result is:" "${_list}"
    echo "${_list}"
}


## get host
_host=192.168.1.11
if [ $# -ge 1 ]; then
    _host=$1
fi

logger_info "TEST: redis, host=${_host}"

## test Login to Redis via remote host
test_redis_login ${_host} 192.168.1.13 6379 ***

## set redis connection's parameters
REDIS_CONN="REDIS_URL=192.168.1.13; REDIS_PORT=6379; REDIS_PWD=***;"

## test Login to Redis via remote host
test_redis_login_envs ${_host}

## test Execute command in Redis via remote host
test_redis_exec_command_envs ${_host} "--scan --pattern '*env*'"

## test Execute command info in Redis via remote host
test_redis_info ${_host}

