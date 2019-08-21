FROM centos:k8s-diag-pre

MAINTAINER solomonxu<solomonxu@163.com>
#ARG gitCommit

## Copy file for k8s-diagnose
ADD ./bin /k8s-diagnose/bin
ADD ./conf /k8s-diagnose/conf

## Add permissions of shell
RUN chmod -R a+x /k8s-diagnose/bin/

## Make dirs for supervisord
RUN mkdir -p /supervisord
RUN mkdir -p /supervisord/include
RUN mkdir -p /supervisord/logs

## Add config for supervisord
ADD ./docker/supervisord.conf /supervisord

USER root
EXPOSE 22 80 9001

## COMMAND
CMD [ "supervisord", "-c", "/supervisord/supervisord.conf" ]
