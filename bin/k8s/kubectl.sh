#!/usr/bin/bash

## Include shells
. ./common/logger.sh
. ./common/ssh.sh

## Define columns of command output
COL_K8S_NODES="NAME STATUS ROLES AGE VERSION INTERNAL-IP EXTERNAL-IP OS-IMAGE KERNEL-VERSION CONTAINER-RUNTIME"
COL_K8S_NAMESPACES="NAME STATUS AGE"
COL_K8S_PODS="NAME READY STATUS RESTARTS AGE IP NODE NOMINATED NODE READINESS GATES"
COL_K8S_PODS_ALL_NS="NAMESPACE ${COL_K8S_PODS}"
COL_K8S_SERVICES="NAME TYPE CLUSTER-IP EXTERNAL-IP PORT(S) AGE SELECTOR"
COL_K8S_SERVICES_ALL_NS="NAMESPACE ${COL_K8S_SERVICES}"
COL_K8S_API_RESOURCES="NAME SHORTNAMES APIGROUP NAMESPACED KIND"
COL_K8S_RESOURCES="NAME DESIRED CURRENT READY UP-TO-DATE AVAILABLE NODE SELECTOR AGE"
COL_K8S_RESOURCES_ALL_NS="NAMESPACE ${COL_K8S_RESOURCES}"

## Get k8s nodes in remote host
function kubectl_get_nodes()
{
    columns=$COL_K8S_NODES
	host=$1
	ssh_remote_exec "${host}" "kubectl get nodes -o wide"
}

## Get k8s pods in remote host
function kubectl_get_pods_all_ns()
{
    columns=$COL_K8S_PODS_ALL_NS
	host=$1
    ssh_remote_exec "${host}" "kubectl get pods -o wide --all-namespaces"
}

## Get k8s pods in remote host
function kubectl_get_pods()
{
    columns=$COL_K8S_PODS
	host=$1
	ns=$2
    ssh_remote_exec "${host}" "kubectl -n ${ns} get pods -o wide"
}

## Get k8s namespaces in remote host
function kubectl_get_namespaces()
{
    columns=$COL_K8S_NAMESPACES
	host=$1
    ssh_remote_exec "${host}" "kubectl get namespaces -o wide"
}

## Get k8s services in remote host
function kubectl_get_services_all_ns()
{
    columns=$COL_K8S_SERVICES_ALL_NS
	host=$1
    ssh_remote_exec "${host}" "kubectl get services -o wide --all-namespaces"
}

## Get k8s services in remote host
function kubectl_get_services()
{
    columns=$COL_K8S_SERVICES
	host=$1
	ns=$2
    ssh_remote_exec "${host}" "kubectl -n ${ns} get services -o wide"
}

## Get k8s api-resources types in remote host
function kubectl_api_resources()
{
    columns=$COL_K8S_API_RESOURCES
    host=$1
	ssh_remote_exec "${host}" "kubectl api-resources"
}

## Get k8s resources in remote host
function kubectl_get_resources_all_ns()
{
    columns=$COL_K8S_RESOURCES_ALL_NS
    host=$1
    resource_type=$2
	ssh_remote_exec "${host}" "kubectl get ${resource_type} -o wide --all-namespaces"
}

## Get k8s resources in remote host
function kubectl_get_resources()
{
    columns=$COL_K8S_RESOURCES
    host=$1
    ns=$2
    resource_type=$3
	ssh_remote_exec "${host}" "kubectl -n ${ns} get ${resource_type}"
}

## Get k8s resource yaml in remote host
function kubectl_get_resource_yaml()
{
    host=$1
    ns=$2
    resource_type=$3
    resource_name=$4
	ssh_remote_exec "${host}" "kubectl -n ${ns} get ${resource_type} ${resource_name} -o yaml"
}

## Get k8s pod log in remote host
function kubectl_log_pod()
{
    host=$1
    ns=$2
    pod=$3
    container=$4
    if [ -n "${container}" ]; then
        container_arg="-c ${container}"
    fi
    ssh_remote_exec "${host}" "kubectl -n '${ns}' logs '${pod}' ${container_arg}"
}

## Get k8s resource json in remote host
function kubectl_get_resource_json()
{
    host=$1
    ns=$2
    resource_type=$3
    resource_name=$4
	ssh_remote_exec "${host}" "kubectl -n ${ns} get ${resource_type} ${resource_name} -o json"
}
