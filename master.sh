#!/bin/bash
###############################################################################
# Auteur : Alexis Cangelosi
# Promotion : ITI14M SR
# Theme : Evaluation de fin de semestre
# Titre : MASTER EXAM
###############################################################################

###############################################################################
# 								VARIABLES									  
###############################################################################

default_pki="/home/ubuntu/INTECH/PKI"
default_vpn="/home/ubuntu/INTECH/VPN/x509"
default_firewall="/home/ubuntu/INTECH/FIREWALL"
###############################################################################
# 								SCRIPT									  
###############################################################################

# Clean sheet
clear

# INTRO

echo "###########################################################################"
echo "MASTER"
echo "###########################################################################"
echo ""
echo "[*] Que voulez vous faire ?"
echo "[1] PKI"
echo "[2] VPN"
echo "[3] Firewall"
read -p "-> " choix

if [ $choix -eq 1 ] ; then

	clear
   	echo "###########################################################################"
   	echo "PKI"
   	echo "###########################################################################"
   	echo "[*] Que voulez vous faire ?"
	echo "[1] Add CA FILLE"
	echo "[2] Del CA FILLE"
	echo "[3] Add Certificat"
	echo "[4] Del Certificat"
	read -p "-> " choix

    if $choix -eq 1 ; then
		clear
		$default_pki/add_ca_fille.sh
	elif $choix -eq 2 ; then
		clear
		$default_pki/del_ca_fille.sh
	elif $choix -eq 3 ; then
		clear
		$default_pki/add_cert.sh
	elif $choix -eq 4 ; then
		clear
		$default_pki/del_cert.sh
	else
		echo "[!] Mauvaise saisie !"
		echo "[1] Add CA FILLE"
		echo "[2] Del CA FILLE"
		echo "[3] Add Certificat"
		echo "[4] Del Certificat"
	fi
	
elif [ $choix -eq 2 ] ; then	
	
	clear
	echo "###########################################################################"
   	echo "VPN"
   	echo "###########################################################################"
   	echo "[*] Que voulez vous faire ?"
	echo "[1] Add Server"
	echo "[2] Add Client"
	echo "[3] Activate Server"
	echo "[4] Del Server"
	echo "[5] Del Client"
	echo "[6] Desactivate Server"
	echo "[7] Activate Client-to-Client"
	echo "[8] Desactivate Client-to-Client"
	read -p "-> " choix

	if $choix -eq 1 ; then
		clear
		$default_vpn/add_x509_server.sh
	elif $choix -eq 2 ; then
		clear
		$default_vpn/add_x509_client.sh
	elif $choix -eq 3 ; then
		clear
		$default_vpn/activate_server.sh
	elif $choix -eq 4 ; then
		clear
		$default_vpn/del_x509_serveur.sh
	elif $choix -eq 5 ; then
		clear
		$default_vpn/del_x509_client.sh
	elif $choix -eq 6 ; then
		clear
		$default_vpn/desactivate_server.sh
	elif $choix -eq 7 ; then
		clear
		$default_vpn/activate_ctc.sh
	elif $choix -eq 8 ; then
		clear
		$default_vpn/desactivate_ctc.sh
	else
		echo "[!] Mauvaise saisie !"
		echo "[1] Add Server"
		echo "[2] Add Client"
		echo "[3] Activate Server"
		echo "[4] Del Server"
		echo "[5] Del Client"
		echo "[6] Desactivate Server"
		echo "[7] Activate Client-to-Client"
		echo "[8] Desactivate Client-to-Client"
	fi

elif [ $choix -eq 3 ] ; then
	
	clear
	echo "###########################################################################"
   	echo "VPN"
   	echo "###########################################################################"

else
	echo "[!] Mauvaise saisie !"
	echo "[1] PKI"
	echo "[2] VPN"
	echo "[3] Firewall"
fi
