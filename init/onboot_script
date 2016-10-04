#!/bin/bash
set -e
set -x

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

wait_network()
{
  MAX_RETRIES=20
  retries=0
  echo "Waiting for network"
  while [ -z "$(ip route | grep 'default' | awk '{print $3}')" ];do
    ip="$(ip route | grep 'default' | awk '{print $3}')"
    if [ -n "${ip}" ];then
      ping -t 1 -c 1 "${ip}" > /dev/null
      [ $? -eq 0 ] && break
    fi
    retries=$((retries + 1))
    if [ $retries -gt $MAX_RETRIES ];then
      echo "Network failed to come up"
      exit 1
    fi
    sleep 5
  done
  echo "Network is up"
}

wait_network
# Fetch and run script at onboot_script_url if given
if grep -q onboot_script_url= /proc/cmdline; then

  # Read the script URL from /proc/cmdline
  url_param=$(grep -o 'onboot_script_url=\S*' /proc/cmdline)
  url=${url_param#onboot_script_url=}

  if has_param 'payload';then
    payload="payload=$(get_param 'payload')"
  fi

  curl "${url}?${payload}" > /onboot_script
  chmod +x /onboot_script

  /onboot_script

fi
exit 0
