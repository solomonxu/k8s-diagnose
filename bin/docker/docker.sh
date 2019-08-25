#!/usr/bin/bash

## Include shells
. ./common/logger.sh
. ./common/ssh.sh

## Get docker containers from remote host
function docker_get_containers()
{
	host=$1
    ssh_remote_exec "${host}" "docker ps -a"
}

## Get docker images from remote host
function docker_get_images()
{
	host=$1
    ssh_remote_exec "${host}" "docker images -a"
}

## Exec docker command in container of remote host
function docker_exec()
{
	host=$1
	container=$2
	command=$3
    ssh_remote_exec_option "${host}" "docker exec -it ${container} ${command}" "-t -t"
}
