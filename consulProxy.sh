#!/usr/bin/env bash

kubectl get pods
kubectl port-forward consul-0 8500:8500
kubectl port-forward rso-pdf-1662113259-cq5fr 8080:8080

