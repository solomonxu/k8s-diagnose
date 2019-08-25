#!/usr/bin/bash

## Include shells
. ./common/logger.sh
. ./common/ssh.sh

## Execute command in Etcd via remote host
function etcd_exec_command_envs()
{
	_host=$1
	shift
	_cmd="$@"
    ssh_remote_exec "${_host}" "${ETCD_CONN} etcdctl --endpoint \${ETCD} ${_cmd}"
}

## Execute command db/get in Etcd via remote host
function etcd_db_get()
{
	_host=$1
	_key=$2
	_cmd="get ${_key}"
	etcd_exec_command_envs "${_host}" ${_cmd}
}

## Execute command db/set in Etcd via remote host
function etcd_db_set()
{
	_host=$1
	_key=$2
	shift 2
	_value="$@"
	_cmd="set ${_key} \"${_value}\""
	etcd_exec_command_envs "${_host}" ${_cmd}
}