#!/bin/bash
# IMPORTANTE: este script se debe ejecutar con permisos sudo

delaytime=1 #variable delaytime, que determina el tiempo de los sleep

echo "----------------------------------------------------"
echo " "
echo "Script de configuracion de Firewall para DMZ, v.0.1"
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

#--------------------------------------------------------------configuracion del default gateway

# asignamos la IP 10.0.0.2/8 al dispositivo cliente

echo " "
echo "Asignando IP 30.0.0.2/8 a la interfaz ens33..."
echo " "
ip a flush dev ens33
ip a add 30.0.0.2/8 dev ens33
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
echo "Configurando default gateway 30.0.0.1"
echo " "
ip route add default via 30.0.0.1
echo " "
route -n
echo " "
echo "Gateway configurado correctamente."
echo " "
echo "----------------------------------------------------"
sleep $delaytime
