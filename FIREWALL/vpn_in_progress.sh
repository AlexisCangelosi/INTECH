
# Allow traffic initiated from VPN to access LAN
iptables -I FORWARD -i tun1 -o eth0 -s 10.8.1.0/24 -d 192.168.0.0/24 -m conntrack --ctstate NEW -j ACCEPT

# Allow traffic initiated from VPN to access 'the world'
iptables -I FORWARD -i tun1 -o eth0 -s 10.8.1.0/24 -m conntrack --ctstate NEW -j ACCEPT

# Allow traffic initiated from LAN to access 'the world'
iptables -I FORWARD -i eth0 -o eth0 -s 192.168.0.0/24 -m conntrack --ctstate NEW -j ACCEPT

# Allow established traffic to pass back and forth
iptables -I FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# Notice that -I is used, so when listing it (iptables -vxnL) 
# will be reversed.  This is intentional in this demonstration.

# Masquerade traffic from VPN to 'the world' -- done in the nat table
iptables -t nat -I POSTROUTING -o eth0 -s 10.8.1.0/24 -j MASQUERADE

# Masquerade traffic from LAN to 'the world'
iptables -t nat -I POSTROUTING -o eth0 -s 192.168.0.0/24 -j MASQUERADE
