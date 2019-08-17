#!/usr/bin/expect

## set time out
set timeout 10

## get arguments
set SSH_HOST [lindex $argv 0]
set SSH_USER [lindex $argv 1]
set SSH_PASS [lindex $argv 2]
set ID_RSA_FILE [lindex $argv 3]
set PARAM_SSH_PORT [lindex $argv 4]

## copy public rsa-key to remote host
spawn ssh-copy-id -f ${PARAM_SSH_PORT} ${SSH_USER}@${SSH_HOST}
#spawn ssh-copy-id -f -i ${ID_RSA_FILE} ${PARAM_SSH_PORT} ${SSH_USER}@${SSH_HOST}
expect {
   # first connect, no public key in ~/.ssh/known_hosts
   # "Are you sure you want to continue connecting (yes/no)?"
   "**(yes/no)?" {
	  send "yes\r"
	  expect "password:"
	  send "${SSH_PASS}\r"
   }
   # already has public key in ~/.ssh/known_hosts
   "**password:" {
	  send "${SSH_PASS}\r"
   }
   # it has authorized, do nothing!
   "Now try logging into the machine" {
   }
}
expect eof