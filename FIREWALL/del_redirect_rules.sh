#!/bin/bash
###############################################################################
# Auteur : Alexis Cangelosi
# Promotion : ITI14M SR
# Theme : Evaluation de fin de semestre
# Titre : Del Redirection règles
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

###############################################################################
# 								SCRIPT									  
###############################################################################

# Clean sheet
clear

echo "###########################################################################"
echo "SUPPRESSION DE REGLE DE REDIRECTION !"
echo "###########################################################################"
echo "[*] Protocole : (tcp/udp) "
read -p "[*] => " proto
echo "[*] IP "
read -p "[*] => " ip
echo "[*] Port destination externe : "
read -p "[*] => " port_dst_ext
echo "[*] Port destination interne : "
read -p "[*] => " port_dst_int

if [ $proto -eq "udp" ] ; then
	rule_1="iptables -t nat -A PREROUTING -i eth0 -p $proto --dport $port_dst_ext -j DNAT --to-destination $ip_dst:$port_dst_int"
    rule_2="iptables -A FORWARD -i eth0 -o eth1 -p $proto --dport $port_dst_ext -m state --state NEW -j ACCEPT"

elif [ $proto -eq "tcp" ] ; then
	rule_1="iptables -t nat -A PREROUTING -i eth0 -p $proto --dport $port_dst_ext -j DNAT --to-destination $ip_dst:$port_dst_int"
    rule_2="iptables -A FORWARD -i eth0 -o eth1 -p $proto --dport $port_dst_ext -m state --state NEW -j ACCEPT"

else 
	echo "[!] Protocole non correct !"
	./add_redirect_rules.sh
fi

find $path/redirect_in_progress.sh -type f -exec sed -i "s/$rule_1/ /g" {} \+
find $path/redirect_in_progress.sh -type f -exec sed -i "s/$rule_2/ /g" {} \+

. $path/default_firewall.sh
. $path/filtrage_in_progress.sh
. $path/redirect_in_progress.sh

echo "[!] Règles supprimées :"
echo $rule_1
echo $rule_2
