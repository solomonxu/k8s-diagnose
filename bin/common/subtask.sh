#!/usr/bin/bash

## Include shells
. ./common/logger.sh

## Define constants
ID_RSA_FILE="~/.ssh/id_rsa.pub"
SUBTASK_REMOTE_TRUST="REMOTE_TRUST"
SSH_PORT_DEFAULT=22

## enable trusting on this local host by remote hosts
## subtask called by parent shell
function subtask_remote_trust()
{
    ## get hosts list from argument and purify
    _subtask_id=$1
	shift
    _hosts_auth=$(echo "$@" | awk 'BEGIN{FS=","; RS="##"; OFS=","; ORS="   "} {if($1!=""){print $1,$2,$3,$4}}')
    logger_debug _hosts_auth="${_hosts_auth}"
	
    ## get ssh default params
    ssh_default_user=${ssh_default_user:-root}
    ssh_default_port=${ssh_default_port:-22}
	
    ## loop for hosts list
    _count=0
    for _host_line in ${_hosts_auth}; do
        if [ -z "${_host_line}" ]; then
            logger_warn "empty host"
            continue;
        fi
        _count=$[_count + 1]
        logger_info "subtask [${_subtask_id}] remote host No. ${_count}:"
        logger_info "----------------------------------------"
        logger_debug _host_line="${_host_line}"
        ## parse ssh connect's params from line
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
		sshpass -p "${SSH_PASS}" ssh-copy-id -o StrictHostKeyChecking=no -o ConnectTimeout=3 "${SSH_USER}"@"${SSH_HOST}"
    done;
}

## entry point of the shell
_subtask=$1
#logger_debug _subtask=${_subtask}
case "${_subtask}" in
    "${SUBTASK_REMOTE_TRUST}")
        shift
        subtask_remote_trust $@
    ;;
    *)
#        logger_warn "Call shell subtask.sh, but no argument for subtask name."
    ;;
esac




