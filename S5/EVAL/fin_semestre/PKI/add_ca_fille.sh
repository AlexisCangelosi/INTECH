#!/bin/bash
###############################################################################
# Auteur : Alexis Cangelosi
# Promotion : ITI14M SR
# Theme : Evaluation de fin de semestre
# Titre : Création autorité de certification fille [AUTOMATISATION]
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

# PARTIE 1 : On test si le Root pki existe, si non on le créer

if [ ! -d $RootDos ] ; then
	echo "###########################################################################"
	echo "Création de $RootNom"
	echo "###########################################################################"
	echo ""

	echo "Le script va créer automatiquement le CA, veuillez suivre les eventuelles instructions qui vous seront demandees !"
	echo ""
	echo "[*] Création d'un repertoire contenant la PKI"
	mkdir $RootDos
	cp $Home/pki/openssl.cnf.sample $RootDos/openssl.cnf
	cd $RootDos

	echo "[*] Création du répertoire recueillant les certificats émis par CA ROOT"
	mkdir -p $RootNom/{newcerts,revoked_ca}

	echo "[*] Création de la base de données des certificats émis"		
	touch $RootNom/index.txt		
	echo '01' > $RootNom/serial

	#  PARTIE 2 : Création des clefs et des certificats

	echo "[*] Création d'un couple de clefs (publique/privée)"
	openssl genrsa -out $RootNom/$RootNom.key -des3 2048
	clear

	echo "[*] Création d'un certificat autosigné (il est le certificat racine)"
	openssl req -new -x509 -key $RootNom/$RootNom.key -out $RootNom/$RootNom.pem -config $RootDos/openssl.cnf -extensions CA_ROOT

	echo "[*]Voici votre certificat qui est lisible avec une commande openssl (le certificat est au format .pem et donc pas lisible sous unix)"
	openssl x509 -in $RootNom/$RootNom.pem -text -noout

	echo "###########################################################################"
	echo "Création de l'autorité de certification fille "
	echo "###########################################################################"
	echo ""

	echo "[*] Création des mêmes répertoires que le CA ROOT pour la CA FILLE"
	mkdir -p $CAFilleNom/newcerts	
	touch $CAFilleNom/index.txt
	echo '01' > $CAFilleNom/serial

	echo "[*] Création d'un couple de clefs (publique/privée) pour la CA FILLE"
	openssl genrsa -out $CAFilleNom/$CAFilleNom.key -des3 2048

	echo "[*] Création d'un certificat non signé"
	openssl req -new -key $CAFilleNom/$CAFilleNom.key -out $CAFilleNom/$CAFilleNom.crs -config $RootDos/openssl.cnf

	echo "[*] On signe le certificat avec la clef privée de l’autorité (CA ROOT)"
	openssl ca -out $CAFilleNom/$CAFilleNom.pem -config $RootDos/openssl.cnf -extensions CA_SSL -infiles $CAFilleNom/$CAFilleNom.crs


# PARTIE 2 : On créer l'autorité de certification fille 

