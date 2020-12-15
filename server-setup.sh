#!/bin/bash
# IMPORTANTE: este script se debe ejecutar con permisos sudo

delaytime=1 #variable delaytime, que determina el tiempo de los sleep

echo "----------------------------------------------------"
echo " "
echo "Script de configuracion de Servidor para DMZ, v.0.1"
echo "Por Sebastian Gutierrez y Jorge Martinez"
echo "INSO 2B, U-Tad"
echo " "
echo "----------------------------------------------------"
sleep $delaytime

#--------------------------------------------------------------comprobacion de permisos sudo

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

#--------------------------------------------------------------actualizacion del sistema previa a instalacion

echo " "
echo "Realizando actualizacion del sistema..."
echo " "
apt update -y && apt upgrade -y
echo " "
echo "----------------------------------------------------"
sleep $delaytime

#--------------------------------------------------------------instalacion del servidor web apache2 y servidor ssh
echo " "
echo "Instalando net-tools..."
echo " "
apt install net-tools -y
echo " "
echo "net-tools instalado correctamente"
echo " "
echo "Instalando servidor Apache2..."
echo " "
apt install apache2 -y
echo " "
echo "Servidor Apache2 instalado correctamente."
echo " "
sleep $delaytime
echo "Instalando servidor SSH..."
echo " "
apt install openssh-server -y
echo " "
echo "Servidor SSH instalado correctamente"
echo " "
echo "----------------------------------------------------"
sleep $delaytime

#--------------------------------------------------------------configuracion del default gateway

# asignamos la IP 20.0.0.2/8 al dispositivo cliente

echo " "
echo "Asignando IP 20.0.0.2/8 a la interfaz ens33..."
echo " "
ifconfig ens33 20.0.0.2/8
echo " "
echo "La interfaz se ha configurado correctamente"
echo " "
ens33_info=$(ip a | grep inet | grep ens33)
echo "$ens33_info"
echo " "
echo "----------------------------------------------------"
sleep $delaytime

#--------------------------------------------------------------configuracion del default gateway

# asignamos la IP de una de las interfaces del firewall como gateway del cliente.

echo " "
echo "Configurando default gateway 20.0.0.1"
echo " "
route add default gw 20.0.0.1
echo " "
route -n
echo " "
echo "Gateway configurado correctamente."
echo " "
echo "----------------------------------------------------"
sleep $delaytime
