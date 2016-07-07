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

find $path/default_firewall.sh -type f -exec sed -i 's/#iptables -t nat -A POSTROUTING -o $NET -j MASQUERADE/$NAT/g' {} \+

. $path/default_firewall.sh
. $path/filtrage_in_progress.sh
. $path/redirect_in_progress.sh

echo "[*] NAT établie : [OK]"

exit 0
