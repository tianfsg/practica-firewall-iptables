# DMZ-scripts
Automatic setup scripts for a Kali-based firewall used in a local network + DMZ network environment.

A project by Sebastian Francisco Gutierrez & Jorge Martinez Hurtado, 2nd year Software Engineering Students @ U-Tad

# The problem:
A fictional company has hired us as security consultants. Our first job is to create their network security infrastructure using a Linux-based firewall. Said firewall will be set up using rules with iptables.

The company is asking for an infrastructure that has:

- A Local network (192.168.1.0/24): devices on this network should only be allowed to browse the Internet (HTTP + HTTPS) and the company's intranet. SSH traffic is allowed as long as it's used to access the web server located in the DMZ.
- A DMZ network: inside this network, an HTTP server has to be set up. Said server can be accessed publicly from the internet, and only managed through SSH from the local network.

As we're working with a DMZ network, both networks need to be fully independent and secure. Using the Linux-based firewall, we can protect the local network against external attackers and access from the HTTP server, which must also be protected against unauthorised SSH logins.
