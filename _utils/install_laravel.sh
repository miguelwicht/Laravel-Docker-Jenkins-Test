#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

prompt_confirm() {
	while true; do
		read -r -n 1 -p "${1:-Continue?} [y/n]: " REPLY
		case $REPLY in
			[yY]) echo ; return 0 ;;
			[nN]) echo ; return 1 ;;
			*) printf " \033[31m %s \n\033[0m" "invalid input"
		esac
	done
}

# Prompt the user if he really wants to execute this script as it will delete everything in ../web/html/
prompt_confirm "Do you want to continue? This will delete all files in ../web/html!" || exit 0

cd "$DIR"

# Get Composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('SHA384', 'composer-setup.php') === 'e115a8dc7871f15d853148a7fbac7da27d6c0030b848d9b3dc09e2a0388afed865e6a3d6b3c0fad45c48e2b5fc1196ae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"

# Remove default stuff in web/html
rm -rf ../web/html/*
rm -rf ../web/html/.[!.]*
rm -rf ../web/html/..?*

# install laravel
php composer.phar create-project --prefer-dist laravel/laravel ../web/html

# Move composer into ../web/html so that we can use it when we connect to the container
mv composer.phar ../web/html/composer.phar

# Make a copy of the storage directory that will be mounted into the container
cp -a ../web/html/storage ../_data/web/
