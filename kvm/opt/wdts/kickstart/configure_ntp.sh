#!/bin/bash

run="FIRST"

while [[ "$run" == "STARTOVER" ]] || [[ "$run" == "FIRST" ]]; do #WHILE STARTOVER
  run="FIRST"
  clear

  if [ -a /tmp/ntp ] #RESETS /tmp/ntp contents
    then
      echo > /tmp/ntp
  fi

  echo
  echo "This step is to configure your /etc/ntp.conf file. Please enter in the form of 'HOSTNAME MODE' for each server."
  echo "dynamic and iburst are the most common MODEs.  Set it to dynamic if you are unsure."
  echo "Please seperate the entries by a single space. Example: server.local.domain dynamic"
  echo "Enter DONE when complete.  You will be given the chance to startover if you made a mistake."
  echo
  read server mode

  while [[ "$server" != "DONE" ]]; do
    echo -e "server\t$server\t$mode" >> /tmp/ntp
    read server mode
  done

  clear

  echo "Please examine the following ntp file."
  echo
  cat /tmp/ntp

  while [[ "$run" != "APPLY" ]] && [[ "$run" != "STARTOVER" ]]; do #WHILE APPLY
    echo
    echo "Type 'APPLY' to copy it to /etc/ntp.conf.  Type 'STARTOVER' to wipe all changes and begin this step again"
    echo
    read run

    if [[ "$run" == "APPLY" ]]
      then
        cat /tmp/ntp >> /etc/ntp.conf
        echo "Config added"
    fi
  done #END WHILE APPLY
done #END WHILE STARTOVER
exec /etc/init.d/ntpd restart
