#!/bin/sh
################################################################################
# SCRIPT DE REGLES DE FIREWALL
################################################################################

####### ONLY FOR LAN MACHINE !!!!
route add default gw 192.168.0.14
###################################

#### INITIALISATION
iptables -F
iptables -X
echo "1" > /proc/sys/net/ipv4/ip_forward

### ALL ETABLISHED
iptables -t filter -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

## DNS
iptables -t filter -A FORWARD -m state --state NEW -p udp --dport 53 -d 8.8.8.8 -j ACCEPT
iptables -t filter -A FORWARD -m state --state NEW -p tcp --dport 53 -d 8.8.8.8 -j ACCEPT

## HTTP
iptables -t filter -A FORWARD -m state --state NEW -p tcp --dport 80 --syn -j ACCEPT
iptables -t filter -A FORWARD -m state --state NEW -p tcp --dport 80 --syn -o tun0 -j ACCEPT

## HTTPS
iptables -t filter -A FORWARD -m state --state NEW -p tcp --dport 443 --syn -j ACCEPT
iptables -t filter -A FORWARD -m state --state NEW -p tcp --dport 443 --syn -j -i tun0 ACCEPT

## SSH
iptables -t filter -A INPUT --dport 22 -j ACCEPT  
#iptables -t filter -A INPUT -m state --state NEW -p tcp --dport 22 --syn -j ACCEPT
#iptables -t filter -A FORWARD -m state --state NEW -p tcp --dport 22 --syn -j ACCEPT

### not allowed

iptables -t filter -A FORWARD -m state --state NEW -i tun0 -o eth1 -j DROP

