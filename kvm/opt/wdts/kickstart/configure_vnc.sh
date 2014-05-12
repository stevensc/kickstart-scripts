#!/bin/bash
clear

echo "This step will configure the password for the VNC server." 
echo
sudo su - wdtsadmin -c "vncpasswd"
sudo su - wdtsadmin -c "vncserver"
/etc/init.d/vncserver start
