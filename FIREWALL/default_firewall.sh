#!/bin/bash
###############################################################################
# Auteur : Alexis Cangelosi
# Promotion : ITI14M SR
# Theme : Evaluation de fin de semestre
# Titre : Filtrage default
###############################################################################

###############################################################################
# 								VARIABLE									  
###############################################################################

NET="eth0"
NET_IP="192.168.0.10"

###############################################################################
# 								SCRIPT									  
###############################################################################

# Clean sheet
clear

###############################################################################
# 						PARAMETRE PAR DEFAUT									  
###############################################################################

echo "[*] Initialisation du firewall"

# Vidage des tables et des regles personnelles
iptables -t filter -F
iptables -t filter -X
echo "[*] Vidage des regles et des tables : [OK]"

# Interdire toutes connexions entrantes et sortantes
iptables -t filter -P INPUT DROP
iptables -t filter -P FORWARD DROP
iptables -t filter -P OUTPUT DROP
echo "[*] Interdire toutes les connexions entrantes et sortantes : [OK]"

# Ne pas casser les connexions etablies
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
echo "[*] Ne pas casser les connexions établies : [OK]"

# On nat toutes les requettes passant par le DMZ
#iptables -t nat -A POSTROUTING -o $NET -j MASQUERADE

###############################################################################
# 						NOUVELLE REGLES								  
###############################################################################

# Autoriser loopback
iptables -t filter -A INPUT -i lo -j ACCEPT
iptables -t filter -A OUTPUT -o lo -j ACCEPT
echo "[*] Loopback autorisé : [OK]"

# Autoriser SSH
iptables -t filter -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 22 -j ACCEPT
echo "[*] SSH autorisé : [OK]"
 
# Autoriser DNS
iptables -t filter -A OUTPUT -p tcp --dport 53 -j ACCEPT
iptables -t filter -A OUTPUT -p udp --dport 53 -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 53 -j ACCEPT
iptables -t filter -A INPUT -p udp --dport 53 -j ACCEPT
echo "[*] DNS autorisé : [OK]"

# Autoriser HTTP et HTTPS
iptables -t filter -A OUTPUT -p tcp --dport 80 -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 443 -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 8443 -j ACCEPT
echo "[*] HTTP(S) autorisé : [OK]"

# Autoriser VPN
iptables -A FORWARD -m state --state NEW -p tcp --dport 1194 --syn -j ACCEPT #VPN
iptables -A INPUT -m state --state NEW -p tcp --dport 1194 --syn -j ACCEPT #VPN
iptables -A OUTPUT -m state --state NEW -p tcp --dport 1194 --syn -j ACCEPT #VPN
iptables -A FORWARD -m state --state NEW -p udp --dport 1194 -j ACCEPT #VPN
iptables -A INPUT -m state --state NEW -p udp --dport 1194 -j ACCEPT #VPN
iptables -A OUTPUT -m state --state NEW -p udp --dport 1194 -j ACCEPT #VPN
echo "[*] VPN autorisé : [OK]"

cp /home/ubuntu/INTECH/FIREWALL/default_firewall.sh /opt/firewall

echo "[!] Filtrage en place !"
iptables -L -v