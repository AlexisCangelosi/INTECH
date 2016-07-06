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

ip_lan="None"
port_dst_ext="None"
port_dst_int="None"
proto="None"
rule_1="None"
rule_2="None"

ip_lan=$1
port_dst_ext=$2
port_dst_int=$3
proto=$4

###############################################################################
# 								SCRIPT									  
###############################################################################

# Clean sheet
clear

echo "###########################################################################"
echo "MISE EN PLACE DES REGLES DE REDIRECTION !"
echo "###########################################################################"

if [ $proto -eq "udp" ] ; then
	rule_1="iptables -t nat -A PREROUTING -i eth0 -p $proto --dport $port_dst_ext -j DNAT --to-destination $ip_dst:$port_dst_int"
    rule_2="iptables -A FORWARD -i eth0 -o eth1 -p $proto --dport $port_dst_ext -m state --state NEW -j ACCEPT"

elif [ $proto -eq "tcp" ] ; then
	regle_1="iptables -t nat -A PREROUTING -i eth0 -p $proto --dport $port_dst_ext -j DNAT --to-destination $ip_dst:$port_dst_int"
    regle_2="iptables -A FORWARD -i eth0 -o eth1 -p $proto --dport $port_dst_ext -m state --state NEW -j ACCEPT"

else 
	echo "[!] Protocole non correct !"
	./add_redirect_rules.sh
fi

echo $bash > $path/redirect_in_progress.sh
echo $rule_1 >> $path/redirect_in_progress.sh
echo $rule_2 >> $path/redirect_in_progress.sh

.$path/redirect_in_progress.sh

echo "[!] Règles mise en place :"
echo $regle_1
echo $regle_2