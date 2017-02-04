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

# Prompt the user if he really wants to execute this script as it will delete everything in /var/www/html/
prompt_confirm "Do you want to continue? This will delete all files in /var/www/html!" || exit 0

cd "$DIR"

# Get Composer
/bin/bash install_composer.sh

# Remove default stuff in web/html
rm -rf /var/www/html/*
rm -rf /var/www/html/.[!.]*
rm -rf /var/www/html/..?*

# install laravel
php composer.phar create-project --prefer-dist laravel/laravel /var/www/html/

# Move composer into ../web/html so that we can use it when we connect to the container
mv composer.phar /var/www/html/composer.phar
