#!/bin/bash
###############################################################################
# Auteur : Alexis Cangelosi
# Promotion : ITI14M SR
# Theme : Evaluation de fin de semestre
# Titre : Création x509 serveur [AUTOMATISATION]
###############################################################################

###############################################################################
# 								VARIABLES									  
###############################################################################

root_vpn="/opt/vpn/x509"
root_openvpn="/etc/openvpn"
root_install="/usr/share/easy-rsa/"
conf_name="serveur_x509.conf"
server_name="None"
server_port="None"

###############################################################################
# 								SCRIPT									  
###############################################################################

# Clean sheet
clear

echo "###########################################################################"
echo "Création d'un serveur vpn"
echo "###########################################################################"
echo ""
echo "[*] Nom du serveur :"
read -p "[*] -> " server_name
echo "[*] Port :"
read -p "[*] -> " server_port

echo "Création des variables easy-rsa"
echo "export EASY_RSA=\"\`pwd\`\"
export OPENSSL=\"openssl\"
export PKCS11TOOL=\"pkcs11-tool\"
export GREP=\"grep\"
export KEY_CONFIG=\`\$EASY_RSA/whichopensslcnf \$EASY_RSA\`
export KEY_DIR=\"\$EASY_RSA/keys\"
export PKCS11_MODULE_PATH=\"dummy\"
export PKCS11_PIN=\"dummy\"
export KEY_SIZE=2048
export CA_EXPIRE=3650
export KEY_EXPIRE=3650
export KEY_COUNTRY=\"FR\"
export KEY_PROVINCE=\"FRANCE\"
export KEY_CITY=\"Paris\"
export KEY_ORG=\"CantBreakIt\"
export KEY_EMAIL=\"$server_name@cantbreakit.fr\"
export KEY_OU=\"CBI\"
export KEY_NAME=\"EasyRSA\"" > $root_vpn/install/vars

mkdir -p $root_vpn/serveur/$server_name

$root_install/clean-all
cd $root_install
source vars
./build-ca
$root_install/build-key-server $server_name
$root_install/build-dh

cp $root_install/keys/ca.crt $root_vpn/serveur/$server_name/
cp $root_install/keys/$server_name.* $root_vpn/serveur/$server_name/
cp $root_install/keys/dh* $root_vpn/serveur/$server_name/

echo "[*] Creation du fichier de configuration"
echo "
local 192.168.0.10
port 1194

proto udp

dev tun1

ca ca.crt
cert $server_name.crt
key $server_name.key

dh dh2048.pem

server 10.8.1.0 255.255.255.0

push 'redirect-gateway local def1 bypass-dhcp'
push 'dhcp-option DNS 8.8.8.8'
push 'dhcp-option DNS 8.8.4.4'
;push 'route 192.168.10.0 255.255.255.0'
;push 'route 192.168.20.0 255.255.255.0'

client-to-client

keepalive 10 120

cipher BF-CBC        # Blowfish (default)
;cipher AES-128-CBC   # AES
;cipher DES-EDE3-CBC  # Triple-DES

comp-lzo

user openvpn
group openvpn

persist-key
persist-tun

status openvpn-status.log

;log         openvpn.log
;log-append  openvpn.log

verb 6

;mute 20
" > /opt/vpn/x509/server/$server_name/$server_name.conf

service openvpn restart
exit 0