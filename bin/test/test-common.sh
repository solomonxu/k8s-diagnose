#!/usr/bin/bash

## read config and included shells
chmod a+x ../conf/diag.conf
. ../conf/diag.conf
. ./common/email.sh


## test notify recipients
test_notify(){
    message_subject="K8s diagnose report"
    message_body="`date` Hosts list"
    message_attachment="/etc/hosts"

    notify;
}

## test notify recipients
test_notify;
