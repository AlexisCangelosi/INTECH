#!/bin/bash
###############################################################################
# Auteur : Alexis Cangelosi
# Promotion : ITI14M SR
# Theme : Evaluation de fin de semestre
# Titre : Activation NAT
###############################################################################

###############################################################################
# 								VARIABLES									  
###############################################################################

NAT="iptables -t nat -A POSTROUTING -o $NET -j MASQUERADE"
path="/opt/firewall"

###############################################################################
# 								SCRIPT									  
###############################################################################

# Clean sheet
clear

echo "###########################################################################"
echo "MISE EN PLACE DU NAT !"
echo "###########################################################################"

find $path/default_firewall.sh -type f -exec sed -i 's/iptables -t nat -A POSTROUTING -j MASQUERADE/$NAT/g' {} \+

echo "[*] NAT établie : [OK]"

exit 0
