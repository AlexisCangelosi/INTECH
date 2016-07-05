#!/bin/bash
###############################################################################
# Auteur : Alexis Cangelosi
# Promotion : ITI14M SR
# Theme : Evaluation de fin de semestre
# Titre : Création certificat serveur & client [AUTOMATISATION]
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
echo "[!] Le script va supprimer automatiquement la CA FILLE, veuillez suivre les eventuelles instructions qui vous seront demandees !"
echo ""
echo "[!] Liste des CA FILLE : "
cat $RootDos/$RootNom/index.txt | grep V | awk '{print $7}' | cut -d "/" -f 3 | cut -d "=" -f 2
echo "[*] CN de la CA FILLE : "
read -p "-> " CAFilleNom

echo "[*] Quel type de certificat souhaitez-vous faire ?"
echo "1 - Pour un client"
echo "2 - Pour un serveur"
read -p "-> " choix

case "$choix" in

1)	clear
	echo "###########################################################################"
	echo "Création d'un certificat client"
	echo "###########################################################################"
	echo ""

	echo "[*] Entrez le nom du certificat :"
	read -p "-> " cert_name
	
	mkdir -p $RootDos/$CAFilleNom/newcerts/$cert_name

	cd $RootDos/$CAFilleNom/newcerts/$cert_name

	echo "[*] Création d'un couple de clefs (publique/privée) pour le client $cert_name"
	openssl genrsa -out $RootDos/$CAFilleNom/newcerts/$cert_name/$cert_name.key -des3 2048

	echo "[*] Création d'un certificat non signé "
	openssl req -new -key $RootDos/$CAFilleNom/newcerts/$cert_name/$cert_name.key -out $RootDos/$CAFilleNom/newcerts/$cert_name/$cert_name.crs -config $RootDos/$CAFilleNom/$CAFilleNom.openssl.cnf

	echo "[*] Que l’on signe avec l’autorité fille ($CAFilleNom.pem)"
	openssl ca -out $RootDos/$CAFilleNom/newcerts/$cert_name/$cert_name.pem -name CA_ssl_default -config $RootDos/$CAFilleNom/$CAFilleNom.openssl.cnf -extensions CLIENT_RSA_SSL -infiles $RootDos/$CAFilleNom/newcerts/$cert_name/$cert_name.crs

	echo "[*] On transforme le .pem en .p12 qui est un format exécutable sous windows ou linux pour mettre en place facilement le certificat"
	openssl pkcs12 -export -inkey $RootDos/$CAFilleNom/newcerts/$cert_name/$cert_name.key -in $RootDos/$CAFilleNom/newcerts/$cert_name/$cert_name.pem -out $cert_name.p12 -name "Certificat client $cert_name"
	;;

2)	clear
	echo "###########################################################################"
	echo "Création d'un certificat serveur"
	echo "###########################################################################"
	echo ""

	echo "[*] Entrez le nom du certificat :"
	read -p "-> " cert_name
	
	mkdir -p $RootDos/$CAFilleNom/newcerts/$cert_name

	cd $RootDos/$CAFilleNom/newcerts/$cert_name

	echo "[*] Création d'un couple de clefs (publique/privée) pour le client $cert_name"
	openssl genrsa -out $RootDos/$CAFilleNom/newcerts/$cert_name/$cert_name.key -des3 2048

	echo "[*] Création d'un certificat non signé "
	openssl req -new -key $RootDos/$CAFilleNom/newcerts/$cert_name/$cert_name.key -out $RootDos/$CAFilleNom/newcerts/$cert_name/$cert_name.crs -config $RootDos/$CAFilleNom/$CAFilleNom.openssl.cnf

	echo "[*] Que l’on signe avec l’autorité fille ($CAFilleNom.pem)"
	openssl ca -out $RootDos/$CAFilleNom/newcerts/$cert_name/$cert_name.pem -name CA_ssl_default -config $RootDos/$CAFilleNom/$CAFilleNom.openssl.cnf -extensions SERVER_RSA_SSL -infiles $RootDos/$CAFilleNom/newcerts/$cert_name/$cert_name.crs
	;;

*)	echo "[!] Mauvaise saisie !"
	echo "[1] Pour un client"
	echo "[2] Pour un serveur"
   ;;
esac

