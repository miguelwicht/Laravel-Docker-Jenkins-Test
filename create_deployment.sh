#!/bin/bash

PROJECT_NAME=$1
IMAGE_NAME=$2
RELEASE_REFERENCE=$(git log -1 --pretty=oneline | sed -E "s/^([^[:space:]]+).*/\1/" 2>&1)
EXPORT_PATH="_export/${RELEASE_REFERENCE}"
EXPORT_PATH_ENV="${EXPORT_PATH}/.env"
EXPORT_IMAGE_NAME="${PROJECT_NAME}-${RELEASE_REFERENCE}.tar.gz"

mkdir -p ${EXPORT_PATH}/_data/web/

# Copy files
cp docker-compose.yml ${EXPORT_PATH}/docker-compose.yml
cp docker-compose.prod.yml ${EXPORT_PATH}/docker-compose.override.yml

if [ -e ".env.prod" ]
then
	cp .env.prod ${EXPORT_PATH_ENV}
else
	echo "Could not find: .env.prod"
fi

if [ -e "_data/web/.env.prod" ]
then
	cp _data/web/.env.prod ${EXPORT_PATH}/_data/web/.env.prod
else
	echo "Could not find: _data/web/.env.prod"
fi

cd ${EXPORT_PATH}

if [ -e ".env" ]
then
	sed -i "" -e "s/####WEB_IMAGE_HASH####/${RELEASE_REFERENCE}/g" ".env"
else
	echo "Did not replace ####WEB_IMAGE_HASH#### in .env"
fi

# Rewrite docker-compose.yml so that it will use our new image
sed -i "" -e "s|\${WEB_IMAGE}|${IMAGE_NAME}:${RELEASE_REFERENCE}|g" "docker-compose.yml"

# Create makefile
cat > makefile <<EOF
up:
	@docker-compose up -d
import:
	@docker load < ${EXPORT_IMAGE_NAME}
symlinks:
	@./create_symlinks.sh
EOF

# Create helper script for linking production config
cat > create_symlinks.sh <<EOF
#!/bin/bash

# exit if a commands fails
set -e

PARENT=\${PWD%/*}

ln -fs "\$PARENT/_data/.env.prod"  "\$(pwd)/.env"
EOF
chmod +x create_symlinks.sh

# Go back to web
cd ../../web/
#docker build -t ${IMAGE_NAME}:${RELEASE_REFERENCE} .

cd ../${EXPORT_PATH}

#docker save ${IMAGE_NAME}:${RELEASE_REFERENCE} | gzip > ${EXPORT_IMAGE_NAME}

echo "Created Image: ${IMAGE_NAME}:${RELEASE_REFERENCE}. Exported as ${EXPORT_IMAGE_NAME}."
