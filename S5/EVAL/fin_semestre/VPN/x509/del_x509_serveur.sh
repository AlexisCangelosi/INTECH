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
serveur_name="None"


###############################################################################
# 								SCRIPT									  
###############################################################################

# Clean sheet
clear

echo "###########################################################################"
echo "Suppression d'un serveur vpn"
echo "###########################################################################"
echo ""
echo "[!] Liste des serveur disponible :"
ls $root_vpn/serveur/
echo "[*] Nom du serveur :"
read -p "[*] -> " serveur_name

cd $root_install
source vars
$root_install/revoke-full $serveur_name
rm -R $root_vpn/serveur/$serveur_name

exit

