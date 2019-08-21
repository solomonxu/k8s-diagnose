#!/usr/bin/bash

## include shells
. ./common/logger.sh
. ./common/email.sh

## read config and included shells
chmod a+x ../conf/diag.conf
. ../conf/diag.conf

## test notify to recipients
test_email_notify(){
    logger_info "TEST: call test_email_notify"
    message_subject="K8s diagnose report"
    message_body="`date` Hosts list"
    message_attachment="/etc/hosts"
    notify;
}

## test notify recipients
test_email_notify;
