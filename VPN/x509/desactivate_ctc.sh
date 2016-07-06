#!/bin/bash
###############################################################################
# Auteur : Alexis Cangelosi
# Promotion : ITI14M SR
# Theme : Evaluation de fin de semestre
# Titre : Désactivation client to client [AUTOMATISATION]
###############################################################################

###############################################################################
# 								VARIABLES									  
###############################################################################

root_vpn="/opt/vpn/x509"
root_openvpn="/etc/openvpn"
root_install="/usr/share/easy-rsa/"
serveur_name="None"


###############################################################################
# 								SCRIPT									  
###############################################################################

# Clean sheet
clear

echo "###########################################################################"
echo "Désactivation du client to client"
echo "###########################################################################"
echo ""
echo "[!] Liste des serveur disponible :"
ls $root_vpn/serveur/
echo "[*] Nom du server à utiliser :"
read -p "[*] -> " server_name

find $root_vpn/serveur/$server_name/$server_name.conf -type f -exec sed -i 's/client-to-client/;client-to-client/g' {} \+

service openvpn restart

exit