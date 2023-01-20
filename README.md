# Práctica de Firewall con iptables

Scripts de configuración automáticos para un firewall basado en Kali Linux en una arquitectura de red con una Red Local y una Red DMZ.

# El problema:
Una empresa ficticia nos ha contratado como consultores de seguridad. Nuestro primer trabajo es crear su infraestructura de red usando un firewall basado en Linux. Dicho firewall se configuará utilizando reglas con iptables.

La infraestructura de la empresa debe tener:

- Red Local (30.0.0.0/8): los dispositivos conectados a esta red sólo pueden navegar por Internet (HTTP + HTTPS) y acceder por SSH únicamente al servidor localizado en la Red DMZ.

- Red DMZ (20.0.0.0/8): en esta red únicamente se encuentra un servidor Apache2 HTTP. Dicho servidor ha de ser públicamente accesible desde Internet, y accesible por SSH únicamente desde la Red Local de la empresa (30.0.0.0/8).

Dado que estamos trabajando con una Red DMZ, esta ha de ser aislada y dotada de la seguridad pertinente. Usando el firewall basado en Linux, podemos dotar a la infraestructura de la seguridad necesaria contra amenazas externas.

# Autores

Proyecto realizado por [Sebastián Gutiérrez](https://github.com/tianfsg) y [Jorge Martínez](https://github.com/nothing4free), estudiantes de segundo año de Ingeniería del Software en U-Tad.
