#!/bin/bash
###############################################################################
# Auteur : Alexis Cangelosi
# Promotion : ITI14M SR
# Theme : Evaluation de fin de semestre
# Titre : Désactivation x509 [AUTOMATISATION]
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
echo "Désactivation du vpn"
echo "###########################################################################"
echo ""
echo "[!] Liste des serveur disponible :"
ls $root_vpn/serveur/
echo "[*] Nom du server à activer :"
read -p "[*] -> " server_name

rm $root_openvpn/dh* $root_openvpn/ca.crt $root_openvpn/$server_name.*

iptables -t nat -D POSTROUTING 1
iptables -t nat -D POSTROUTING 1
iptables -t nat -D POSTROUTING 1

echo "" > $path/vpn_in_progress.sh


. $path/default_firewall.sh
. $path/vpn_in_progress.sh

service openvpn restart

echo "[*] Server desactivé ! [OK]"

exit 0