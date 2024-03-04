#!/bin/bash

/usr/sbin/iptables -F
/usr/sbin/iptables -X

/usr/sbin/iptables -A INPUT --source 127.0.0.0/8 -j ACCEPT
/usr/sbin/iptables -A INPUT -p tcp -m multiport --source 192.168.11.0/24 --dports 53 -j ACCEPT
/usr/sbin/iptables -A INPUT -p udp -m multiport --source 192.168.11.0/24 --dports 53 -j ACCEPT
/usr/sbin/iptables -A INPUT -p udp -m multiport --dports 53 -j DROP
