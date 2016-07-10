#!/bin/bash
###############################################################################
# Auteur : Alexis Cangelosi
# Promotion : ITI14M SR
# Theme : Evaluation de fin de semestre
# Titre : Activation x509 serveur [AUTOMATISATION]
###############################################################################

###############################################################################
# 								VARIABLES									  
###############################################################################

root_vpn="/opt/vpn/x509"
root_openvpn="/etc/openvpn"
root_install="/usr/share/easy-rsa/"
server_name="None"

path="/opt/firewall"
bash="#!/bin/bash \n"

###############################################################################
# 								SCRIPT									  
###############################################################################

# Clean sheet
clear

echo "###########################################################################"
echo "Activation du vpn"
echo "###########################################################################"
echo ""
echo "[!] Liste des serveur disponible :"
ls $root_vpn/serveur/
echo "[*] Nom du server à activer :"
read -p "[*] -> " server_name


ln -s $root_vpn/serveur/$server_name/* $root_openvpn/

echo "1" > /proc/sys/net/ipv4/ip_forward

echo "
# Allow traffic initiated from VPN to access LAN
iptables -I FORWARD -i tun1 -o eth0 -s 10.8.1.0/24 -d 192.168.0.0/24 -m conntrack --ctstate NEW -j ACCEPT

# Allow traffic initiated from VPN to access 'the world'
iptables -I FORWARD -i tun1 -o eth0 -s 10.8.1.0/24 -m conntrack --ctstate NEW -j ACCEPT

# Allow traffic initiated from LAN to access 'the world'
iptables -I FORWARD -i eth0 -o eth0 -s 192.168.0.0/24 -m conntrack --ctstate NEW -j ACCEPT

# Allow established traffic to pass back and forth
iptables -I FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# Notice that -I is used, so when listing it (iptables -vxnL) 
# will be reversed.  This is intentional in this demonstration.

# Masquerade traffic from VPN to 'the world' -- done in the nat table
iptables -t nat -I POSTROUTING -o eth0 -s 10.8.1.0/24 -j MASQUERADE

# Masquerade traffic from LAN to 'the world'
iptables -t nat -I POSTROUTING -o eth0 -s 192.168.0.0/24 -j MASQUERADE" > $path/vpn_in_progress.sh

. $path/default_firewall.sh
. $path/filtrage_in_progress.sh
. $path/redirect_in_progress.sh
. $path/vpn_in_progress.sh

service openvpn restart
exit 0