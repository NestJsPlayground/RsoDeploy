#!/usr/bin/env bash

gcloud config set project icowatch-185821
# gcloud container clusters create "fri-cluster" --zone "europe-west3-c" --machine-type "f1-micro" --image-type "COS" --disk-size "12" --num-nodes "3"
gcloud beta container --project "icowatch-185821" clusters create "fri-cluster" --zone "europe-west3-c" --username "admin" --cluster-version "1.7.11-gke.1" --machine-type "n1-standard-1" --image-type "COS" --disk-size "100" --scopes "https://www.googleapis.com/auth/compute","https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --num-nodes "4" --network "default" --enable-cloud-logging --enable-cloud-monitoring --subnetwork "default" --enable-autoscaling --min-nodes "4" --max-nodes "6" --enable-legacy-authorization
