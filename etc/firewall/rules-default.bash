#!/bin/bash

#  Copyright 2012, Victor Arribas (v.arribas.urjc@gmail.com)
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.


IPTABLES="/sbin/iptables"


NET_LO="127.0.0.0/8"
ETH_LO="lo"

echo
echo "Aplicando Reglas de Firewall..."


$IPTABLES -P INPUT DROP
$IPTABLES -P OUTPUT DROP
$IPTABLES -P FORWARD DROP

$IPTABLES -N ICMP_IN

$IPTABLES -A INPUT  -i $ETH_LO -s $NET_LO -j ACCEPT
$IPTABLES -A OUTPUT -o $ETH_LO -d $NET_LO -j ACCEPT

$IPTABLES -A INPUT -p icmp -g ICMP_IN
$IPTABLES -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

$IPTABLES -A OUTPUT -j ACCEPT


$IPTABLES -A ICMP_IN -p icmp --icmp-type 0  -m limit --limit 1/s -j ACCEPT
$IPTABLES -A ICMP_IN -p icmp --icmp-type 3  -m limit --limit 1/s -j ACCEPT
$IPTABLES -A ICMP_IN -p icmp --icmp-type 4  -m limit --limit 3/s -j ACCEPT
$IPTABLES -A ICMP_IN -p icmp --icmp-type 8  -m limit --limit 5/s -j ACCEPT
$IPTABLES -A ICMP_IN -p icmp --icmp-type 11 -m limit --limit 1/s -j ACCEPT
$IPTABLES -A ICMP_IN -p icmp --icmp-type 12 -m limit --limit 1/s -j ACCEPT
$IPTABLES -A ICMP_IN -j DROP



echo "OK. Verifique lo que se aplica con: iptables -nvL"
