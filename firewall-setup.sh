#!/bin/bash
# IMPORTANTE: este script se debe ejecutar con permisos sudo.

delaytime=1 #variable delaytime; determina el tiempo de los sleep

echo "----------------------------------------------------"
echo " "
echo "Script de configuracion de Firewall para DMZ, v.0.1"
echo "Por Sebastian Gutierrez y Jorge Martinez"
echo "INSO 2B, U-Tad"
echo " "
echo "----------------------------------------------------"
sleep $delaytime
echo " "
echo "Comprobando permisos sudo..."

if [ "$EUID" -ne 0 ]; then #si el ID de usuario no es 0 (root), termina la ejecucion.
	echo " "
	echo "ERROR: Permisos sudo no detectados." 
	echo "Por favor, ejecuta el script como root."
	echo " "
	echo "----------------------------------------------------"
	exit 1
fi

echo "Permisos sudo detectados. Iniciando configuracion..."
echo " "
echo "----------------------------------------------------"
sleep $delaytime

#--------------------------------------------------------------configuracion del default gateway

echo " "
echo "Asignando 192.168.1.1 como default gateway..."
route add default gw 192.168.1.1
/etc/init.d/networking restart
echo " "
def_gateway=$(/sbin/ip route | awk '/default/ { print $3 }')
echo "El default gateway configurado es: $def_gateway"
echo " "
echo "----------------------------------------------------"
sleep $delaytime

#--------------------------------------------------------------activacion de ip forward:

echo " "
echo "Activando IP Forward..."
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf #cambio permanente en el archivo sysctl.conf.
sudo sysctl -p #pides a sysctl revisar los cambios en la configuracion; deberia salir el net.ipv4.ip_forward = 1.
/etc/init.d/networking restart #reinicias el servicio de networking para aplicar los cambios
ipfwd_status=$(cat /proc/sys/net/ipv4/ip_forward) #la variable ipfwd_status toma el valor del estado de ip forward: 1, activo; 0, inactivo.
echo " "

# si IP Forward no esta activado (valor distinto de 1), entonces devuelve mensaje de error.
if [ "$ipfwd_status" != "1" ]; then
	echo "Error activando IP Forward."
	exit 1
fi

echo "Estado de IP Forward: $ipfwd_status"
echo "IP Forwarding activado satisfactoriamente."
echo " "
echo "----------------------------------------------------"
sleep $delaytime

#--------------------------------------------------------------configuracion de ip estaticas

echo " "
echo "Configurando interfaces de red..."
echo " "
echo "Se va a realizar la siguiente asignacion de IP:"
echo " "
echo " - eth0: 30.0.0.1/8 --> Red Local"
echo " - eth2: 20.0.0.1/8 --> Red DMZ"
echo " - eth1: IP DINAMICA --> Firewall"
echo " "
ifconfig eth0 30.0.0.1/8
ifconfig eth2 20.0.0.1/8
dhclient eth1
echo " "
sleep $delaytime
echo "Las IP se han configurado satisfactoriamente:"
echo " "
eth0_info=$(ip a | grep inet | grep eth0)
eth2_info=$(ip a | grep inet | grep eth2)
eth1_info=$(ip a | grep inet | grep eth1)
echo "- eth0: $eth0_info"
echo "- eth2: $eth2_info"
echo "- eth1: $eth1_info"
echo " "
sleep $delaytime
echo "----------------------------------------------------"

#--------------------------------------------------------------configuracion de reglas de firewall
echo " "
echo "Configurando firewall..."
echo " "
#Reseteamos las normas
iptables -F
iptables -X
iptables -Z
iptables -t nat -F

#Cerramos todo el acceso y habilitamos DNAT y SNAT
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP
iptables -t nat -P PREROUTING ACCEPT
iptables -t nat -P POSTROUTING ACCEPT

#En teoria habilitamos todos los puertos del firewall de manera forward para que pasen a traves de el
iptables -A FORWARD -i eth0 -o eth2 -p tcp --dport 80 -j ACCEPT
iptables -A FORWARD -i eth0 -o eth2 -p tcp --dport 443 -j ACCEPT
iptables -A FORWARD -i eth0 -o eth2 -p tcp --dport 53 -j ACCEPT
iptables -A FORWARD -i eth0 -o eth2 -p udp --dport 53 -j ACCEPT
#Reciprocidad para todas las reglas anteriores
iptables -A FORWARD -i eth0 -o eth2 -p tcp -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -t nat -A POSTROUTING -s 30.0.0.0/8 -o eth2 -j MASQUERADE

#Para que entre de internet la peticion al DMZ
iptables -A FORWARD -i eth2 -o eth1 -p tcp --dport 80 -j ACCEPT
iptables -A FORWARD -i eth2 -o eth1 -p tcp -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -t nat -A PREROUTING -i eth2 -p tcp --dport 80 -j DNAT --to 20.0.0.2:80

#Control de paso de entre el DMZ y el Cliente (FUNCIONANDO EN PERFECTO ESTADO)
iptables -A FORWARD -s 30.0.0.0/8 -d 20.0.0.0/8 -p tcp --dport=80 -j ACCEPT
iptables -A FORWARD -s 30.0.0.0/8 -d 20.0.0.0/8 -p tcp --dport=22 -j ACCEPT
iptables -A FORWARD -p tcp -m state --state ESTABLISHED,RELATED -j ACCEPT

iptables -L

sleep $delaytime
echo " "
echo "Setup completo."
echo " "
echo "----------------------------------------------------"

