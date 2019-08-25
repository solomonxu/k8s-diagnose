#!/usr/bin/bash

## Include shells
. ./common/logger.sh
. ./common/ssh.sh

## Login to mysql database via remote host
function mysql_login()
{
	_host=$1
	_db_url=$2
	_db_port=$3
	_db_user=$4
	_db_password=$5
	_db_name=$6
    ssh_remote_exec "${_host}" "mysql --host=${_db_url} --port=${_db_port} --user=${_db_user} --password=${_db_password} --database=${_db_name}"
}

## Login to mysql database via remote host
function mysql_login_envs()
{
	_host=$1
    ssh_remote_exec "${_host}" "${DB_CONN} mysql --host=\${DB_URL} --port=\${DB_PORT} --user=\${DB_USER} --password=\${DB_PASSWORD}"
}

## Execute SQL in mysql database via remote host
function mysql_exec_sql_envs()
{
	_host=$1
	shift
	_sql="$@ ;"
    ssh_remote_exec "${_host}" "${DB_CONN} mysql --host=\${DB_URL} --port=\${DB_PORT} --user=\${DB_USER} --password=\${DB_PASSWORD} --execute='${_sql}'"
}

## Show databases in mysql database via remote host
function mysql_show_databases()
{
	_host=$1
	_sql="show databases;"
	mysql_exec_sql_envs "${_host}" "${_sql}" 
    echo "${ret_value}"
}
