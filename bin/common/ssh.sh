#!/usr/bin/bash

## 
chmod a+x ../conf/diag.conf
CONFIG_FILE=../conf/diag.conf
HOSTS_AUTH_FILE=../conf/hosts-auth.txt
. ../conf/diag.conf

## 
ID_RSA_FILE="~/.ssh/id_rsa.pub"
	
## generate rsa-key locally
ssh_gen_rsakey()
{
    ## check if rsa-key existed in $HOME of this user 
    if [ -n ${ID_RSA_FILE} ]; then
        #echo "`date` rsa key ${ID_RSA_FILE} has existed in local host."
        logger_info "rsa key ${ID_RSA_FILE} has existed in local host."
        #return;
    fi
    ## generate local rsa-key
    #echo "`date` generate rsa-key for user ${USER} now."
    logger_info "Generate rsa-key for user ${USER} now."
    ssh-keygen -t rsa;
}

## check and install expect
ssh_check_expect()
{
    ## check and install expect
    expect_cmd=$(which expect)
    #echo expect_cmd=${expect_cmd}
    logger_debug expect_cmd=${expect_cmd}
    if [ -z "$expect_cmd" ]; then
        #echo "expect not installed on this host. Start to install expect now..."
        logger_info "expect not installed on this host. Start to install expect now..."
        yum install -y expect
    fi
}

## enable trusting on this local host by remote hosts
ssh_remote_trust()
{
    ## generate rsa-key locally
    ssh_gen_rsakey;
    ## check and install expect
    ssh_check_expect;

    ## get ssh default params
    ssh_default=`cat ${HOSTS_AUTH_FILE} | grep default`
    ssh_default_user=`echo ${ssh_default} | awk '{print $2}'`
    ssh_default_pass=`echo ${ssh_default} | awk '{print $3}'`
    ssh_default_port=`echo ${ssh_default} | awk '{print $4}'`
    #echo "ssh_default=${ssh_default}"
    #echo "ssh_default_user=${ssh_default_user}"
    #echo "ssh_default_pass=***"
    #echo "ssh_default_pass=${ssh_default_pass}"
    #echo "ssh_default_port=${ssh_default_port}"
	
    #logger_info "ssh_default=${ssh_default}"
    logger_info "ssh_default_user=${ssh_default_user}"
    logger_info "ssh_default_pass=***"
    #logger_info "ssh_default_pass=${ssh_default_pass}"
    logger_info "ssh_default_port=${ssh_default_port}"	
	
    ## loop for hosts list
    hosts_auth=`cat ${HOSTS_AUTH_FILE} | grep -v "default" | grep -v "\[" | grep -v "\]" | grep -v "#" | awk 'BEGIN{OFS=","}{print $1,$2,$3,$4}'`
    #echo "hosts_auth=${hosts_auth}"
    COUNT=0
    for host_line in ${hosts_auth}; do
        if [ -z "${host_line}" ]; then
            logger_warn "empty host"
            continue;
        fi
        COUNT=`expr $COUNT + 1`
        #echo "remote host No. ${COUNT}:"
        #echo "--------------------"
        logger_info "remote host No. ${COUNT}:"
        logger_info "--------------------"
        ## get ssh connect's params from file line
        #echo "host_line=${host_line}"
        #logger_info "host_line=${host_line}"
        SSH_HOST=`echo ${host_line} | awk -F, '{print $1}'`
        SSH_USER=`echo ${host_line} | awk -F, '{print $2}'`
        SSH_PASS=`echo ${host_line} | awk -F, '{print $3}'`
        SSH_PORT=`echo ${host_line} | awk -F, '{print $4}'`
        if [ -z "${SSH_HOST}" ]; then
            #echo "empty SSH_HOST"
            logger_warn "empty SSH_HOST"
            continue;
        fi
        ## if ssh connect's params is empty, then set to default values
        if [ -z "${SSH_USER}" ]; then
            SSH_USER=${ssh_default_user}
        fi
        if [ -z "${SSH_PASS}" ]; then
            SSH_PASS=${ssh_default_pass}
        fi
        if [ -z "${SSH_PORT}" ]; then
            SSH_PORT=${ssh_default_port}
        fi
        ## set port to user-defined
        if [ -n "${SSH_PORT}" ]; then
            PARAM_SSH_PORT="-p ${SSH_PORT}"            
        fi
        ## echo final ssh connect's params
        #echo "SSH_HOST=${SSH_HOST}"
        #echo "SSH_USER=${SSH_USER}"
        #echo "SSH_PASS=${SSH_PASS}"
        #echo "SSH_PASS=***"
        #echo "SSH_PORT=${SSH_PORT}"
        #echo "PARAM_SSH_PORT=${PARAM_SSH_PORT}"

        logger_info "SSH_HOST=${SSH_HOST}"
        logger_info "SSH_USER=${SSH_USER}"
        logger_info "SSH_PASS=***"
        logger_info "SSH_PORT=${SSH_PORT}"
        logger_info "PARAM_SSH_PORT=${PARAM_SSH_PORT}"
		
        #export SSH_HOST=${SSH_HOST}; SSH_USER=${SSH_USER}; SSH_PASS=${SSH_PASS}; SSH_PORT=${SSH_PORT}; PARAM_SSH_PORT=${PARAM_SSH_PORT};
        #export PARAM_SSH_PORT=${PARAM_SSH_PORT};
        ## copy public rsa-key to remote host
        #spawn ssh-copy-id -f -i ~/.ssh/id_rsa.pub ${PARAM_SSH_PORT} "${SSH_USER}"@"${SSH_HOST}"
        ./common/expect-ssh-copy-id.sh "${SSH_HOST}" "${SSH_USER}" "${SSH_PASS}" "${ID_RSA_FILE}" "${PARAM_SSH_PORT}"
    done;
    #echo "`date` All ${COUNT} remote hosts have trusted on this host."
    logger_info "All ${COUNT} remote hosts have trusted on this host."
}

## install COMMAND on remote host
ssh_remote_install()
{
    return;
}

## execute COMMAND on remote host
ssh_remote_exec()
{
    return;
}

## trusted by remote hosts
#ssh_remote_trust;