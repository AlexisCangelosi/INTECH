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

ip_src=""
ip_dst=""
port_dst=""
port_src=""
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
read -p "[*] => " ip_src
echo "[*] IP destination : (default = None)"
read -p "[*] => " ip_dst
echo "[*] Port source : (default = None)"
read -p "[*] => " port_src
echo "[*] Port destionation : (default = None)"
read -p "[*] => " port_dst

if [ $proto -eq "1" ] ; then
	if [ $type_filt -eq "1" ] ; then
		echo "iptables -A INPUT -s $ip_src -d $ip_dst -p udp --sport $port_src --dport $port_dst -m state --state NEW -j ACCEPT" >> FIREWALL/filtrage_in_progress.sh 
	elif [ $type_filt -eq "2" ] ; then
		echo "iptables -A OUTPUT -s $ip_src -d $ip_dst -p udp --sport $port_src --dport $port_dst -m state --state NEW -j ACCEPT" >> FIREWALL/filtrage_in_progress.sh
	elif [ $type_filt -eq "3" ] ; then
		echo "iptables -A FORWARD -s $ip_src -d $ip_dst -p udp --sport $port_src --dport $port_dst -m state --state NEW -j ACCEPT" >> FIREWALL/filtrage_in_progress.sh 
	else 
		echo "[!] Type non reconnu !"
		. /home/ubuntu/INTECH/FIREWALL/add_filtrage_rules.sh
	fi
elif [ $proto -eq "2" ] ; then
	if [ $type_filt -eq "1" ] ; then
		echo "iptables -A INPUT -s $ip_src -d $ip_dst -p tcp --sport $port_src --dport $port_dst -m state --state NEW --syn -j ACCEPT" >> FIREWALL/filtrage_in_progress.sh 
	elif [ $type_filt -eq "2" ] ; then
		echo "iptables -A OUTPUT -s $ip_src -d $ip_dst -p tcp --sport $port_src --dport $port_dst -m state --state NEW --syn -j ACCEPT" >> FIREWALL/filtrage_in_progress.sh 
	elif [ $type_filt -eq "3" ] ; then
		echo "iptables -A FORWARD -s $ip_src -d $ip_dst -p tcp --sport $port_src --dport $port_dst -m state --state NEW --syn -j ACCEPT" >> FIREWALL/filtrage_in_progress.sh 
	else 
		echo "[!] Type non reconnu !"
		. /home/ubuntu/INTECH/FIREWALL/add_filtrage_rules.sh
	fi
else 
	echo "[!] Protocole non correct !"
	. /home/ubuntu/INTECH/FIREWALL/add_filtrage_rules.sh
fi

#echo $rule >> FIREWALL/filtrage_in_progress.sh

./FIREWALL/default_firewall.sh
clear
./FIREWALL/filtrage_in_progress.sh
./FIREWALL/redirect_in_progress.sh
./FIREWALL/vpn_in_progress.sh

iptables -L

echo "[!] Règle mise en place [OK]"
