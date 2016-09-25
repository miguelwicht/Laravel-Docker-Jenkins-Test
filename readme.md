# Docker-Web-Template

Simple template for an Apache, PHP, mysql setup. Mounts mysql data directory and apache log files for persistence and easy access.

## How to use

- Copy your project files into ```/web/html```
- Change the Virtual Hosts in ```/web``` to fit your needs
- Rename ```.env.example``` to ```.env```
- Change the mysql password and database in ```.env```
- If necessary change the port mapping in ```.env```
- Change ```IMAGE_NAME``` and ```PROJECT_NAME``` in ```makefile```
- run ```make up```

### Custom php.ini settings
php.ini settings can be overwritten in ```/web/php.ini```. The container has to be rebuild for this to take effect.

### Composer and NPM

Composer and npm are not included in this image but you can use the official images.

```
# Change into the src directory (all other commands are called from there!)
cd src/

# Composer
docker run --rm -v "$(pwd):/app" composer/composer:php5 composer-command-to-run

## Laravel installation as an example (installs laravel in the current folder)
rm -rf .gitkeep
docker run --rm -v "$(pwd):/app" composer/composer:php5 create-project --prefer-dist laravel/laravel .

# NPM and Gulp
docker run --rm -v "$(pwd)/web/html:/app" -w="/app" node npm install
docker run --rm -v "$(pwd)/web/html:/app" -w="/app" node node_modules/.bin/gulp
```

For convenience you can use the composer.sh and node.sh scripts. Just make sure they are executable.

```
# composer.sh
./composer.sh "create-project --prefer-dist laravel/laravel ."

# node.sh
./node.sh "npm install"
```

### Export

Use ```make export``` to prepare a new image for deployment. The script will rebuild the web image and create a compressed archive that can be imported on the production system. It will also create a makefile that can be used to get everything running on the production system.

### Laravel

Move the ```storage``` directory to ```_data/web/storage``` and make sure everything is writable by www-data. The .env files (```.env.dev``` and ```.env.prod```) should also be placed in ```_data/web```.

```
# Add the following volumes to docker-compose.dev.yml
- ./_data/web/storage:/var/www/html/storage
- ./_data/web/.env.dev:/var/www/html/.env

# Add the following volumes to docker-compose.prod.yml
- ../_data/web/storage:/var/www/html/storage
- ../_data/web/.env.prod:/var/www/html/.env
```
