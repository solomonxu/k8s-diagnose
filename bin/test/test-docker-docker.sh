#!/usr/bin/bash

## include shells
. ./common/logger.sh
. ./docker/docker.sh


## test Get docker containers from remote host
function test_docker_get_containers(){
    logger_info "TEST: call docker_get_containers $@"	
    docker_get_containers $@
    list=${ret_value}
    count=$(echo ${list} | grep -v NAME | wc -l)
	logger_info "TEST: docker containers count are: ${count}"
    #logger_info "TEST: docker containers are: ${ret_value}"
}

## test Get docker images from remote host
function test_docker_get_images(){
    logger_info "TEST: call docker_get_images $@"	
    docker_get_images $@
    list=${ret_value}
    count=$(echo ${list} | grep -v NAME | wc -l)
	logger_info "TEST: docker images count are: ${count}"
    logger_info "TEST: docker images are: ${ret_value}"
}

## test Exec docker command in container of remote host
function test_docker_exec(){
    logger_info "TEST: call docker_exec $@"	
    docker_exec $@
    list=${ret_value}
    count=$(echo ${list} | wc -l)
	sleep 1
    logger_info "TEST: Exec docker command in container are: ${ret_value}"
}

## get host
host=192.168.1.11
if [ $# -ge 1 ]; then
    host=$1
fi 

logger_info "TEST: docker, host=${host}"

## test Get docker containers in remote host
test_docker_get_containers ${host}

## test Get docker images in remote host
test_docker_get_images ${host}

## test Exec docker command in container of remote host
test_docker_exec ${host} etcd lsof
test_docker_exec ${host} etcd ps
