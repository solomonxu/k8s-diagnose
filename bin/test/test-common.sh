#!/usr/bin/bash

## read config and included shells
chmod a+x ../conf/diag.conf
. ../conf/diag.conf
. ./common/email.sh
. ./common/ssh.sh


## test notify recipients
test_email_notify(){
    echo "TODO: call test_email_notify"
    message_subject="K8s diagnose report"
    message_body="`date` Hosts list"
    message_attachment="/etc/hosts"
    notify;
}

## test ssh trust by remote hosts
test_ssh_remote_trust(){
    echo "TODO: call test_ssh_remote_trust"
    ssh_remote_trust;
}

## test notify recipients
#test_email_notify;

## trust by remote hosts
ssh_remote_trust;
