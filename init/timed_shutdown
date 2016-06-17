#!/bin/bash

has_param()
{
  param=$1
  set +e
  grep -q -o "${param}\S*" /proc/cmdline
  rc=$?
  set -e
  return "${rc}"
}

get_param()
{
  param_name=$1
  param_id=$(grep -o "${param_name}=\S*" /proc/cmdline)
  echo "${param_id#${param_name}=}"
}

if has_param max_uptime;then
  shutdown -r "$(get_param max_uptime)"
fi
