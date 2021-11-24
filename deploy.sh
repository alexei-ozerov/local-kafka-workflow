#!/bin/bash

#
# Alexei Ozerov
# github.com/alexei-ozerov
# alexei.ozerov.7@gmail.com
#
# Local MiniKube Deployment Management Script
#

# Required
DOCKERFILE=$1
REPO=$2
IMAGE_NAME=$3


# Default Overrides
POD_NAME=$4
CONTAINER_ENGINE=$5


if [ -z "${DOCKERFILE}" ]; then
  echo -e "No Dockerfile specified; exiting."
  exit 1
fi


if [ -z "${REPO}" ]; then
  echo -e "No Repo specified; exiting."
  exit 1
fi


if [ -z "${IMAGE_NAME}" ]; then
  echo -e "No Image Tag specified; exiting."
  exit 1
fi


if [ -z "${POD_NAME}" ]; then
  echo -e "No Pod Name specified; defaulting to Image Name."
  POD_NAME=${IMAGE_NAME}
fi


if [ -z "${CONTAINER_ENGINE}" ]; then
  echo -e "No Container Engine specified; defaulting to Podman."
  CONTAINER_ENGINE="podman"
fi


# building image, re-tagging the image to aim for the
# local repository, and finally pushing to minikube
echo -e "\n\nBuilding, Tagging, Pushing Image ..."
${CONTAINER_ENGINE} build --tag $(minikube ip):5000/${IMAGE_NAME} -f ${DOCKERFILE}
echo -e "If the following step fails, please make sure you have port-forwarded your registry from within MiniKube."
${CONTAINER_ENGINE} push $(minikube ip):5000/${IMAGE_NAME}

echo -e "\n\nCreating deployment ...\n"
# create deployment inside local cluster
kubectl delete deployment -n ${NAMESPACE} ${POD_NAME}-deployment
cat > pod.yaml <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ${POD_NAME}-deployment
  labels:
    app: ${POD_NAME}
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ${POD_NAME}
  template:
    metadata:
      labels:
        app: ${POD_NAME}
    spec:
      containers:
      - name: ${POD_NAME}
        image: localhost:5000/${IMAGE_NAME}
EOF
kubectl apply -f pod.yaml
rm -rf pod.yaml

exit 0
