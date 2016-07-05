#!/bin/bash
###############################################################################
# Auteur : Alexis Cangelosi
# Promotion : ITI14M SR
# Theme : Evaluation de fin de semestre
# Titre : Suppresion autorité de certification fille [AUTOMATISATION]
###############################################################################

###############################################################################
# 								VARIABLES									  
###############################################################################

RootNom="ROOT_CBI"
RootDos="/opt/rootpki"
CAFilleNom="ROOT_CBI_G2"
Home="/home/ubuntu"

###############################################################################
# 								SCRIPT									  
###############################################################################

# Clean sheet
clear

# On récupère le nom de la CA FILLE à supprimer
echo "Le script va supprimer automatiquement la CA FILLE, veuillez suivre les eventuelles instructions qui vous seront demandees !"
echo ""
echo "[!] Liste des CA FILLE : "
cat $RootDos/$RootNom/index.txt | grep V | awk '{print $7}' | cut -d "/" -f 3 | cut -d "=" -f 2
echo "[*] CN de la CA FILLE : "
read -p "-> " CN

# On recupère le mail de la CA FILLE à supprimer
echo ""
echo "[!] Liste des mails associés aux CA FILLE : "
cat $RootDos/$RootNom/index.txt | grep V | awk '{print $7}' | cut -d "/" -f 4 | cut -d "=" -f 2
echo "[*] MAIL de la CA FILLE : "
read -p "-> " MAIL

# Avec le CN et le mail on peux recuperer l'ID de la CA FILLE
CA_ID=$(cat $RootDos/$RootNom/index.txt | grep V | grep $CN | grep $MAIL | awk '{print $3}')

if [ -n "$CN" ] && [ -n "$MAIL" ]
then
    echo "[!] La CA suivante va etre supprimer !"
    echo "[!] CN = $CN"
    echo "[!] MAIL = $MAIL"
    echo "[!] CLIENT ID = $CA_ID"

    openssl ca -name CA_default -config $RootDos/openssl.cnf -revoke $RootDos/$RootNom/newcerts/$CA_ID.pem

    echo "[*] Génération de la liste des certificats révokés:"
    openssl ca -gencrl -config $RootDos/openssl.cnf -out $RootDos/$RootNom/revok.crl

    mv $RootDos/$CN $RootDos/$RootNom/revoked_ca/
else
   echo "[*] Il y a eu une erreur ! L'un des champs suivant n'est pas valide !"
   echo "[!] CN = $CN"
   echo "[!] MAIL = $MAIL"
   echo "[!] CLIENT ID = $CA_ID"
   exit
   clear
fi