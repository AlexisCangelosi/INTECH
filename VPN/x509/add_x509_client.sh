#!/bin/bash
###############################################################################
# Auteur : Alexis Cangelosi
# Promotion : ITI14M SR
# Theme : Evaluation de fin de semestre
# Titre : Création x509 client [AUTOMATISATION]
###############################################################################

###############################################################################
# 								VARIABLES									  
###############################################################################

root_vpn="/opt/vpn/x509"
root_openvpn="/etc/openvpn"
root_install="/usr/share/easy-rsa/"
client_name="None"
server_port="None"

###############################################################################
# 								SCRIPT									  
###############################################################################

# Clean sheet
clear

echo "###########################################################################"
echo "Création d'un client vpn"
echo "###########################################################################"
echo ""
echo "[*] Nom du client :"
read -p "[*] -> " client_name
echo "[*] Port :"
read -p "[*] -> " server_port

mkdir -p $root_vpn/client/$client_name

cd $root_install
source vars
$root_install/build-key $client_name

cp $root_install/keys/ca.crt $root_vpn/client/$client_name/
cp $root_install/keys/$client_name.* $root_vpn/client/$client_name/

echo "[*] Creation du fichier de configuration client"
echo "
client
dev tun
proto udp

remote labo.itinet.fr
port $server_port

resolv-retry infinite
nobind

persist-key
persist-tun

ca ca.crt
cert $client_name.crt
key $client_name.key

comp-lzo

verb 6
" > $root_vpn/client/$client_name/$client_name.conf

mkdir /home/ubuntu/INTECH/VPN/x509/client/$client_name
cp $root_vpn/client/$client_name/* /home/ubuntu/INTECH/VPN/x509/client/$client_name/

exit 0