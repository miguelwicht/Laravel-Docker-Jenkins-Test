# Docker-Web-Template

Simple template for an Apache, PHP, mysql setup. Mounts mysql data directory for persistence and easy access. Includes script for image exports that can be imported in production.

## Project Structure

- \_data/
- \_export/ (created if needed)
- web/
- docker-compose.dev.yml
- docker-compose.prod.yml
- docker-compose.yml
- makefile

## Installation

### makefile

The first thing we need to do is to setup the PROJECT_NAME and the IMAGE_NAME in the makefile. Change it to something that makes sense and that let's you easily identify your docker image later on. The PROJECT_NAME will be used for the filename when you export an image.

### .env and .env.prod

To prevent files with sensitiv information from being commited to version control these file are not inluded and are even ignored in ```.gitignore```. There is an .env.example at the root directory of the project though that can be used as a template. Copy the file and change the default values where appropriate.

### docker-compose.yml

There are multiple docker-compose.yml files: a base file, one for development and one for production. The one for development and production are mainly used to configure different volume mounts. In development for example the ```web/html``` directory is mounted into the container so that code changes can take effect without having to export a new image or restart the container.

### The \_data directory

This directory will be used to store data that should persist the container life-cycle. Databases and user created files are a good example.
Directories in ```_data``` should match the services in docker-compose.yml.

### Custom php.ini settings
php.ini settings can be overwritten in ```/web/php.ini```. The container has to be rebuild for this to take effect.

### Use case Laravel

#### Setup Laravel
Use ```_utils/install_laravel.sh``` to install Laravel. This will download composer, delete the contents in ```web/html``` and then install Laravel there. It will also make a copy of the created storage directory in ```_data/web/```.

Place your .env files (```.env.dev``` and ```.env.prod```) in ```_data/web``` so that they can be mounted.

```
# Add the following volumes to docker-compose.dev.yml
- ./_data/web/storage:/var/www/html/storage
- ./_data/web/.env.dev:/var/www/html/.env

# Add the following volumes to docker-compose.prod.yml
- ../_data/web/storage:/var/www/html/storage
- ../_data/web/.env.prod:/var/www/html/.env
```

### General use case

- Copy your project files into ```/web/html```
- Change the Virtual Hosts in ```/web``` to fit your needs
- Rename ```.env.example``` to ```.env```
- Change the mysql password and database in ```.env```
- If necessary change the port mapping in ```.env```
- Change ```IMAGE_NAME``` and ```PROJECT_NAME``` in ```makefile```
- run ```make up```

### Export

Use ```make export``` to prepare a new image for deployment. The script will rebuild the web image and create a compressed archive that can be imported on the production system. It will also create a makefile that can be used to get everything running on the production system.

## Deprecated

For convenience you can use the composer.sh and node.sh scripts. Just make sure they are executable.

```
# composer.sh
./composer.sh "create-project --prefer-dist laravel/laravel ."

# node.sh
./node.sh "npm install"
```

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
