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


echo "Deploying auth..."
PROJECT_DIR='/tmp/KUBERNETES_DEPLOY/auth'
mkdir -p "$PROJECT_DIR"
cp ./rso-auth/kubernetes/* "$PROJECT_DIR/"
sed -i -e "s/%DEPLOY_VERSION%/$VERSION/g" "$PROJECT_DIR/app-statefulset.yaml"
kubectl "$ACTION" -f "$PROJECT_DIR/app-statefulset.yaml"
kubectl "$ACTION" -f "$PROJECT_DIR/app-service.yaml"


echo "Deploying store..."
PROJECT_DIR='/tmp/KUBERNETES_DEPLOY/store'
mkdir -p "$PROJECT_DIR"
cp ./rso-store/kubernetes/* "$PROJECT_DIR/"
sed -i -e "s/%DEPLOY_VERSION%/$VERSION/g" "$PROJECT_DIR/app-statefulset.yaml"
kubectl "$ACTION" -f "$PROJECT_DIR/app-statefulset.yaml"
kubectl "$ACTION" -f "$PROJECT_DIR/app-service.yaml"

echo "Deploying exec..."
PROJECT_DIR='/tmp/KUBERNETES_DEPLOY/exec'
mkdir -p "$PROJECT_DIR"
cp ./rso-exec/kubernetes/* "$PROJECT_DIR/"
sed -i -e "s/%DEPLOY_VERSION%/$VERSION/g" "$PROJECT_DIR/app-statefulset.yaml"
kubectl "$ACTION" -f "$PROJECT_DIR/app-statefulset.yaml"
kubectl "$ACTION" -f "$PROJECT_DIR/app-service.yaml"

echo "Deploying web..."
PROJECT_DIR='/tmp/KUBERNETES_DEPLOY/web'
mkdir -p "$PROJECT_DIR"
cp ./rso-web/kubernetes/* "$PROJECT_DIR/"
sed -i -e "s/%DEPLOY_VERSION%/$VERSION/g" "$PROJECT_DIR/app-statefulset.yaml"
kubectl "$ACTION" -f "$PROJECT_DIR/app-statefulset.yaml"
kubectl "$ACTION" -f "$PROJECT_DIR/app-service.yaml"