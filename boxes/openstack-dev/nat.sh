/sbin/iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
/sbin/iptables -A FORWARD -i eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
/sbin/iptables -A FORWARD -o eth0 -j ACCEPT
