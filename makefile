# Define names for the export
PROJECT_NAME := "PROJECT-NAME"
IMAGE_NAME := "USERNAME/IMAGE"

# Docker-Compose commands
up:
	@docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d
stop:
	@docker-compose stop
build:
	@docker-compose build
down:
	@docker-compose down
ps:
	@docker ps
psa:
	docker ps -a
cps:
	@docker-compose ps
img:
	@docker images

# Deployment
export:
	@if [ "${PROJECT_NAME}" = "PROJECT-NAME" ] || [ "${IMAGE_NAME}" = "USERNAME/IMAGE" ]; then\
		echo "Change the project and image names";\
	else\
		./create_deployment.sh "$(PROJECT_NAME)" "$(IMAGE_NAME)";\
	fi
