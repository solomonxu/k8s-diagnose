#!/usr/bin/bash

## Include shells
. ./common/logger.sh
. ./common/subtask.sh

## 
chmod a+x ../conf/diag.conf
CONFIG_FILE=../conf/diag.conf
HOSTS_AUTH_FILE=../conf/hosts-auth.txt
. ../conf/diag.conf

## 
ID_RSA_FILE="~/.ssh/id_rsa.pub"
SSH_PORT_DEFAULT=22
	
## generate rsa-key locally
function ssh_gen_rsakey()
{
    ## check if rsa-key existed in $HOME of this user 
    if [ -n ${ID_RSA_FILE} ]; then
        logger_info "rsa key ${ID_RSA_FILE} has existed in local host."
        return;
    fi
    ## generate local rsa-key
    logger_info "Generate rsa-key for user ${USER} now."
    ssh-keygen -t rsa;
}


## install COMMAND on this local host
function ssh_local_install()
{
    if [ $# -lt 1 ]; then
        logger_warn "Call ssh_local_install, but lack of arguments: program and package."
        return 1
    fi
    _package=$1
	_os=$2
    logger_info "Call ssh_local_install ${_package}."
    ret_value=$(yum install -y ${_package})
}

## check and install COMMAND on this local  host
function ssh_local_check_install()
{
    if [ $# -lt 1 ]; then
        logger_warn "Call ssh_local_check_install, but lack of arguments: program and package."
        return 1
    fi
    _program=$1
    _package=$2
	_os=$3
    _package=${_package:-${_program}}
    _ret=$(which "${_program}" | wc -l)
    if [ "${_ret}" != "1" ]; then
        logger_warn "Call ssh_local_check_install, Package ${_package} not installed on this host. Installing now."
        ssh_local_install ${_package} ${_os}
        return
    fi
    ret_value="OK"
    return 0
}

## install COMMAND on remote host
function ssh_remote_install()
{
    if [ $# -lt 2 ]; then
        logger_warn "Call ssh_remote_install, but lack of arguments: host or package."
        return 1
    fi
    _host=$1
    _package=$2
	_os=$3
    _command="yum install -y ${_package}"
    logger_info "Call ssh_remote_install ${_host} ${_package}."
    ret_value=$(ssh ${_host} -f "${_command}")
}

## check and install COMMAND on remote host
function ssh_remote_check_install()
{
    if [ $# -lt 2 ]; then
        logger_warn "Call ssh_remote_check_install, but lack of arguments: host or package."
        return 1
    fi
    _host=$1
    _program=$2
    _package=$3
    _package=${_package:-$_program}
	_os=$4
    _command="which ${_program} | wc -l"
    _ret=$(ssh ${_host} "${_command}")
    if [ "${_ret}" != "1" ]; then
        logger_warn "Call ssh_remote_check_install, Package ${_package} not installed on host ${_host}. Installing now."
        ssh_remote_install ${_host}  ${_package}  ${_os}
        return
    fi
    ret_value="OK"
    return 0
}

## check and install expect (Obsolete)
function ssh_check_install_expect()
{
    ## check and install expect
    _expect_cmd=$(which expect)
    logger_debug _expect_cmd=${_expect_cmd}
    if [ -z "${_expect_cmd}" ]; then
        logger_info "expect not installed on this host. Start to install expect now..."
        yum install -y expect
    fi
}

## enable trusting on this local host by remote hosts
function ssh_remote_trust()
{
    ## generate rsa-key locally
    ssh_gen_rsakey;
    ## check and install packages
    ssh_local_check_install "expect" "expect"
    ssh_local_check_install "ssh-copy-id" "openssh-clients"

    ## get ssh default params
    ssh_default=$(cat ${HOSTS_AUTH_FILE} | grep default)
    ssh_default_user=$(echo ${ssh_default} | awk '{print $2}')
    ssh_default_pass=$(echo ${ssh_default} | awk '{print $3}')
    ssh_default_port=$(echo ${ssh_default} | awk '{print $4}')
    ssh_default_user=${ssh_default_user:-root}
    ssh_default_port=${ssh_default_port:-${SSH_PORT_DEFAULT}}
	
    ## echo and log default ssh connect's params
    logger_debug "ssh_default=${ssh_default}"
    logger_debug "ssh_default_pass=${ssh_default_pass}"
    logger_info  "ssh_default_user=${ssh_default_user}, ssh_default_pass=***, ssh_default_port=${ssh_default_port}"

    ## loop for hosts list
    _count=0
    _hosts_auth=$(cat ${HOSTS_AUTH_FILE} | grep -v "default" | grep -v "\[" | grep -v "\]" | grep -v "#" | awk 'BEGIN{OFS=","}{if($1!=""){print $1,$2,$3,$4}}')
    logger_debug "_hosts_auth=${_hosts_auth}"
    for _host_line in ${_hosts_auth}; do
        if [ -z "${_host_line}" ]; then
            logger_warn "empty host"
            continue;
        fi
        _count=$(expr $_count + 1)
        logger_info "remote host No. ${_count}:"
        logger_info "--------------------------"
        ## get ssh connect's params from file line
        SSH_HOST=$(echo ${_host_line} | awk -F, '{print $1}')
        SSH_USER=$(echo ${_host_line} | awk -F, '{print $2}')
        SSH_PASS=$(echo ${_host_line} | awk -F, '{print $3}')
        SSH_PORT=$(echo ${_host_line} | awk -F, '{print $4}')
        if [ -z "${SSH_HOST}" ]; then
            logger_warn "SSH_HOST is empty, omit it and continue."
            continue;
        fi
        ## if ssh connect's params is empty, then set to default values
        SSH_USER=${SSH_USER:-$ssh_default_user}
        SSH_PASS=${SSH_PASS:-$ssh_default_pass}
        SSH_PORT=${SSH_PORT:-$ssh_default_port}
        PARAM_SSH_PORT="-p ${SSH_PORT}"

        ## echo and log final ssh connect's params
        logger_info "SSH_HOST=${SSH_HOST}, SSH_USER=${SSH_USER}, SSH_PASS=***, SSH_PORT=${SSH_PORT}, PARAM_SSH_PORT=${PARAM_SSH_PORT}"
        logger_debug "SSH_PASS=${SSH_PASS}"

        ## non-interactive, copy public rsa-key to remote host
        ./common/expect-ssh-copy-id.sh ${SSH_HOST} ${SSH_USER} "${SSH_PASS}" "${PARAM_SSH_PORT}"
    done;
    logger_info "${_hosts_count} remote hosts have try to trust on this host. All done."
}

## enable trusting on this local host by remote hosts
## run multi-tasks concurrently
function ssh_remote_trust_concur()
{
    ## get count of subtasks
    _subtasks_count=5
    _arg1=$(echo "$1" | awk '{print int($1)}')
    if [ ${_arg1} -ge 1 ]; then
        _subtasks_count=${_arg1}
    fi

    ## generate rsa-key locally
    ssh_gen_rsakey;
    ## check and install packages
    ssh_local_check_install "ssh-copy-id" "openssh-clients"
    ssh_local_check_install "sshpass" "sshpass"

    ## get ssh default params
    ssh_default=$(cat ${HOSTS_AUTH_FILE} | grep default)
    ssh_default_user=$(echo ${ssh_default} | awk '{print $2}')
    ssh_default_pass=$(echo ${ssh_default} | awk '{print $3}')
    ssh_default_port=$(echo ${ssh_default} | awk '{print $4}')
    ssh_default_user=${ssh_default_user:-root}
    ssh_default_port=${ssh_default_port:-22}

    ## echo and log default ssh connect's params
    logger_debug "ssh_default=${ssh_default}"
    logger_debug "ssh_default_pass=${ssh_default_pass}"
    logger_info  "ssh_default_user=${ssh_default_user}, ssh_default_pass=***, ssh_default_port=${ssh_default_port}"
	
    ## purify hosts list
    _hosts_auth=$(cat ${HOSTS_AUTH_FILE} | grep -v "default" | grep -v "\[" | grep -v "\]" | grep -v "#" | awk 'BEGIN{OFS=","}{if($1!=""){print $1,$2,$3,$4}}')
	
    ## calculate subtasks information
    _hosts_count=$(echo "${_hosts_auth}" | wc -l)
    _hosts_per_task=$[_hosts_count/_subtasks_count+1]
    _hosts_left="${_hosts_auth}"
    logger_info "run remote trust with mutli-subtasks concurrently. _hosts_count=${_hosts_count}, _subtasks_count=${_subtasks_count}, _hosts_per_task=${_hosts_per_task}."

    ## divide hosts_auth into several set of subtasks
    for ((_task_id=1; _task_id<=${_subtasks_count}; _task_id++)); do
        _hosts_slice=$(echo "${_hosts_left}" | head -n ${_hosts_per_task})
        _count_in_slice=$(echo "${_hosts_slice}" | wc -l)
		_hosts_slice=$(echo "${_hosts_slice}" | awk 'BEGIN{FS=","; OFS=","; ORS="##"} {{print $1,$2,$3,$4}}')
        ./common/subtask.sh "${SUBTASK_REMOTE_TRUST}" "${_task_id}" "${_hosts_slice}" &
        _subtask_pid=$!
        _hosts_left=$(echo "${_hosts_left}" | tail -n +$[_hosts_per_task+1])
        logger_info "subtask ${SUBTASK_REMOTE_TRUST} [no.${_task_id}, pid=${_subtask_pid}] forked, assigned ${_count_in_slice} hosts."
		## wait 0.2 seconds and delay next subtask
		sleep 0.2
	done;
    
    ## wait until all subtasks finished or wait-time reached.
    _wait_seconds=2
	for _times in [1..$[_hosts_count/_wait_seconds]]; do
        sleep ${_wait_seconds}
        _subtask_alive=$(ps -ef | grep "subtask.sh" | grep "${SUBTASK_REMOTE_TRUST}" | grep $$ | wc -l)
        if [ ${_subtask_alive} -le 0 ]; then
            break;
        fi 
	done
    logger_info "${_hosts_count} remote hosts have try to trust on this host. All done."
}

## execute COMMAND on remote host
function ssh_remote_exec()
{
    if [ $# -lt 2 ]; then
        logger_warn "Call ssh_remote_exec, but lack of arguments: host and command."
        return 1
    fi
    _host=$1
    _command=$2
    logger_debug "Call ssh_remote_exec ${_host} '${_command}'."
    ret_value=$(ssh ${_host} -f "${_command}")
}

## execute COMMAND on remote host with tty
function ssh_remote_exec_option()
{
    if [ $# -lt 2 ]; then
        logger_warn "Call ssh_remote_exec, but lack of arguments: host and command."
        return 1
    fi
    _host=$1
    _command=$2
	_option=$3
    logger_debug "Call ssh_remote_exec_option ${_host} '${_command}' '${_option}'."
    ret_value=$(ssh ${_option} ${_host} "${_command}")
}

## trusted by remote hosts
#ssh_remote_trust;