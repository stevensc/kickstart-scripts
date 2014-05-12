#!/bin/bash

/opt/wdts/kickstart/configure_hosts.sh
/opt/wdts/kickstart/configure_ntp.sh
/opt/wdts/kickstart/configure_bridges.py
/opt/wdts/kickstart/configure_vnc.sh
service network restart
