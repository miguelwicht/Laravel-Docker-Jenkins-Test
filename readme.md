# Docker-Web-Template

Simple template for an Apache, PHP, mysql setup. Mounts mysql data directory and apache log files for persistence and easy access.

## How to use

- Copy your project files into ```/src```
- Change the Virtual Hosts in ```/mnt/apache2/vhosts``` to fit your needs
- Rename ```.env.example``` to ```.env```
- Change the mysql password and database in ```.env```
- If necessary change the port mapping in ```.env```
- run ```docker-compose up -d```

### Custom php.ini settings
php.ini settings can be overwritten in ```/mnt/php/php.ini```. The container has to be restarted for the settings to take effect.

### Composer and NPM

Composer and npm are not included in this image but you can use the official images.

```
# Change into the src directory (all other commands are called from there!)
cd src/

# Composer
docker run --rm -v "$(pwd)":/app composer/composer:php5 composer-command-to-run

## Laravel installation as an example (installs laravel in the current folder)
rm -rf .gitkeep
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
