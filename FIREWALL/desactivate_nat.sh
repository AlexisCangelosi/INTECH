#!/bin/bash
###############################################################################
# Auteur : Alexis Cangelosi
# Promotion : ITI14M SR
# Theme : Evaluation de fin de semestre
# Titre : Désactivation NAT
###############################################################################


###############################################################################
# 								SCRIPT									  
###############################################################################

# Clean sheet
clear

echo "###########################################################################"
echo "DESACTIVATION DU NAT !"
echo "###########################################################################"

iptables -t nat -D POSTROUTING 1

echo "[*] NAT desactivé : [OK]"

.$path/default_firewall.sh
.$path/filtrage_in_progress.sh
.$path/redirect_in_progress.sh

exit 0
