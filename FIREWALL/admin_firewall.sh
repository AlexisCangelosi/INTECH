#!/bin/sh
###############################################################################
#		SCRIPT ADMINISTRATION REGLES DE FIREWALLING		      #
###############################################################################

echo "QUE VOULEZ-VOUS ADMINISTRER ?"
echo "1 - Regles de redirection"
echo "2 - Regles de filtrage"
echo "3 - Activation/Desactivation NAT"

read choix

if [ $choix = "1" ] ; then
	echo "Sur quel protocole ?[TCP/UDP]"
	echo "1 - TCP"
	echo "2 - UDP"
	read proto
		if [ $proto = "1" ]; then
			proto="tcp"
		elif [ $proto = "2" ]; then
			proto="udp"
		else
			proto=""
		fi

	echo "Protocole : $proto"

	echo "Le port de destination exterieur ?"
	read port_dst_ext
	
	echo "Le protocole : $proto / Le port dst ext : $port_dst_ext"

	echo "L'adresse IP du LAN ?"
	read ip_lan
	
	echo "Le protocole : $proto / Le port dst ext : $port_dst_ext / IP : $ip_lan"

	echo "Le port de destination interieur?"
	read port_dst_int

	echo "Le protocole : $proto / Le port dst ext : $port_dst_ext / IP : $ip_lan / Le port dst int : $port_dst_int"
	
	iptables -t nat -A PREROUTING -i $ip_lan -p $proto --dport $port_dst_int -j REDIRECT --to-port $port_dst_ext


elif [ $choix = "2" ] ; then
	
	echo "Sur quel protocole ?[TCP/UDP] (Vide par defaut)"
	echo "1 - TCP"
	echo "2 - UDP"
	read proto
		if [ $proto = "1" ]; then
			proto="tcp"
		elif [ $proto = "2" ]; then
			proto="udp"
		else
			proto=""
		fi

	echo "Protocole : $proto"

	echo "IP SOURCE ? (Vide par defaut)"
	read ip_src
	
	echo "Le protocole : $proto / IP SOURCE : $ip_src"

	echo "IP DE DESTINATION (Vide par defaut)?"
	read ip_dst
	
	echo "Le protocole : $proto / IP SOURCE : $ip_src / IP DST : $ip_dst"
	echo "PORT SOURCE ? (Vide par defaut)"
	read port_src
	
	echo "Le protocole : $proto / IP SOURCE : $ip_src / IP DST : $ip_dst / PORT SRC : $port_src"

	echo "PORT DE DESTINATION (Vide par defaut)?"
	read port_dst
	
	echo "Le protocole : $proto / IP SOURCE : $ip_src / IP DST : $ip_dst / PORT SRC : $port_src / PORT DST : $port_dst"

	echo "Ajouter une regle AUTORISANT ou INTERDISANT ce type de connexion ?"
	echo "1- AUTORISER"
	echo "2- INTERDIRE"
	read loi
	if [ $loi = "1" ]; then
		loi=" -j ACCEPT"
	elif [ $loi = "2" ]; then
		loi=" -j DROP"
	else
		loi=""
	fi
	#####################################################
	#	INITIALISAITON DE LA VARIABLE REGLE	    #
	#####################################################
	
	rule="iptables -t filter -A FORWARD -m state --state NEW"

	if [ $proto = "tcp" ]; then
		proto=" -p $proto --syn"
	elif [ $proto = "udp" ]; then
		proto=" -p $proto"
	else
		proto=" -p all"
	fi
	rule="$rule$proto"

	if [ -z "$port_dst" ]; then
		echo ""
	else
		if [ -z "$proto" ]; then
			echo "IL FAUT SPEFICIER UN PROTOCOLE OBLIGATOIREMENT LORSQUE VOUS DONNEZ UN PORT!"
		else
			port_dst=" --dport $port_dst"
			rule="$rule$port_dst"
		fi
	fi

	if [ -z "$port_src" ]; then
		echo ""
	else
		if [ -z "$proto" ]; then
			echo "IL FAUT SPEFICIER UN PROTOCOLE OBLIGATOIREMENT LORSQUE VOUS DONNEZ UN PORT!"
		else
			port_src=" --sport $port_src"
			rule="$rule$port_src"
		fi
	fi

	if [ -z "$ip_dst" ]; then
		echo ""
	else
		ip_dst=" -d $ip_dst"
		rule="$rule$ip_dst"
	fi

	if [ -z "$ip_src" ]; then
		echo ""
	else
		ip_src=" -s $ip_src"
		rule="$rule$ip_src"
	fi

	rule="$rule$loi"

	echo $rule
	eval "$rule"

elif [ $choix = "3" ] ; then

	echo "ACTIVER OU DESACTIVER LE NAT ?"
	echo "1- ACTIVER NAT"
	echo "2- DESACTIVER NAT"
	read nat

	if [ $nat = "1" ]; then
		iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE	
	elif [ $nat = "2" ]; then
		iptables -t nat -F
	else

		echo "ERREUR"
	
	fi
else
	echo "ERREUR FUCKING FATAAAAALLLE"
fi
