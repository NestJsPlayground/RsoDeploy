#!/usr/bin/env bash

gcloud container clusters get-credentials "fri-cluster" --zone "europe-west3-c"

echo "Creating secret..."
kubectl delete -f secret.yaml
kubectl create -f secret.yaml

rm -rf /tmp/KUBERNETES_DEPLOY
mkdir -p /tmp/KUBERNETES_DEPLOY
VERSION=`date +'%Y-%m-%d %H:%M:%S'`

if [ $1 = "del" ]; then
  ACTION="delete"
else
  ACTION="apply"
fi

PROJECT_DIR='/tmp/KUBERNETES_DEPLOY/seed'
mkdir -p "$PROJECT_DIR"
cp ./api-seed/kubernetes/* "$PROJECT_DIR/"
sed -i -e "s/%DEPLOY_VERSION%/$VERSION/g" "$PROJECT_DIR/app-statefulset.yaml"

echo "Deploying consul..."
kubectl "$ACTION" -f "$PROJECT_DIR/consul-service.yaml"
kubectl "$ACTION" -f "$PROJECT_DIR/consul-statefulset.yaml"

echo "Deploying seed..."
kubectl "$ACTION" -f "$PROJECT_DIR/app-statefulset.yaml"
kubectl "$ACTION" -f "$PROJECT_DIR/app-service.yaml"

