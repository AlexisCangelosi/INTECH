#!/bin/bash
###############################################################################
# Auteur : Alexis Cangelosi
# Promotion : ITI14M SR
# Theme : Evaluation de fin de semestre
# Titre : Redirection règles
###############################################################################

###############################################################################
# 								VARIABLES									  
###############################################################################

path="/opt/firewall"
bash="#!/bin/bash \n"

ip="None"
port_dst_int="None"
port_dst_ext="None"
proto="None"
rule_1="None"
rule_2="None"

###############################g################################################
# 								SCRIPT									  
###############################################################################

# Clean sheet
clear

echo "###########################################################################"
echo "MISE EN PLACE DES REGLES DE REDIRECTION !"
echo "###########################################################################"
echo "[*] Protocole : "
echo "[!] 1 - UDP"
echo "[!] 2 - TCP"
read -p "[*] => " proto
echo "[*] IP "
read -p "[*] => " ip
echo "[*] Port destination externe : "
read -p "[*] => " port_dst_ext
echo "[*] Port destination interne : "
read -p "[*] => " port_dst_int


if [ $proto -eq "1" ] ; then
	rule_1="iptables -t nat -A PREROUTING -i eth0 -p udp --dport $port_dst_ext -j DNAT --to-destination $ip:$port_dst_int"
    rule_2="iptables -A FORWARD -i eth0 -o eth1 -p udp --dport $port_dst_ext -m state --state NEW -j ACCEPT"

elif [ $proto -eq "2" ] ; then
	rule_1="iptables -t nat -A PREROUTING -i eth0 -p tcp --dport $port_dst_ext -j DNAT --to-destination $ip:$port_dst_int"
    rule_2="iptables -A FORWARD -i eth0 -o eth1 -p tcp --dport $port_dst_ext -m state --state NEW -j ACCEPT"

else 
	echo "[!] Protocole non correct !"
	. /home/ubuntu/INTECH/FIREWALL/add_redirect_rules.sh
fi


echo $rule_1 >> FIREWALL/redirect_in_progress.sh
echo $rule_2 >> FIREWALL/redirect_in_progress.sh

./FIREWALL/default_firewall.sh
clear



iptables -L

echo "[!] Règles mise en place [OK]"
echo $rule_1
echo $rule_2