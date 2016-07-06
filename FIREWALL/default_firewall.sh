#!/bin/bash
###############################################################################
# Auteur : Alexis Cangelosi
# Promotion : ITI14M SR
# Theme : Evaluation de fin de semestre
# Titre : Filtrage default
###############################################################################

###############################################################################
# 								VARIABLES									  
###############################################################################

LO="lo"
LO_IP="127.0.0.1"

ETH0="eth0"
ETH0_IP="192.168.0.10"

ETH1="eth1"
ETH1_IP="192.168.1.16"

PSK="tun0"
PSK_IP="10.8.0.1/24"

X509="tun1"
X509_IP="10.8.0.1/24"

###############################################################################
# 								SCRIPT									  
###############################################################################

# Clean sheet
clear

###############################################################################
# 						PARAMETRE PAR DEFAUT									  
###############################################################################

iptables -F
iptables -X

iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

iptables -A INPUT -i $LO -j ACCEPT
iptables -A OUTPUT -o $LO -j ACCEPT

iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

iptables -t nat -A POSTROUTING -j MASQUERADE

###############################################################################
# 						NOUVELLE REGLES								  
###############################################################################

# DNS TCP
iptables -A FORWARD -m state --state NEW -p tcp -d "8.8.8.8" --dport 53 --syn -j ACCEPT
iptables -A INPUT -m state --state NEW -p tcp -d "8.8.8.8" --dport 53 --syn -j ACCEPT
iptables -A OUTPUT -m state --state NEW -p tcp -d "8.8.8.8" --dport 53 --syn -j ACCEPT

# DNS UDP
iptables -A FORWARD -m state --state NEW -p udp -d "8.8.8.8" --dport 53 -j ACCEPT
iptables -A INPUT -m state --state NEW -p udp -d "8.8.8.8" --dport 53 -j ACCEPT
iptables -A OUTPUT -m state --state NEW -p udp -d "8.8.8.8" --dport 53 -j ACCEPT

# HTTP
iptables -A FORWARD -m state --state NEW -p tcp --dport 80 --syn -j ACCEPT #HTTP
iptables -A INPUT -m state --state NEW -p tcp --dport 80 --syn -j ACCEPT #HTTP
iptables -A OUTPUT -m state --state NEW -p tcp --dport 80 --syn -j ACCEPT #HTTP

#HTTPS
iptables -A FORWARD -m state --state NEW -p tcp --dport 443 --syn -j ACCEPT
iptables -A INPUT -m state --state NEW -p tcp --dport 443 --syn -j ACCEPT
iptables -A OUTPUT -m state --state NEW -p tcp --dport 443 --syn -j ACCEPT

# SSH
iptables -A FORWARD -m state --state NEW -p tcp --dport 22 --syn -j ACCEPT #SSH
iptables -A INPUT -m state --state NEW -p tcp --dport 22 --syn -j ACCEPT #SSH
iptables -A OUTPUT -m state --state NEW -p tcp --dport 22 --syn -j ACCEPT #SSH

# VPN TCP
iptables -A FORWARD -m state --state NEW -p tcp --dport 1194 --syn -j ACCEPT #VPN
iptables -A INPUT -m state --state NEW -p tcp --dport 1194 --syn -j ACCEPT #VPN
iptables -A OUTPUT -m state --state NEW -p tcp --dport 1194 --syn -j ACCEPT #VPN

# VPN UDP
iptables -A FORWARD -m state --state NEW -p udp --dport 1194 -j ACCEPT #VPN
iptables -A INPUT -m state --state NEW -p udp --dport 1194 -j ACCEPT #VPN
iptables -A OUTPUT -m state --state NEW -p udp --dport 1194 -j ACCEPT #VPN

#On autorise le ping
iptables -A INPUT -p icmp -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -p icmp -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -p icmp -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

echo "[!] Filtrage en place !"
iptables -L -v