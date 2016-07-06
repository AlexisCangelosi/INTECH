#!/bin/bash
###############################################################################
# Auteur : Alexis Cangelosi
# Promotion : ITI14M SR
# Theme : Evaluation de fin de semestre
# Titre : Supprimer x509 client [AUTOMATISATION]
###############################################################################

###############################################################################
# 								VARIABLES									  
###############################################################################

root_vpn="/opt/vpn/x509"
root_openvpn="/etc/openvpn"
root_install="/usr/share/easy-rsa/"
conf_name="serveur_x509.conf"
client_name="None"


###############################################################################
# 								SCRIPT									  
###############################################################################

# Clean sheet
clear

echo "###########################################################################"
echo "Suppression d'un client vpn"
echo "###########################################################################"
echo ""
echo "[!] Liste des clients disponible :"
ls $root_vpn/client/
echo "[*] Nom du client :"
read -p "[*] -> " client_name

cd $root_install
source vars
$root_install/revoke-full $client_name
rm -R $root_vpn/client/$client_name

exit

