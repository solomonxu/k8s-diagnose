#!/usr/bin/bash

echo `date`

## read config and included shells
. ../conf/diag.conf
. ./common.sh

## notify receivers
message_subject="No message subject..."
message_body="No message body..."
message_attachment=""
notify

#notify "No message subject..." "No message body..." ""
