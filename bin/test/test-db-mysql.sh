#!/usr/bin/bash

## include shells
. ./common/logger.sh
. ./db/mysql.sh

## test Login to mysql database via remote host
function test_mysql_login(){
    logger_info "TEST: call mysql_login $@"	
    mysql_login $@
    list=${ret_value}
    count=$(echo ${list} | wc -l)
    logger_info "TEST: login to mysql are: ${list}"
}

## test Login to mysql database via remote host
function test_mysql_login_envs(){
    logger_info "TEST: call mysql_login $@"	
    mysql_login $@
    list=${ret_value}
    count=$(echo ${list} | wc -l)
    logger_info "TEST: login to mysql are: ${list}"
}

## test Execute SQL in mysql database via remote host
function test_mysql_exec_sql(){
    logger_info "TEST: call mysql_exec_sql $@"	
    mysql_exec_sql $@
    list=${ret_value}
    count=$(echo ${list} | wc -l)
    logger_info "TEST: exec SQL's result is: ${list}"
}

## test Execute SQL in mysql database via remote host
function test_mysql_exec_sql_envs(){
    logger_info "TEST: call mysql_exec_sql_envs $@"	
    mysql_exec_sql_envs $@
    list=${ret_value}
    count=$(echo ${list} | wc -l)
    logger_info "TEST: exec SQL's result is: ${list}"
}

## test Show databases in mysql database via remote host
function test_mysql_show_databases(){
    logger_info "TEST: call mysql_show_databases $@"	
    mysql_show_databases $@
    _list=${ret_value}
    _count=$(echo ${_list} | wc -l)
    logger_info "TEST: count of databases is: ${_count}"
    logger_info "TEST: exec SQL's result is: ${_list}"
}


## get host
_host=192.168.1.11
if [ $# -ge 1 ]; then
    _host=$1
fi

logger_info "TEST: mysql, host=${_host}"

## test Login to mysql database via remote host
test_mysql_login ${_host} 192.168.1.13 3307 root *** ***

## test Login to mysql database via remote host
DB_CONN="DB_URL=192.168.1.13; DB_PORT=3307; DB_USER=root; DB_PASSWORD=***; DB_NAME=***;"
test_mysql_login_envs ${_host}

## test Execute SQL in mysql database via remote host
#test_mysql_exec_sql ${_host} "show databases;"

## test Show databases in mysql database via remote host
test_mysql_show_databases ${_host}

