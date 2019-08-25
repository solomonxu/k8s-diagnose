#!/usr/bin/bash

## include shells
. ./common/logger.sh
. ./k8s/kubectl.sh

## test Get k8s nodes in remote host
function test_kubectl_get_nodes(){
    logger_info "TEST: call kubectl_get_nodes $@"	
    kubectl_get_nodes $@
    list=${ret_value}
    count=$(echo ${list} | wc -l)
    logger_info "TEST: k8s nodes count are: ${count}"
    logger_info "TEST: k8s nodes are: ${list}"
}

## test Get k8s pods in remote host
function test_kubectl_get_pods(){
    logger_info "TEST: call kubectl_get_pods $@"	
    kubectl_get_pods $@
    list=${ret_value}
    count=$(echo ${list} | wc -l)
    logger_info "TEST: k8s pods count is: ${count}"
}

## test Get k8s pods in remote host
function test_kubectl_get_pods_all_ns(){
    logger_info "TEST: call kubectl_get_pods_all_ns $@"	
    kubectl_get_pods_all_ns $@
    list=${ret_value}
    count=$(echo ${list} | wc -l)
    logger_info "TEST: k8s pods count is: ${count}"
}

## test Get k8s namespaces in remote host
function test_kubectl_get_namespaces(){
    logger_info "TEST: call kubectl_get_namespaces $@"	
    kubectl_get_namespaces $@
    list=${ret_value}
    count=$(echo ${list} | wc -l)
    logger_info "TEST: k8s namespaces count is: ${count}"
    logger_info "TEST: k8s namespaces are: ${list}"
}

## test Get k8s services in remote host
function test_kubectl_get_services(){
    logger_info "TEST: call kubectl_get_services $@"	
    kubectl_get_services $@
    list=${ret_value}
    count=$(echo ${list} | wc -l)
    logger_info "TEST: k8s services count is: ${count}"
    logger_info "TEST: k8s services are: ${list}"
}

## test Get k8s services in remote host
function test_kubectl_get_services_all_ns(){
    logger_info "TEST: call kubectl_get_services_all_ns $@"	
    kubectl_get_services_all_ns $@
    list=${ret_value}
    count=$(echo ${list} | wc -l)
    logger_info "TEST: k8s services count is: ${count}"
    logger_info "TEST: k8s services are: ${list}"
}

## test Get k8s api resources types in remote host
function test_kubectl_api_resources(){
    logger_info "TEST: call kubectl_api_resources $@"	
    kubectl_api_resources $@
    list=${ret_value}
    count=$(echo ${list} | wc -l)
    logger_info "TEST: k8s api-resources type count is: ${count}"
    logger_info "TEST: k8s api-resources type are: ${list}"
}

## test Get k8s resources in remote host
function test_kubectl_get_resources(){
    logger_info "TEST: call kubectl_get_resources $@"	
    kubectl_get_resources $@
    list=${ret_value}
    count=$(echo ${list} | wc -l)
    logger_info "TEST: k8s resources count is: ${count}"
    logger_info "TEST: k8s resources are: ${list}"
}

## test Get k8s resources in remote host
function test_kubectl_get_resources_all_ns(){
    logger_info "TEST: call kubectl_get_resources_all_ns $@"	
    kubectl_get_resources_all_ns $@
    list=${ret_value}
    count=$(echo ${list} | wc -l)
    logger_info "TEST: k8s resources count is: ${count}"
    logger_info "TEST: k8s resources are: ${list}"
}

## test Get k8s pod log in remote host
function test_kubectl_log_pod(){
    logger_info "TEST: call kubectl_log_pod $@"	
    kubectl_log_pod $@
    list=${ret_value}
    count=$(echo ${list} | wc -l)
    logger_info "TEST: k8s logs are: ${list}"
}

## test Get k8s resource yaml in remote host
function test_kubectl_get_resource_yaml(){
    logger_info "TEST: call kubectl_get_resource_yaml $@"	
    kubectl_get_resource_yaml $@
    list=${ret_value}
    count=$(echo ${list} | wc -l)
    logger_info "TEST: k8s resource yaml is: ${list}"
}

## test Get k8s resource json in remote host
function test_kubectl_get_resource_json(){
    logger_info "TEST: call kubectl_get_resource_json $@"	
    kubectl_get_resource_json $@
    list=${ret_value}
    count=$(echo ${list} | wc -l)
    logger_info "TEST: k8s resource json is: ${list}"
}


## get host
host=192.168.1.12
if [ $# -ge 1 ]; then
    host=$1
fi 

logger_info "TEST: kubectl, host=${host}"

## test Get k8s nodes in remote host
test_kubectl_get_nodes ${host}

## test Get k8s pods in remote host
test_kubectl_get_pods ${host} kube-system

## test Get k8s pods in remote host
test_kubectl_get_pods_all_ns ${host}

## test Get k8s namespaces in remote host
test_kubectl_get_namespaces ${host}

## test Get k8s services in remote host
test_kubectl_get_services ${host} kube-system
## test Get k8s services in remote host
test_kubectl_get_services_all_ns ${host}

## test Get k8s api resources types in remote host
test_kubectl_api_resources ${host} 

## test Get k8s resources in remote host
test_kubectl_get_resources ${host} kube-system daemonset
## test Get k8s resources in remote host
test_kubectl_get_resources_all_ns ${host} daemonset

## test k8s pod log in remote host
#test_kubectl_log_pod ${host} kube-system kube-apiserver-dev-7

## test Get k8s resource yaml in remote host
test_kubectl_get_resource_yaml ${host} kube-system deployment kubernetes-dashboard
## test Get k8s resource json in remote host
test_kubectl_get_resource_json ${host} kube-system deployment kubernetes-dashboard
