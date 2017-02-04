# Docker-Web-Template

Simple template for an Apache, PHP, MySQL setup. Includes script for image exports that can be imported in production.

## Project Structure

- \_data/
- \_export/ (created if needed)
- \_helpers/
- \_utils/
- web/
- docker-compose.override.yml
- docker-compose.prod.yml
- docker-compose.yml
- makefile

### The ```_*``` directories

These directories can include scripts and mount points. The ```_``` is used to differentiate the directories from services.

#### The ```_data``` directory

This directory will be used to store data that should persist the container life-cycle. Databases and user created files are a good example.
Directories in ```_data``` should match the services in docker-compose.yml.

#### The ```_helpers``` directory

This directory includes scripts that can be run from the host machine.

#### The ```_utils``` directory

This directory includes scripts that can be run form within the web container. In a development environment it is mounted to ```/var/www/_utils```.

### Service directories

Directories that are not prefixed with a ```_``` should only be used to represent a service from ```docker-compose.yml```. This allows each service to have a different dockerfile and build context as well as a standardized location for config files.

```
# Service directory structure
service/
  |- src/ # services source
    |- # services source code e.g. laravel app
  |- .dockerignore
  |- dockerfile
  |- dockerfile-dev
  |- # other config files
```

## Installation

### makefile

The first thing we need to do is to setup the PROJECT_NAME and the IMAGE_NAME in the makefile. Change it to something that makes sense and that let's you easily identify your docker image later on. The PROJECT_NAME will be used for the filename when you export an image.

### .env and .env.prod

To prevent files with sensitiv information from being commited to version control these file are not inluded and are even ignored in ```.gitignore```. There is an .env.example at the root directory of the project though that can be used as a template. Copy the file and change the default values where appropriate.

### docker-compose.yml

There are multiple docker-compose.yml files: a base file, one for development and one for production. The one for development and production are mainly used to configure different volume mounts. In development for example the ```web/html``` directory is mounted into the container so that code changes can take effect without having to export a new image or restart the container.


### Custom php.ini settings
php.ini settings can be overwritten in ```/web/php.ini```. The container has to be rebuild for this to take effect.

### Use case Laravel

#### Setup Laravel
Use ```_utils/install_laravel.sh``` to install Laravel. This will download composer, delete the contents in ```web/html``` and then install Laravel there. The script has to be run from within the container so log into the container with ```docker exec``` and run the script from there. The script is mounted at ```/var/www/_utils/```.

Place your production .env file in ```_data/web``` so that it can be mounted.

```
# Add the following volumes to docker-compose.prod.yml
- ../_data/web/storage:/var/www/html/storage
- ../_data/web/.env.prod:/var/www/html/.env
```

### General use case

- Copy your project files into ```/web/src```
- Change the Virtual Hosts in ```/web``` to fit your needs
- Rename ```.env.example``` to ```.env```
- Change the mysql password and database in ```.env```
- If necessary change the port mapping in ```.env```
- Change ```IMAGE_NAME``` and ```PROJECT_NAME``` in ```makefile```
- run ```make up```

### Export

Use ```make export``` to prepare a new image for deployment. The script will rebuild the web image and create a compressed archive that can be imported on the production system. It will also create a makefile that can be used to get everything running on the production system.

### Composer and node.js

### Node.js

Composer can be installed with the install_composer.sh script from within the web container.

```
php /var/www/_utils/composer.phar install
```

For convenience you can use the node.sh script. Just make sure they are executable.

```
# install packages
_helpers/node.sh "npm install"

# run gulp
_helpers/node.sh "node_modules/.bin/gulp"

# run webpack (laravel)
_helpers/node.sh "npm run dev"
_helpers/node.sh "npm run production"
_helpers/node.sh "npm run watch"
```
