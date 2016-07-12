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

ip_src_f=""
ip_dst_f=""
port_dst_f=""
port_src_f=""
proto="None"
type_filt="None"
action="None"
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
echo "[*] Action : (accept/drop)"
read -p "[*] => " action

# Test chaque variable pour savoir si elle est vide ou pas 
# Si elle est vide on passe sinon on lui rajoute l'option correspondante

if [ -n $ip_src ]; then
	$ip_src_f = "-s $ip_src"
else
	$ip_src_f = ""
fi

if [ -n $ip_dst ]; then
	$ip_dst_f = "-d $ip_dst"
else
	$ip_dst_f = ""
fi

if [ -n $port_src ]; then
	$port_src_f = "--sport $port_src"
else
	$port_src_f = ""
fi

if [ -n $port_dst ]; then
	$port_dst_f = "--dport $port_dst"
else
	$port_dst_f = ""
fi


if [ $proto -eq "1" ] ; then
	if [ $type_filt -eq "1" ] ; then
		echo "iptables -A INPUT $ip_src_f $ip_dst_f -p udp $port_src_f $port_dst_f -m state --state NEW -j $action" >> FIREWALL/filtrage_in_progress.sh 
	elif [ $type_filt -eq "2" ] ; then
		echo "iptables -A OUTPUT $ip_src_f $ip_dst_f -p udp $port_src_f $port_dst_f -m state --state NEW -j $action" >> FIREWALL/filtrage_in_progress.sh
	elif [ $type_filt -eq "3" ] ; then
		echo "iptables -A FORWARD $ip_src_f $ip_dst_f -p udp $port_src_f $port_dst_f -m state --state NEW -j $action" >> FIREWALL/filtrage_in_progress.sh 
	else 
		echo "[!] Type non reconnu !"
		. /home/ubuntu/INTECH/FIREWALL/add_filtrage_rules.sh
	fi
elif [ $proto -eq "2" ] ; then
	if [ $type_filt -eq "1" ] ; then
		echo "iptables -A INPUT $ip_src_f $ip_dst_f -p tcp $port_src_f $port_dst_f -m state --state NEW --syn -j $action" >> FIREWALL/filtrage_in_progress.sh 
	elif [ $type_filt -eq "2" ] ; then
		echo "iptables -A OUTPUT $ip_src_f $ip_dst_f -p tcp $port_src_f $port_dst_f -m state --state NEW --syn -j $action" >> FIREWALL/filtrage_in_progress.sh  
	elif [ $type_filt -eq "3" ] ; then
		echo "iptables -A FORWARD $ip_src_f $ip_dst_f -p tcp $port_src_f $port_dst_f -m state --state NEW --syn -j $action" >> FIREWALL/filtrage_in_progress.sh 
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

iptables -L

echo "[!] Règle mise en place [OK]"
