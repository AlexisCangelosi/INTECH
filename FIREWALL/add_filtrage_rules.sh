#!/bin/bash
###############################################################################
# Auteur : Alexis Cangelosi
# Promotion : ITI14M SR
# Theme : Evaluation de fin de semestre
# Titre : Ajout des regles de filtrage
###############################################################################

###############################################################################
# 								VARIABLES									  
###############################################################################

path="/opt/firewall"
bash="#!/bin/bash \n"

ip_src="None"
ip_dst="None"
port_dst="None"
port_src="None"
proto="None"
type_filt="None"
rule="None"

###############################################################################
# 								SCRIPT									  
###############################################################################

# Clean sheet
clear

echo "###########################################################################"
echo "MISE EN PLACE DES REGLES DE FILTRAGE !"
echo "###########################################################################"
echo "[*] Type : "
echo "[1] INPUT "
echo "[2] OUTPUT "
echo "[3] FORWARD "
read -p "[*] => " type_filt
echo "[*] Protocole : "
echo "[!] 1 - UDP"
echo "[!] 2 - TCP"
read -p "[*] => " proto
echo "[*] IP source : (default = None)"
read -p "[*] => "
echo "[*] IP destination : (default = None)"
read -p "[*] => "
echo "[*] Port source : (default = None)"
read -p "[*] => "
echo "[*] Port destionation : (default = None)"
read -p "[*] => "

if [ $proto -eq "1" ] ; then
	rule="iptables -A $type_filt -s $ip_src -d $ip_dst -p udp --sport $port_src --dport $port_dst -m state --state NEW -j ACCEPT"
elif [ $proto -eq "2" ] ; then
	rule="iptables -A $type_filt -s $ip_src -d $ip_dst -p tcp --sport $port_src --dport $port_dst -m state --state NEW --syn -j ACCEPT"
else 
	echo "[!] Protocole non correct !"
	./add_filtrage_rules.sh
fi

echo $rule >> $path/filtrage_in_progress.sh

. $path/default_firewall.sh
. $path/filtrage_in_progress.sh
. $path/redirect_in_progress.sh
. $path/vpn_in_progress.sh

echo "[!] Règle mise en place [OK]"
echo $rule