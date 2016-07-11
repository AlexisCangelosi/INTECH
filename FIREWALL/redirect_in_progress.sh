#!/bin/bash
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j DNAT --to-destination 192.168.0.100:5000
iptables -A FORWARD -i eth0 -o eth1 -p tcp --dport 80 -m state --state NEW -j ACCEPT
