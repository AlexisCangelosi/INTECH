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
echo "[*] IP source : (default = None)"
read -p "[*] => "
echo "[*] IP destination : (default = None)"
read -p "[*] => "
echo "[*] Port source : (default = None)"
read -p "[*] => "
echo "[*] Port destionation : (default = None)"
read -p "[*] => "

if [ $proto -eq "udp" ] ; then
	rule="iptables -A $type_filt -s $ip_src -d $ip_dst -p $proto --sport $port_src --dport $port_dst -m state --state NEW -j ACCEPT"
elif [ $proto -eq "tcp" ] ; then
	rule="iptables -A $type_filt -s $ip_src -d $ip_dst -p $proto --sport $port_src --dport $port_dst -m state --state NEW --syn -j ACCEPT"
else 
	echo "[!] Protocole non correct !"
	./add_filtrage_rules.sh
fi

echo $bash > $path/filtrage_in_progress.sh
echo $rule >> $path/filtrage_in_progress.sh

. $path/default_firewall.sh
. $path/filtrage_in_progress.sh
. $path/redirect_in_progress.sh
. $path/vpn_in_progress.sh

echo "[!] Règle mise en place :"
echo $rule