#!bin/bash
IMAGE=$(kubectl get deploy/timeoff -o jsonpath="{..image}{'\n'}")
echo image
echo $IMAGE
echo current Version
CURRENT_VERSION=$(echo $IMAGE| cut -c 22-25)
echo $CURRENT_VERSION
NEW_VERSION=$(echo "$CURRENT_VERSION + 0.1" | bc)
docker rmi timeoff:v$CURRENT_VERSION
echo "New Version $NEW_VERSION"
docker build -t timeoff:v$NEW_VERSION ./
docker image tag timeoff:v$NEW_VERSION leonardos37/timeoff:v$NEW_VERSION
docker image push leonardos37/timeoff:v$NEW_VERSION
kubectl -n default --record deployment.apps/timeoff set image deployment.v1.apps/timeoff timeoff=lesarmiento37/timeoff:v$NEW_VERSION
#docker-compose up