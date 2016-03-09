#!/bin/bash

DOCKER_COMPOSE=$(type docker-compose);

if [[ "$DOCKER_COMPOSE" = "docker-compose not found" ]]; then
  echo "You must have docker-compose installed to boot the application";
  exit 0;
fi

eval $(docker-machine env default)

RUNNING_CONTAINER_COUNT=$(docker-compose ps | wc -l);
RUNNING_CONTAINER_COUNT=${RUNNING_CONTAINER_COUNT##*( )};

DOCKER_MACHINE_IP=$(docker-machine ip default);

if [ $RUNNING_CONTAINER_COUNT -eq 7 ]; then
  docker-compose stop && docker-compose rm -fv && docker-compose build;
fi

echo "Migrating database..."
docker-compose run web bundle exec rake db:create && docker-compose run web bundle exec rake db:migrate db:test:prepare

echo "Starting server..."

docker-compose up -d

echo "The CommonPlace application is booting! You can access it at http://${DOCKER_MACHINE_IP}:3000/ momentarily."
