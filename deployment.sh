#!bin/bash
CURRENT_VERSION=$(docker images | grep leonardos37/timeoff | awk '{print $2}' | cut -c 2-4)
NEW_VERSION=$(echo "$CURRENT_VERSION + 1" | bc)
docker rmi timeoff:v$CURRENT_VERSION
echo "New Version $NEW_VERSION"
docker build -t timeoff:v$NEW_VERSION ./
docker image tag timeoff:v$NEW_VERSION leonardos37/timeoff:v$NEW_VERSION
docker image push leonardos37/timeoff:v$NEW_VERSION
docker-compose up