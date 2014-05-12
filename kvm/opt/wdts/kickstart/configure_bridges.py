#!/usr/bin/python
import socket
import os, sys

net_path = "/etc/sysconfig/network-scripts"
bridges = ["br0", "br1"]

def is_valid_ipv4_address(address):
  try:
      socket.inet_pton(socket.AF_INET, address)
  except AttributeError:  # no inet_pton here, sorry
      try:
          socket.inet_aton(address)
      except socket.error:
          print "Bad Entry"
          return False
      return address.count('.') == 3
  except socket.error:  # not a valid address
      print "Bad Entry"
      return False
  return True

def ask_for_address(title):
  entry = raw_input("%s: " % title)
  while not is_valid_ipv4_address(entry):
    entry = raw_input("%s: " % title)
  return entry

def set_bridge_values(br):
  gateway = ""
  print "Please enter the following information in IPv4 format for %s pressing enter after each" % interface
  ip = ask_for_address("IP")
  broadcast = ask_for_address("BROADCAST")
  if br == "br0": #We only want one gateway defined
    gateway = ask_for_address("GATEWAY")
  netmask = ask_for_address("NETMASK")
  bridge_values = {"DEVICE" : br, "TYPE" : "Bridge", "BOOTPROTO" : "static", "ONBOOT" : "yes", "NM_CONTROLLED" : "no", "IPADDR" : ip, "BROADCAST" : broadcast, "GATEWAY" : gateway, "NETMASK" : netmask} 
  return bridge_values

def set_eth_values(br):
  eth = "eth%s" % (br[len(br) - 1])
  eth_values = {"DEVICE" : eth, "TYPE" : "Ethernet", "BOOTPROTO" : "dhcp", "ONBOOT" : "yes", "NM_CONTROLLED" : "no", "BRIDGE" : br} 
  return eth_values

def write_files(headers):
  file_path="%s/ifcfg-%s" % (net_path, headers["DEVICE"])
  file = open(file_path, "w") #Creates new empty file
  with open(file_path, "a"):
    for h in headers:
      if headers[h] != "": #Append only the lines with non-empty entries
        file.write("%s=%s\n" % (h, headers[h]))

for interface in bridges:
  eth_headers = set_eth_values(interface)
  br_headers = set_bridge_values(interface)
  write_files(eth_headers)
  write_files(br_headers)
  os.remove('/etc/udev/rules.d/70-persistent-net.rules')
  
