# Docker-Web-Template

Simple template for an Apache, PHP, mysql setup. Mounts mysql data directory and apache log files for persistence and easy access.

## How to use

- Copy your project files into ```/src```
- Change the Virtual Hosts in ```/misc/apache/vhosts``` to fit your needs
- Change the mysql password and database in ```docker-compose.yml```
- If necessary change the port mapping in ```docker-compose.yml```
- run ```docker-compose up -d```
