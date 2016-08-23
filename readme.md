# Docker-Web-Template

Simple template for an Apache, PHP, mysql setup. Mounts mysql data directory and apache log files for persistence and easy access.

## How to use

- Copy your project files into ```/src```
- Change the Virtual Hosts in ```/misc/apache/vhosts``` to fit your needs
- Rename ```.env.example``` to ```.env```
- Change the mysql password and database in ```.env```
- If necessary change the port mapping in ```.env```
- run ```docker-compose up -d```

## Composer and NPM

Composer and npm are not included in this image but you can use the official images.

```
# Change into the src directory
cd src/

# Composer
docker run --rm -v "$(pwd)":/app composer/composer:php5 composer-command-to-run

## Laravel installation as an example (installs laravel in the current folder)
docker run --rm -v "$(pwd)":/app composer/composer:php5 create-project --prefer-dist laravel/laravel .

# NPM and Gulp
docker run --rm -v "$(pwd)":"/app" -w="/app" node npm install
docker run --rm -v "$(pwd)":"/app" -w="/app" node node_modules/.bin/gulp
```

For convenience you can use the composer.sh and node.sh scripts. Just make sure they are executable.

```
# composer.sh
./composer.sh "create-project --prefer-dist laravel/laravel ."

# node.sh
./node.sh "npm install"
```
