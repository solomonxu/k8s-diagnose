#!/usr/bin/bash

## include shells
. ./common/logger.sh

logger_info  "TEST: logger"

## Set config
logger_set_lang "en";
logger_set_timezone 'America/Los_Angeles'

## Test
logger_debug "This is DEBUG level."
logger_info  "This is INFO level."
logger_warn  "This is WARN level."
logger_alert "This is ALERT level."
logger_fatal "This is FATAL level."
logger_fatal ""

## Set config
logger_set_lang "zh";
logger_set_timezone 'Asia/Shanghai'

## Test
logger_debug "这是 调试 级别."
logger_info  "这是 信息 级别."
logger_warn  "这是 警告 级别."
logger_alert "这是 警报 级别."
logger_fatal "这是 致命 级别."
logger_fatal ""
