#!/bin/bash
# IMPORTANTE: este script se debe ejecutar con permisos sudo.

echo "----------------------------------------------------"
echo " "
echo "Script de configuracion de Firewall para DMZ, v.0.1"
echo "Por Sebastian Gutierrez y Jorge Martinez"
echo "INSO 2B, U-Tad"
echo " "
echo "----------------------------------------------------"
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

#--------------------------------------------------------------configuracion del default gateway

echo " "
echo "Asignando 192.168.1.1 como default gateway..."
echo "gateway 192.168.1.1" >> /etc/network/interfaces
/etc/init.d/networking restart
echo " "
def_gateway=$(/sbin/ip route | awk '/default/ { print $3 }')
echo "El default gateway configurado es: $def_gateway"
echo " "
echo "----------------------------------------------------"

#--------------------------------------------------------------eliminar default gateway????





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