else
	echo "###########################################################################"
	echo "Création d'une autorité de certification fille "
	echo "###########################################################################"
	echo ""

	# On se met dans le repertoire du PKI
	cd $RootDos

	echo "[*] Nom de l'autorité ?"
	read CANewName

	echo "[*] Création des mêmes répertoires que le CA ROOT pour la CA FILLE"
	mkdir -p $CANewName/newcerts	
	touch $CANewName/index.txt
	echo '01' > $CANewName/serial
	echo "
            [ ca ]
            default_ca      = CA_default

            [ CA_default ]
            dir             = .
            certs           = $RootDos/ROOT_CBI/certs
            new_certs_dir   = $RootDos/ROOT_CBI/newcerts
            database        = $RootDos/ROOT_CBI/index.txt
            certificate     = $RootDos/ROOT_CBI/ROOT_CBI.pem
            serial          = $RootDos/ROOT_CBI/serial
            private_key     = $RootDos/ROOT_CBI/ROOT_CBI.key
            default_days    = 365
            default_md      = sha1
            preserve        = no
            policy          = policy_match

            [ CA_ssl_default ]
            dir             = .
            certs           = $RootDos/$certs
            new_certs_dir   = $RootDos/$CANewName/newcerts
            database        = $RootDos/$CANewName/index.txt
            certificate     = $RootDos/$CANewName/$CANewName.pem
            serial          = $RootDos/$CANewName/serial
            private_key     = $RootDos/$CANewName/$CANewName.key
            default_days    = 365
            default_md      = sha1
            preserve        = no
            policy          = policy_match

            [ policy_match ]
            countryName             = match
            stateOrProvinceName     = match
            localityName		= match
            organizationName        = match
            organizationalUnitName  = optional
            commonName              = supplied
            emailAddress            = optional

            [ req ]
            distinguished_name      = req_distinguished_name

            [ req_distinguished_name ]
            countryName                     = Pays
		countryName_default             = FR
		stateOrProvinceName             = Departement
		stateOrProvinceName_default     = Ile-de-France
		localityName                    = Ville
		localityName_default            = Ivry Sur Seine
		organizationName        	  = Organisation
		organizationName_default        = CantBreakIt
            commonName                      = Name
            commonName_default              = $CANewName
            commonName_max                  = 64
            emailAddress                    = example@name.fr
            emailAddress_max                = 40

            [CA_ROOT]
            nsComment                       = \"CA Racine\"
            subjectKeyIdentifier            = hash
            authorityKeyIdentifier          = keyid,issuer:always
            basicConstraints                = critical,CA:TRUE,pathlen:1
            keyUsage                        = keyCertSign, cRLSign

            [CA_SSL]
            nsComment                       = \"CA SSL\"
            basicConstraints                = critical,CA:TRUE,pathlen:0
            subjectKeyIdentifier            = hash
            authorityKeyIdentifier          = keyid,issuer:always
            issuerAltName                   = issuer:copy
            keyUsage                        = keyCertSign, cRLSign
            nsCertType                      = sslCA

            [SERVER_RSA_SSL]
            nsComment                       = \"Certificat Serveur SSL\"
            subjectKeyIdentifier            = hash
            authorityKeyIdentifier          = keyid,issuer:always
            issuerAltName                   = issuer:copy
            subjectAltName                  = DNS:www.webserver.com, DNS:www.webserver-bis.com
            basicConstraints                = critical,CA:FALSE
            keyUsage                        = digitalSignature, nonRepudiation, keyEncipherment
            nsCertType                      = server
            extendedKeyUsage                = serverAuth

            [CLIENT_RSA_SSL]
            nsComment                       = \"Certificat Client SSL\"
            subjectKeyIdentifier            = hash
            authorityKeyIdentifier          = keyid,issuer:always
            issuerAltName                   = issuer:copy
            subjectAltName                  = critical,email:copy,email:user-bis@domain.com,email:user-ter@domain.com
            basicConstraints                = critical,CA:FALSE
            keyUsage                        = digitalSignature, nonRepudiation
            nsCertType                      = client
            extendedKeyUsage                = clientAuth
    " >> $RootDos/$CANewName/$CANewName.openssl.cnf

	echo "[*] Création d'un couple de clefs (publique/privée) pour la CA FILLE"
	openssl genrsa -out $CANewName/$CANewName.key -des3 2048

	echo "[*] Création d'un certificat non signé"
	openssl req -new -key $CANewName/$CANewName.key -out $CANewName/$CANewName.crs -config $RootDos/$CANewName/$CANewName.openssl.cnf

	echo "[*] On signe le certificat avec la clef privée de l’autorité (CA ROOT)"
	openssl ca -out $CANewName/$CANewName.pem -config $RootDos/$CANewName/$CANewName.openssl.cnf -extensions CA_SSL -infiles $CANewName/$CANewName.crs

fi