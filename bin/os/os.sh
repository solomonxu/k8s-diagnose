#!/usr/bin/bash

## Include shells
. ./common/logger.sh
. ./common/ssh.sh

## Get OS full of remote host
function os_get_remote_os_full()
{
#    if [ $# -lt 1 ]; then
#        logger_warn "Call os_get_remote_os_full, but lack of argument host."
#        return 1
#    fi
    host=$1
#	logger_debug "Call os_get_remote_os_full ${host}."
    ssh_remote_exec "${host}" "uname -a"
}

## Get OS version of remote host
function os_get_remote_os_ver()
{
#    if [ $# -lt 1 ]; then
#        logger_warn "Call os_get_remote_os_ver, but lack of argument host."
#        return 1
#    fi
    host=$1
#    logger_debug "Call os_get_remote_os_ver ${host}."
    ssh_remote_exec "${host}" "uname -v"
}

## Get OS name of remote host
function os_get_remote_os_name()
{
	host=$1
    ssh_remote_exec "${host}" "uname"
}

## Get host name of remote host
function os_get_remote_host_name()
{
	host=$1
    ssh_remote_exec "${host}" "hostname -s"
}

## Get host name of remote host
function os_get_remote_host_fullname()
{
	host=$1
    ssh_remote_exec "${host}" "hostname -f"
}

## Run systemctl status 
function os_systemctl_status()
{
	host=$1
	service=$2
    ssh_remote_exec "${host}" "systemctl status -l '${service}'"
}

## Run systemctl start 
function os_systemctl_start()
{
	host=$1
	service=$2
    ssh_remote_exec "${host}" "systemctl start '${service}'"
}

## Run systemctl stop 
function os_systemctl_stop()
{
	host=$1
	service=$2
    ssh_remote_exec "${host}" "systemctl stop '${service}'"
}

## Run systemctl restart 
function os_systemctl_restart()
{
	host=$1
	service=$2
    ssh_remote_exec "${host}" "systemctl restart '${service}'"
}

## Run dmesg 
function os_dmesg()
{
	host=$1
    ssh_remote_exec "${host}" "dmesg -T"
}

## Run dmesg by service
function os_dmesg_service()
{
	host=$1
	service=$2
    ssh_remote_exec "${host}" "dmesg -T '${service}'"
}

## Run top
function os_top()
{
	host=$1
    ssh_remote_exec "${host}" "top -b -n 1"
}

## Run ps -ef 
function os_ps()
{
	host=$1
    ssh_remote_exec "${host}" "ps -ef"
}

## Run df
function os_df()
{
	host=$1
    ssh_remote_exec "${host}" "df -a"
}

## Run ip a
function os_ip_a()
{
	host=$1
    ssh_remote_exec "${host}" "ip a"
}

## Run lsof -p PID
function os_lsof_pid()
{
	host=$1
	pid=$2
    ssh_remote_exec "${host}" "lsof -p ${pid}"
}

## Run cat file
function os_cat_file()
{
	_host=$1
	_file=$2
    ssh_remote_exec "${_host}" "if [ -f \"${_file}\" ]; then cat ${_file}; else echo 'No such file'; fi"
}

