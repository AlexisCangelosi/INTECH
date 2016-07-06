#!/bin/bash
###############################################################################
# Auteur : Alexis Cangelosi
# Promotion : ITI14M SR
# Theme : Evaluation de fin de semestre
# Titre : Suppresion certificat [AUTOMATISATION]
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
echo "[!] Le script va supprimer automatiquement un certificat, veuillez suivre les eventuelles instructions qui vous seront demandees !"
echo ""
echo "[!] Liste des CA FILLE disponible : "
cat $RootDos/$RootNom/index.txt | grep V | awk '{print $7}' | cut -d "/" -f 3 | cut -d "=" -f 2
echo "[*] CN de la CA FILLE à utiliser : "
read -p "-> " CAFilleNom

echo ""
echo "[!] Liste des certificats disponible  : "
cat $RootDos/$CAFilleNom/index.txt | grep V | awk '{print $7}' | cut -d "/" -f 3 | cut -d "=" -f 2
echo "[*] CN du certificat à utiliser : "
read -p "-> " CACertNom

# Avec le CN et le mail on peux recuperer l'ID de la CA FILLE
CA_ID=$(cat $RootDos/$CAFilleNom/index.txt | grep V | grep $CACertNom | awk '{print $3}')

if [ -n "$CACertNom" ] && [ -n "$CA_ID" ]
then
    echo "[!] La CA suivante va etre supprimer !"
    echo "[!] CN = $CACertNom"
    echo "[!] CLIENT ID = $CA_ID"

    openssl ca -name CA_ssl_default -config $RootDos/$CAFilleNom/$CAFilleNom.openssl.cnf -revoke $RootDos/$CAFilleNom/newcerts/$CA_ID.pem

    mv $RootDos/$CAFilleNom/newcerts/$CACertNom $RootDos/$CAFilleNom/revoked_ca/

else
   echo "[*] Il y a eu une erreur ! L'un des champs suivant n'est pas valide !"
   echo "[!] CN = $CN"
   echo "[!] CLIENT ID = $CA_ID"
   exit
   clear
fi