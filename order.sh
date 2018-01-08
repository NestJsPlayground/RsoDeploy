#!/usr/bin/env bash

gcloud container clusters get-credentials "fri-cluster" --zone "europe-west3-c"

if [[ $1 = "-s" ]]; then
  echo "Creating secret..."
  kubectl delete -f secret.yaml
  kubectl create -f secret.yaml
  exit 1;
fi

rm -rf /tmp/KUBERNETES_DEPLOY
mkdir -p /tmp/KUBERNETES_DEPLOY
VERSION=`date +'%Y-%m-%d %H:%M:%S'`

if [[ $1 = "-d" ]]; then
  ACTION="delete"
else
  ACTION="apply"
fi
echo "Action: $ACTION";

echo "Deploying order..."
PROJECT_DIR='/tmp/KUBERNETES_DEPLOY/order'
mkdir -p "$PROJECT_DIR"
cp ./rso-order/kubernetes/* "$PROJECT_DIR/"
sed -i -e "s/%DEPLOY_VERSION%/$VERSION/g" "$PROJECT_DIR/app-statefulset.yaml"
kubectl "$ACTION" -f "$PROJECT_DIR/app-statefulset.yaml"
kubectl "$ACTION" -f "$PROJECT_DIR/app-service.yaml"