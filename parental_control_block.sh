#!/bin/bash
for IP in (子どもの端末の IP アドレス)
do
  /usr/sbin/iptables -A INPUT --source ${IP} -p icmp -j ACCEPT
  /usr/sbin/iptables -A INPUT --source ${IP}/32 -j LOG --log-prefix "PARENTAL_CONTROL: "
  /usr/sbin/iptables -A INPUT --source ${IP}/32 -j REJECT
done
