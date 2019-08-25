#!/usr/bin/bash

## include shells
. ./common/logger.sh
. ./os/os.sh

## test get os full 
function test_os_get_remote_os_full(){
    logger_info "TEST: call os_get_remote_os_full $@"	
    os_get_remote_os_full $@
    logger_info "TEST: os full is: ${ret_value}"
}

## test get os version 
function test_os_get_remote_os_ver(){
    logger_info "TEST: call os_get_remote_os_ver $@"	
    os_get_remote_os_ver $@
    logger_info "TEST: os version is: ${ret_value}"
}

## test get os name 
function test_os_get_remote_os_name(){
    logger_info "TEST: call os_get_remote_os_name $@"	
    os_get_remote_os_name $@
    logger_info "TEST: os name is: ${ret_value}"
}

## test get host name 
function test_os_get_remote_host_name(){
    logger_info "TEST: call os_get_remote_host_name $@"	
    os_get_remote_host_name $@
    logger_info "TEST: host name is: ${ret_value}"
}

## test get host full name 
function test_os_get_remote_host_fullname(){
    logger_info "TEST: call os_get_remote_host_fullname $@"	
    os_get_remote_host_fullname $@
    logger_info "TEST: host full name is: ${ret_value}"
}

## test Run systemctl status  
function test_os_systemctl_status(){
    logger_info "TEST: call os_systemctl_status $@"	
    os_systemctl_status $@
    logger_info "TEST: service $2 status: ${ret_value}"
}

## test Run systemctl start  
function test_os_systemctl_start(){
    logger_info "TEST: call os_systemctl_start $@"	
    os_systemctl_start $@
    logger_info "TEST: service $2 starting: ${ret_value}"
}

## test Run systemctl stop  
function test_os_systemctl_stop(){
    logger_info "TEST: call os_systemctl_stop $@"	
    os_systemctl_stop $@
    logger_info "TEST: service $2 stopping: ${ret_value}"
}

## test Run systemctl restart  
function test_os_systemctl_restart(){
    logger_info "TEST: call os_systemctl_restart $@"	
    os_systemctl_restart $@
    logger_info "TEST: service $2 restarting: ${ret_value}"
}

## test Run dmesg
function test_os_dmesg(){
    logger_info "TEST: call os_dmesg $@"	
    os_dmesg $@
    logger_info "TEST: dmesg is: ${ret_value}"
}

## test Run dmesg by service
function test_os_dmesg_service()
{
    logger_info "TEST: call os_dmesg_service $@"	
    os_dmesg_service $@
    logger_info "TEST: dmesg by service $2 is: ${ret_value}"
}

## test Run top
function test_os_top()
{
    logger_info "TEST: call os_top $@"	
    os_top $@
    _list="${ret_value}"
    _count=$(echo "${_list}" | wc -l)
    logger_info "TEST: count of top command is: ${_count}"
    logger_info "TEST: top processes are: "# ${ret_value}
    echo "${ret_value}"
}

## test Run ps -ef 
function test_os_ps()
{
    logger_info "TEST: call os_ps $@"	
    os_ps $@
    _list="${ret_value}"
    _count=$(echo "${_list}" | wc -l)
    logger_info "TEST: count of processes is: ${_count}"
    logger_info "TEST: processes snapshot are: " # ${ret_value}
    echo "${ret_value}"
}

## test Run df
function test_os_df()
{
    logger_info "TEST: call os_df $@"	
    os_df $@
    _list="${ret_value}"
    _count=$(echo "${_list}" | wc -l)
    logger_info "TEST: count of display filesystem is: ${_count}"
    logger_info "TEST: display filesystem: " # ${ret_value}
    echo "${ret_value}"
}

## test Run ip a
function test_os_ip_a()
{
    logger_info "TEST: call os_ip_a $@"	
    os_ip_a $@
    _list="${ret_value}"
    _count=$(echo "${_list}" | wc -l)
    logger_info "TEST: count of ip config is: ${_count}"
    logger_info "TEST: ip network config are:" # ${ret_value}
	echo "${ret_value}"
}

## test Run lsof -p PID
function test_os_lsof_pid()
{
    logger_info "TEST: call os_lsof_pid $@"	
    os_lsof_pid $@
    _list="${ret_value}"
    _count=$(echo "${_list}" | wc -l)
    logger_info "TEST: count of lsof pid is: ${_count}"
    logger_info "TEST: list of opened file descriptors are: " # "${ret_value}"
	echo "${ret_value}"
}

## test Run cat file
function test_os_cat_file()
{
    logger_info "TEST: call os_cat_file $@"	
    os_cat_file $@
    _list="${ret_value}"
    _count=$(echo "${_list}" | wc -l)
    logger_info "TEST: count of lsof pid is: ${_count}"
    logger_info "TEST: cat file ${2}:" # ${ret_value}"
    echo "${ret_value}"
}


## get host
_host=192.168.1.11
if [ $# -ge 1 ]; then
    _host=$1
fi 

logger_info "TEST: os, host=${_host}"

## test get os full 
test_os_get_remote_os_full ${_host}

## test get os version 
test_os_get_remote_os_ver ${_host}

## test get os name 
test_os_get_remote_os_name ${_host}

## test get host name 
test_os_get_remote_host_name ${_host}

## test get host full name 
test_os_get_remote_host_fullname ${_host}

## test Run systemctl status 
test_os_systemctl_status ${_host} kubelet
test_os_systemctl_status ${_host} docker

## test Run systemctl start/stop/restart 
#test_os_systemctl_stop ${_host} kubelet
#sleep 3
#test_os_systemctl_status ${_host} kubelet
#test_os_systemctl_start ${_host} kubelet
#sleep 3
#test_os_systemctl_status ${_host} kubelet
#test_os_systemctl_restart ${_host} kubelet
#sleep 3
#test_os_systemctl_status ${_host} kubelet

## test Run dmesg
test_os_dmesg ${_host}

## test Run dmesg by service
test_os_dmesg_service ${_host} kubelet

## test Run top
test_os_top ${_host}

## test Run ps -ef 
test_os_ps ${_host}

## test Run df
test_os_df ${_host}

## test Run ip a
test_os_ip_a ${host}

## test Run lsof -p PID
test_os_lsof_pid ${_host} 1

## test Run cat file
test_os_cat_file ${_host} /etc/fstab
