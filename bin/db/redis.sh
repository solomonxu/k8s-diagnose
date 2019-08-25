#!/usr/bin/bash

## Include shells
. ./common/logger.sh
. ./common/ssh.sh

## Login to Redis via remote host
function redis_login()
{
	_host=$1
	_redis_url=$2
	_redis_port=$3
	_redis_password=$4
    ssh_remote_exec "${_host}" "redis-cli -h ${_redis_url} -p ${_redis_port} -a ${_redis_password}"
}

## Login to Redis via remote host
function redis_login_envs()
{
	_host=$1
    ssh_remote_exec "${_host}" "${REDIS_CONN} redis-cli -h \${REDIS_URL} -p \${REDIS_PORT} -a \${REDIS_PWD} "
}

## Execute command in Redis via remote host
function redis_exec_command_envs()
{
	_host=$1
	shift
	_cmd="$@ "
    ssh_remote_exec "${_host}" "${REDIS_CONN} redis-cli -h \${REDIS_URL} -p \${REDIS_PORT} -a \${REDIS_PWD} ${_cmd} "
}

## Execute command info in Redis via remote host
function redis_info()
{
	_host=$1
	shift
	_cmd="info"
	redis_exec_command_envs "${_host}" ${_cmd}
}
