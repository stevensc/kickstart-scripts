#!/bin/bash

run="FIRST"

while [[ "$run" == "STARTOVER" ]] || [[ "$run" == "FIRST" ]]; do #WHILE STARTOVER
  run="FIRST"
  clear

  if [ -a /tmp/hosts ] #RESETS /tmp/hosts contents
    then
      rm -f /tmp/hosts
  fi
  cp /etc/hosts /tmp/hosts

  echo
  echo "This step is to configure your /etc/hosts file. Please enter in the form of 'IP HOSTNAME ALIAS' for each server."
  echo "You may enter as many hostnames or aliases for the IP as you wish on a single line."
  echo "Ensure everything is single-space seperated. Example: 10.10.10.1 server.local.domain mainserver"
  echo "Enter 'DONE' when complete.  You will be given the chance to startover if you made a mistake."
  echo
  read ip host

  while [[ "$ip" != "DONE" ]]; do
    echo -e "$ip\t$host" >> /tmp/hosts
    read ip host
  done

  clear

  echo "Please examine the following hosts file."
  echo
  cat /tmp/hosts

  while [[ "$run" != "APPLY" ]] && [[ "$run" != "STARTOVER" ]]; do #WHILE APPLY
    echo
    echo "Type 'APPLY' to copy it to /etc/hosts.  Type 'STARTOVER' to wipe all changes and begin this step again"
    echo
    read run

    if [[ "$run" == "APPLY" ]]
      then
        mv /tmp/hosts /etc/hosts
        echo "Config copied"
    fi
  done #END WHILE APPLY
done #END WHILE STARTOVER
