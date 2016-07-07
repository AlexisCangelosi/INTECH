#!/bin/bash
###############################################################################
# Auteur : Alexis Cangelosi
# Promotion : ITI14M SR
# Theme : Evaluation de fin de semestre
# Titre : Désactivation NAT
###############################################################################

NAT="#iptables -t nat -A POSTROUTING -o $NET -j MASQUERADE"

###############################################################################
# 								SCRIPT									  
###############################################################################

# Clean sheet
clear

echo "###########################################################################"
echo "DESACTIVATION DU NAT !"
echo "###########################################################################"

find $path/default_firewall.sh -type f -exec sed -i 's/iptables -t nat -A POSTROUTING -o $NET -j MASQUERADE/$NAT/g' {} \+

echo "[*] NAT desactivé : [OK]"

.$path/default_firewall.sh
.$path/filtrage_in_progress.sh
.$path/redirect_in_progress.sh

exit 0
